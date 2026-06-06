import '../database/app_database.dart';

abstract class VoucherRepository {
  Future<Voucher?> getVoucherByCode(String code);
  
  /// Valide un voucher (par son code), le marque comme consommé, et retourne la remise correspondante.
  /// Lance une exception si le voucher n'existe pas, est déjà utilisé ou inactif.
  Future<Voucher> validateAndUseVoucher({
    required String code,
    required String orderId,
  });
}
