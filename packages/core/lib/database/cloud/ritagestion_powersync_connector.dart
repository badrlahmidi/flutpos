import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';

import 'cloud_sync_config.dart';

final _log = Logger('ritagestion.powersync');

/// Codes Postgres non récupérables (aligné demo PowerSync + Supabase).
final _fatalResponsePattern = RegExp(r'^(22|23)|42501');

/// Connecteur PowerSync → Supabase pour upload bidirectionnel.
///
/// [CRIT-C01] Implémente le refresh JWT via l'API GoTrue de Supabase.
/// [HAUTE-C02] userId obligatoire (plus de fallback 'ritagestion-pos').
/// [MOY-C03] invalidateCredentials() déclenche un re-fetch du token.
class RitagestionPowerSyncConnector extends PowerSyncBackendConnector {
  RitagestionPowerSyncConnector(this._config);

  final CloudSyncConfig _config;
  String? _cachedJwt;
  String? _refreshToken;
  DateTime? _tokenExpiresAt;

  /// Durée de marge avant expiration pour déclencher un refresh anticipé.
  static const _refreshMargin = Duration(minutes: 2);

  @override
  Future<PowerSyncCredentials?> fetchCredentials() async {
    // Tenter un refresh si le token est expiré ou proche de l'expiration.
    if (_shouldRefresh()) {
      await _performTokenRefresh();
    }

    final jwt = _cachedJwt ?? _config.jwtToken;
    final endpoint = _config.powerSyncUrl;
    if (jwt == null || jwt.isEmpty || endpoint == null || endpoint.isEmpty) {
      return null;
    }

    // [HAUTE-C02] userId obligatoire — pas de fallback hardcodé.
    final userId = _config.userId;
    if (userId == null || userId.isEmpty) {
      _log.warning(
        'userId manquant dans CloudSyncConfig. '
        'Définissez RITAGESTION_CLOUD_USER_ID pour éviter les collisions multi-tenant.',
      );
      return null;
    }

    return PowerSyncCredentials(
      endpoint: endpoint,
      token: jwt,
      userId: userId,
    );
  }

  /// Met à jour le JWT (ex. refresh Supabase Auth côté app).
  void updateJwt(String? jwt) {
    _cachedJwt = jwt;
    _tokenExpiresAt = jwt != null ? _extractExpiry(jwt) : null;
    invalidateCredentials();
  }

  /// Met à jour le refresh token (fourni par Supabase Auth).
  void updateRefreshToken(String? token) {
    _refreshToken = token;
  }

  @override
  void invalidateCredentials() {
    // [MOY-C03] Force un re-fetch des credentials au prochain cycle sync.
    _cachedJwt = null;
    _tokenExpiresAt = null;
    super.invalidateCredentials();
  }

  /// Vérifie si un refresh token est nécessaire.
  bool _shouldRefresh() {
    if (_refreshToken == null || _refreshToken!.isEmpty) return false;
    if (_tokenExpiresAt == null) return true;
    return DateTime.now().isAfter(_tokenExpiresAt!.subtract(_refreshMargin));
  }

