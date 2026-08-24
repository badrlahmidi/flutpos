import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../utils/uuid_generator.dart';

/// Repository gérant le couplage des terminaux (security fix [HAUTE-N02]).
class DevicePairingRepository {
  DevicePairingRepository(this._db);

  final AppDatabase _db;

  /// Crée une demande de couplage : génère un token UUID valable 5 minutes.
  Future<DevicePairing> createPairingRequest({
    required String deviceId,
    String? deviceName,
    Duration validity = const Duration(minutes: 5),
  }) async {
    final now = DateTime.now();
    final token = newUuid();
    await _db.into(_db.devicePairings).insert(
          DevicePairingsCompanion.insert(
            deviceId: deviceId,
            deviceName: Value(deviceName),
            pairingToken: token,
            status: const Value('PENDING'),
            pairedAt: now,
            expiresAt: now.add(validity),
          ),
        );

    return (_db.select(_db.devicePairings)
          ..where((t) => t.pairingToken.equals(token)))
        .getSingle();
  }

  /// Valide un token de couplage sans le confirmer.
  /// Retourne `true` si le token existe, est PENDING et non expiré.
  Future<bool> isTokenValid(String pairingToken) async {
    final now = DateTime.now();
    final query = _db.select(_db.devicePairings)
      ..where((t) => t.pairingToken.equals(pairingToken))
      ..where((t) => t.status.equals('PENDING'))
      ..where((t) => t.expiresAt.isBiggerOrEqualValue(now));

    final result = await query.get();
    return result.isNotEmpty;
  }

  /// Confirme un couplage (manager PIN already checked by caller).
  Future<DevicePairing?> confirmPairing({
    required String pairingToken,
    required String confirmedBy,
  }) async {
    final now = DateTime.now();
    final query = _db.select(_db.devicePairings)
      ..where((t) => t.pairingToken.equals(pairingToken))
      ..where((t) => t.status.equals('PENDING'))
      ..where((t) => t.expiresAt.isBiggerOrEqualValue(now));

    final pairing = await query.getSingleOrNull();
    if (pairing == null) return null;

    await (_db.update(_db.devicePairings)
          ..where((t) => t.id.equals(pairing.id)))
        .write(DevicePairingsCompanion(
      status: const Value('ACTIVE'),
      confirmedBy: Value(confirmedBy),
      confirmedAt: Value(now),
    ));

    return (_db.select(_db.devicePairings)
          ..where((t) => t.id.equals(pairing.id)))
        .getSingle();
  }

  /// Vérifie qu'un deviceId est actif (pairé et confirmé).
  Future<bool> isDeviceActive(String deviceId) async {
    final query = _db.select(_db.devicePairings)
      ..where((t) => t.deviceId.equals(deviceId))
      ..where((t) => t.status.equals('ACTIVE'));

    final result = await query.get();
    return result.isNotEmpty;
  }

  /// Révoque un couplage.
  Future<void> revokePairing(String deviceId) async {
    final now = DateTime.now();
    await (_db.update(_db.devicePairings)
          ..where((t) => t.deviceId.equals(deviceId))
          ..where((t) => t.status.equals('ACTIVE')))
        .write(DevicePairingsCompanion(
      status: const Value('REVOKED'),
      revokedAt: Value(now),
    ));
  }

  /// Liste les terminaux pairés actifs.
  Future<List<DevicePairing>> getActivePairings() async {
    final query = _db.select(_db.devicePairings)
      ..where((t) => t.status.equals('ACTIVE'))
      ..orderBy([(t) => OrderingTerm.desc(t.confirmedAt)]);
    return query.get();
  }

  /// Nombre de devices pairés actifs (limite max 3, security fix [HAUTE-N02]).
  Future<int> activePairingsCount() async {
    final active = await getActivePairings();
    return active.length;
  }

  /// Supprime les demandes de couplage expirées (nettoyage périodique).
  Future<int> purgeExpiredPairings() async {
    final now = DateTime.now();
    final expired = await (_db.select(_db.devicePairings)
          ..where((t) => t.status.equals('PENDING'))
          ..where((t) => t.expiresAt.isSmallerOrEqualValue(now)))
        .get();

    for (final pairing in expired) {
      await (_db.delete(_db.devicePairings)
            ..where((t) => t.id.equals(pairing.id)))
          .go();
    }
    return expired.length;
  }
}