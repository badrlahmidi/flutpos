import 'dart:io' show Platform;

/// Configuration cloud PowerSync / Supabase (variables d'environnement).
final class CloudSyncConfig {
  const CloudSyncConfig({
    required this.enabled,
    this.powerSyncUrl,
    this.supabaseUrl,
    this.supabaseAnonKey,
    this.jwtToken,
    this.userId,
    this.restaurantId,
  });

  /// Cloud désactivé — base Drift native uniquement (comportement Sprints 0–4).
  const CloudSyncConfig.disabled()
      : enabled = false,
        powerSyncUrl = null,
        supabaseUrl = null,
        supabaseAnonKey = null,
        jwtToken = null,
        userId = null,
        restaurantId = null;

  /// Active la réplication PowerSync (connexion optionnelle si JWT absent).
  final bool enabled;

  /// URL de l'instance PowerSync (ex. `https://xxx.powersync.journeyapps.com`).
  final String? powerSyncUrl;

  /// URL Supabase (ex. `https://xxx.supabase.co`).
  final String? supabaseUrl;

  /// Clé anon Supabase (upload REST côté client authentifié).
  final String? supabaseAnonKey;

  /// JWT Supabase / PowerSync (mock dev via `RITAGESTION_CLOUD_JWT`).
  final String? jwtToken;

  /// Identifiant utilisateur lié au token (debug / multi-tenant).
  final String? userId;

  /// Identifiant restaurant (tenant) pour filtrage sync rules.
  final String? restaurantId;

  bool get canConnect =>
      enabled &&
      powerSyncUrl != null &&
      powerSyncUrl!.isNotEmpty &&
      jwtToken != null &&
      jwtToken!.isNotEmpty;

  bool get canUploadToSupabase =>
      supabaseUrl != null &&
      supabaseUrl!.isNotEmpty &&
      supabaseAnonKey != null &&
      supabaseAnonKey!.isNotEmpty &&
      jwtToken != null &&
      jwtToken!.isNotEmpty;

  /// Lit la configuration depuis les variables d'environnement du processus.
  factory CloudSyncConfig.fromEnvironment() {
    return CloudSyncConfig(
      enabled: _envFlag('RITAGESTION_CLOUD_SYNC'),
      powerSyncUrl: _envString('RITAGESTION_POWERSYNC_URL'),
      supabaseUrl: _envString('RITAGESTION_SUPABASE_URL'),
      supabaseAnonKey: _envString('RITAGESTION_SUPABASE_ANON_KEY'),
      jwtToken: _envString('RITAGESTION_CLOUD_JWT'),
      userId: _envString('RITAGESTION_CLOUD_USER_ID'),
      restaurantId: _envString('RITAGESTION_RESTAURANT_ID'),
    );
  }
}

bool _envFlag(String key) {
  final raw = _envString(key);
  if (raw == null) {
    return false;
  }
  return raw == '1' || raw.toLowerCase() == 'true';
}

String? _envString(String key) {
  final compile = String.fromEnvironment(key, defaultValue: '');
  if (compile.isNotEmpty) {
    return compile;
  }
  final platform = Platform.environment[key];
  if (platform == null || platform.isEmpty) {
    return null;
  }
  return platform;
}
