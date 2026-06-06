import 'package:drift/drift.dart';

import '../database/app_database.dart';
import 'voucher_repository.dart';

class VoucherRepositoryImpl implements VoucherRepository {
  VoucherRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<Voucher?> getVoucherByCode(String code) {
    return (_db.select(_db.vouchers)..where((v) => v.code.equals(code)))
        .getSingleOrNull();
  }

  @override
  Future<Voucher> validateAndUseVoucher({
    required String code,
    required String orderId,
  }) async {
    final voucher = await getVoucherByCode(code);
    if (voucher == null) {
      throw StateError('Voucher introuvable ($code)');
    }
    if (voucher.status == 'USED') {
      throw StateError('Ce voucher a déjà été utilisé.');
    }
    if (voucher.status == 'CANCELLED') {
      throw StateError('Ce voucher est annulé.');
    }
    if (voucher.status != 'ACTIVE') {
      throw StateError('Ce voucher n\'est pas actif.');
    }

    final now = DateTime.now().toUtc();
    await (_db.update(_db.vouchers)..where((v) => v.id.equals(voucher.id)))
        .write(
      VouchersCompanion(
        status: const Value('USED'),
        orderId: Value(orderId),
        usedAt: Value(now),
      ),
    );

    return (_db.select(_db.vouchers)..where((v) => v.id.equals(voucher.id)))
        .getSingle();
  }
}
