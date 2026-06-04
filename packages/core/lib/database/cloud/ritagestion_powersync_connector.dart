import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';

import 'cloud_sync_config.dart';

final _log = Logger('ritagestion.powersync');

/// Codes Postgres non récupérables (aligné demo PowerSync + Supabase).
final _fatalResponsePattern = RegExp(r'^(22|23)|42501');

/// Connecteur PowerSync → Supabase pour upload bidirectionnel.
class RitagestionPowerSyncConnector extends PowerSyncBackendConnector {
  RitagestionPowerSyncConnector(this._config);

  final CloudSyncConfig _config;
  String? _cachedJwt;

  @override
  Future<PowerSyncCredentials?> fetchCredentials() async {
    final jwt = _cachedJwt ?? _config.jwtToken;
    final endpoint = _config.powerSyncUrl;
    if (jwt == null || jwt.isEmpty || endpoint == null || endpoint.isEmpty) {
      return null;
    }

    return PowerSyncCredentials(
      endpoint: endpoint,
      token: jwt,
      userId: _config.userId ?? 'ritagestion-pos',
    );
  }

  /// Met à jour le JWT (ex. refresh Supabase Auth côté app).
  void updateJwt(String? jwt) {
    _cachedJwt = jwt;
    invalidateCredentials();
  }

  @override
  void invalidateCredentials() {
    // Le refresh sera géré par la couche auth Supabase (Sprint 5+).
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
