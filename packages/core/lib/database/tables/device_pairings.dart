import 'package:drift/drift.dart';
import '../../utils/uuid_generator.dart';

import 'users.dart';

/// Enregistrement de couplage (pairing) entre un terminal mobile et la caisse PC.
///
/// Security fix [HAUTE-N02] — chaque terminal doit être couplé via un token
/// temporaire avant de pouvoir se connecter au serveur WebSocket.
class DevicePairings extends Table {
  TextColumn get id => text().clientDefault(newUuid)();
  TextColumn get deviceId => text()();
  TextColumn get deviceName => text().nullable()();

  /// Token secret (UUID) généré par le POS desktop et scanné via QR code.
  TextColumn get pairingToken => text()();

  /// Statut : PENDING (en attente de confirmation manager), ACTIVE, REVOKED.
  TextColumn get status =>
      text().withDefault(const Constant('PENDING'))();

  /// Utilisateur (manager) qui a confirmé le couplage.
  @ReferenceName('device_pairing_confirmer')
  TextColumn get confirmedBy =>
      text().nullable().references(Users, #id)();

  DateTimeColumn get pairedAt => dateTime()();
  DateTimeColumn get expiresAt => dateTime()();
  DateTimeColumn get confirmedAt => dateTime().nullable()();
  DateTimeColumn get revokedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}