  /// Effectue le refresh JWT via l'API GoTrue de Supabase.
  Future<void> _performTokenRefresh() async {
    final supabaseUrl = _config.supabaseUrl;
    final anonKey = _config.supabaseAnonKey;
    final refreshToken = _refreshToken;

    if (supabaseUrl == null ||
        anonKey == null ||
        refreshToken == null ||
        refreshToken.isEmpty) {
      _log.fine('Refresh impossible : URL Supabase ou refresh token manquant.');
      return;
    }

    final baseUrl = supabaseUrl.replaceAll(RegExp(r'/+$'), '');
    final uri = Uri.parse('$baseUrl/auth/v1/token?grant_type=refresh_token');

    try {
      final response = await http.post(
        uri,
        headers: {
          'apikey': anonKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'refresh_token': refreshToken}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final newAccessToken = body['access_token'] as String?;
        final newRefreshToken = body['refresh_token'] as String?;
        final expiresIn = body['expires_in'] as int?;

        if (newAccessToken != null && newAccessToken.isNotEmpty) {
          _cachedJwt = newAccessToken;
          _tokenExpiresAt = expiresIn != null
              ? DateTime.now().add(Duration(seconds: expiresIn))
              : _extractExpiry(newAccessToken);
          _log.info('JWT refreshed — expire dans ${expiresIn ?? "?"}s.');
        }

        if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
          _refreshToken = newRefreshToken;
        }
      } else {
        _log.warning(
          'Refresh JWT échoué: HTTP ${response.statusCode} — ${response.body}',
        );
      }
    } catch (e) {
      _log.warning('Erreur réseau refresh JWT: $e');
    }
  }

  /// Extrait l'expiration (exp) du payload JWT (sans vérification de signature).
  DateTime? _extractExpiry(String jwt) {
    try {
      final parts = jwt.split('.');
      if (parts.length != 3) return null;
      final payload = parts[1];
      // Ajouter le padding base64 manquant.
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final data = jsonDecode(decoded) as Map<String, dynamic>;
      final exp = data['exp'];
      if (exp is int) {
        return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      }
    } catch (_) {
      // JWT malformé — on ignore silencieusement.
    }
    return null;
  }

  @override
  Future<void> uploadData(PowerSyncDatabase database) async {
    if (!_config.canUploadToSupabase) {
      return;
    }

    final transaction = await database.getNextCrudTransaction();
    if (transaction == null) {
      return;
    }

    final baseUrl = _config.supabaseUrl!.replaceAll(RegExp(r'/+$'), '');
    final anonKey = _config.supabaseAnonKey!;
    final jwt = _cachedJwt ?? _config.jwtToken!;

    CrudEntry? lastOp;
    try {
      for (final op in transaction.crud) {
        lastOp = op;
        final uri = Uri.parse('$baseUrl/rest/v1/${op.table}');
        final headers = {
          'apikey': anonKey,
          'Authorization': 'Bearer $jwt',
          'Content-Type': 'application/json',
          'Prefer': 'return=minimal',
        };

        switch (op.op) {
          case UpdateType.put:
            final data = Map<String, dynamic>.of(op.opData!);
            data['id'] = op.id;
            final response = await http.post(
              uri,
              headers: {...headers, 'Prefer': 'resolution=merge-duplicates'},
              body: jsonEncode(data),
            );
            _ensureSuccess(response, op);
          case UpdateType.patch:
            final response = await http.patch(
              Uri.parse('$uri?id=eq.${op.id}'),
              headers: headers,
              body: jsonEncode(op.opData),
            );
            _ensureSuccess(response, op);
          case UpdateType.delete:
            final response = await http.delete(
              Uri.parse('$uri?id=eq.${op.id}'),
              headers: headers,
            );
            _ensureSuccess(response, op);
        }
      }
      await transaction.complete();
    } on _SupabaseUploadException catch (e) {
      if (e.code != null && _fatalResponsePattern.hasMatch(e.code!)) {
        _log.severe('Upload fatal — transaction ignorée ($lastOp)', e);
        await transaction.complete();
      } else {
        rethrow;
      }
    }
  }
}

void _ensureSuccess(http.Response response, CrudEntry op) {
  if (response.statusCode >= 200 && response.statusCode < 300) {
    return;
  }

  String? code;
  try {
    final body = jsonDecode(response.body);
    if (body is Map && body['code'] is String) {
      code = body['code'] as String;
    }
  } catch (_) {
    // ignore parse errors
  }

  throw _SupabaseUploadException(
    'Upload ${op.table} ${op.op.toJson()} → HTTP ${response.statusCode}',
    code: code,
  );
}

final class _SupabaseUploadException implements Exception {
  _SupabaseUploadException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => message;
}
