import 'package:core/core.dart';

/// Sérialisation JSON d'une [CompleteOrder] pour sync mobile ↔ PC.
abstract final class OrderSnapshotCodec {
  OrderSnapshotCodec._();

  static Map<String, dynamic>? encode(CompleteOrder? order) {
    if (order == null) {
      return null;
    }
    final o = order.order;
    return {
      'order': {
        'id': o.id,
        'waiterId': o.waiterId,
        'tableId': o.tableId,
        'orderType': o.orderType,
        'status': o.status,
        'guestCount': o.guestCount,
        'createdAt': o.createdAt.toUtc().toIso8601String(),
        'updatedAt': o.updatedAt?.toUtc().toIso8601String(),
      },
      'items': [
        for (final line in order.items)
          {
            'id': line.orderItem.id,
            'productId': line.orderItem.productId,
            'quantity': line.orderItem.quantity,
            'unitPrice': line.orderItem.unitPrice,
            'taxRate': line.orderItem.taxRate,
            'courseNumber': line.orderItem.courseNumber,
            'isFired': line.orderItem.isFired,
            'status': line.orderItem.status,
            'customNotes': line.orderItem.customNotes,
            'createdAt': line.orderItem.createdAt.toUtc().toIso8601String(),
          },
      ],
    };
  }

  static Map<String, dynamic>? decodePayload(Map<String, dynamic> ackPayload) {
    final snapshot = ackPayload['snapshot'];
    if (snapshot == null) {
      return null;
    }
    if (snapshot is Map<String, dynamic>) {
      return snapshot;
    }
    return Map<String, dynamic>.from(snapshot as Map);
  }
}
