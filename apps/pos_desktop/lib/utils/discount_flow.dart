import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../blocs/cart/cart_event.dart';
import '../widgets/dialogs/apply_discount_dialog.dart';
import 'security_guard.dart';

/// Lance le flux remise : saisie → PIN Manager si besoin → événement panier.
Future<bool> runCartDiscountFlow({
  required BuildContext context,
  required User currentUser,
  required CompleteOrder order,
  required void Function(CartDiscountApplied event) onApply,
}) async {
  final request = await showApplyDiscountDialog(
    context,
    maxFixedAmount: order.displaySubtotal,
  );
  if (request == null || !context.mounted) {
    return false;
  }

  final manager = await SecurityGuard.authorize(
    context,
    SecurityOperations.applyDiscount,
    currentUser: currentUser,
  );
  if (manager == null || !context.mounted) {
    return false;
  }

  onApply(
    CartDiscountApplied(
      managerUserId: manager.id,
      discountType: request.discountType,
      discountValue: request.discountValue,
      reason: request.reason,
      requestedByUserId:
          manager.id != currentUser.id ? currentUser.id : null,
    ),
  );
  return true;
}
