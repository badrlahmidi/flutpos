import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Génère un UUID v4 pour les clés primaires Drift ([clientDefault]).
String newUuid() => _uuid.v4();
