import 'package:drift/drift.dart';
import '../../utils/uuid_generator.dart';

import 'users.dart';

/// Sessions authentifiées actives (security fix [HAUTE-A04]).
///
/// Chaque terminal pairé doit posséder un `sessionToken` valide avant de
/// pouvoir exécuter des commandes WebSocket. Le token expire après 8h
/// d'inactivité.
class ActiveSessions extends Table {
  TextColumn get id => text().clientDefault(newUuid)();
  TextColumn get sessionToken => text()();

  /// Utilisateur authentifié (récupère le rôle pour RBAC).
  @ReferenceName('active_session_user')
  TextColumn get userId => text().references(Users, #id)();

  /// Terminal sur lequel la session est ouverte.
  TextColumn get deviceId => text().nullable()();

  DateTimeColumn get issuedAt => dateTime()();
  DateTimeColumn get lastActivityAt => dateTime()();

  /// Expiration absolue (défaut : now + 8h).
  DateTimeColumn get expiresAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}