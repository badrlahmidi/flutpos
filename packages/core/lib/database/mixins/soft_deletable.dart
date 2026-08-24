import 'package:drift/drift.dart';

/// Mixin à appliquer sur les tables Drift sensibles (audit trail).
///
/// Security fix [MOY-D04] — standardise la colonne [deletedAt] pour le
/// soft-delete. Les repositories doivent filtrer avec `deletedAt IS NULL`.
mixin SoftDeletable on Table {
  DateTimeColumn get deletedAt => dateTime().nullable()();
}