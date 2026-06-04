import 'package:core/core.dart';

import 'package:intl/intl.dart';



import '../../utils/price_formatter.dart';



/// Contenu texte des tickets (simulation + ESC/POS).

abstract final class TicketContentBuilder {

  TicketContentBuilder._();



  static final DateFormat _dateTime = DateFormat('dd/MM/yyyy HH:mm', 'fr_FR');



  static List<String> buildKitchenTicket({

    required RestaurantConfigData? config,

    required PrintStation station,

    required CompleteOrder order,

    required List<OrderItemWithProduct> lines,

  }) {

    if (lines.isEmpty) {

      return [];

    }



    final restaurant = config?.name ?? 'Ritagestion';

    final buffer = <String>[

      '*** ${station.name.toUpperCase()} ***',

      restaurant,

      _dateTime.format(DateTime.now()),

      'Commande ${order.order.id.substring(0, 8)}',

      'Type: ${_orderTypeLabel(order.orderType)}',

      'Serveur: ${order.waiter.name}',

      '--------------------------------',

    ];



    for (final line in lines) {

      final qty = _formatQty(line.orderItem.quantity);

      buffer.add('$qty x ${line.product.name}');

      if (line.modifierSummary.isNotEmpty) {

        buffer.add('   > ${line.modifierSummary}');

      }

      if (line.orderItem.customNotes != null &&

          line.orderItem.customNotes!.isNotEmpty) {

        buffer.add('   Note: ${line.orderItem.customNotes}');

      }

    }



    buffer.addAll(['--------------------------------', '']);

    return buffer;

  }

  /// Ticket d'annulation cuisine (VOID).

  static List<String> buildKitchenVoidTicket({

    required RestaurantConfigData? config,

    required PrintStation station,

    required CompleteOrder order,

    required List<OrderItemWithProduct> lines,

    required String reason,

  }) {

    if (lines.isEmpty) {

      return [];

    }



    final restaurant = config?.name ?? 'Ritagestion';

    final buffer = <String>[

      '*** ANNULATION ***',

      '*** ${station.name.toUpperCase()} ***',

      restaurant,

      _dateTime.format(DateTime.now()),

      'Commande ${order.order.id.substring(0, 8)}',

      'RAISON: $reason',

      '--------------------------------',

    ];



    for (final line in lines) {

      final qty = _formatQty(line.orderItem.quantity);

      buffer.add('-$qty x ${line.product.name}');

      if (line.modifierSummary.isNotEmpty) {

        buffer.add('   > ${line.modifierSummary}');

      }

    }



    buffer.addAll(['--------------------------------', '']);

    return buffer;

  }



  /// Reçu client final avec décomposition TVA et paiements.

  static List<String> buildCustomerReceipt({

    required RestaurantConfigData? config,

    required CompleteOrder order,

    OrderTotalResult? totals,

  }) {

    return _buildSalesTicket(

      config: config,

      order: order,

      totals: totals,

      title: 'RECU CLIENT',

      footerNote: 'Merci de votre visite !',

      showPayments: true,

    );

  }



  /// Facture entreprise avec ICE client et restaurant.
  static List<String> buildEnterpriseInvoice({
    required RestaurantConfigData? config,
    required CompleteOrder order,
    OrderTotalResult? totals,
  }) {
    final companyName = order.order.companyName ?? '';
    final companyIce = order.order.companyIce ?? '';
    final invoiceNo = order.order.invoiceNumber;

    final lines = _buildSalesTicket(
      config: config,
      order: order,
      totals: totals,
      title: 'FACTURE',
      footerNote: 'Facture établie conformément à la réglementation marocaine.',
      showPayments: true,
      proforma: false,
    );

    final header = <String>[
      if (invoiceNo != null) 'N° Facture: $invoiceNo',
      '--------------------------------',
      'CLIENT ENTREPRISE',
      companyName,
      'ICE client: $companyIce',
      '--------------------------------',
    ];

    return [...lines.take(1), ...header, ...lines.skip(1)];
  }

  /// Rapport Z — clôture de session.
  static List<String> buildZReport({
    required RestaurantConfigData? config,
    required CashSessionReport report,
    double? closingBalance,
    double? variance,
    String? closingNote,
  }) {
    final restaurant = config?.name ?? 'Ritagestion';
    final session = report.session;
    final buffer = <String>[
      '*** RAPPORT Z ***',
      restaurant,
      if (config?.ice != null) 'ICE: ${config!.ice}',
      _dateTime.format(DateTime.now()),
      '--------------------------------',
      'Session ${session.id.substring(0, 8)}',
      'Caissier: ${report.cashierName}',
      'Ouverture: ${_dateTime.format(session.openedAt.toLocal())}',
      if (session.closedAt != null)
        'Clôture: ${_dateTime.format(session.closedAt!.toLocal())}',
      '--------------------------------',
      'Fond caisse:     ${PriceFormatter.format(report.openingBalance)}',
      'Ventes espèces: ${PriceFormatter.format(report.cashSales)}',
      'Ventes carte:   ${PriceFormatter.format(report.cardSales)}',
      'Autres:         ${PriceFormatter.format(report.otherSales)}',
      'Total ventes:   ${PriceFormatter.format(report.totalSales)}',
      'Pay-in:         ${PriceFormatter.format(report.payInTotal)}',
      'Pay-out:        ${PriceFormatter.format(report.payOutTotal)}',
      '--------------------------------',
      'THEORIQUE:      ${PriceFormatter.format(report.expectedCashBalance)}',
    ];

    if (closingBalance != null) {
      buffer.add('REEL (compte):  ${PriceFormatter.format(closingBalance)}');
    }
    if (variance != null && variance.abs() > 0.009) {
      buffer.add('ECART:          ${PriceFormatter.format(variance)}');
      if (closingNote != null && closingNote.isNotEmpty) {
        buffer.add('Note: $closingNote');
      }
    }
    buffer.addAll([
      '--------------------------------',
      'Tickets payés: ${report.paidOrdersCount}',
      'Tickets ouverts: ${report.openOrdersCount}',
      '',
    ]);
    return buffer;
  }

  /// Note provisoire (non valable pour paiement fiscal).

  static List<String> buildProformaTicket({

    required RestaurantConfigData? config,

    required CompleteOrder order,

    OrderTotalResult? totals,

  }) {

    return _buildSalesTicket(

      config: config,

      order: order,

      totals: totals,

      title: 'NOTE PROFORMA',

      footerNote: 'Document provisoire — non valable pour paiement',

      showPayments: false,

      proforma: true,

    );

  }



  static List<String> _buildSalesTicket({

    required RestaurantConfigData? config,

    required CompleteOrder order,

    OrderTotalResult? totals,

    required String title,

    required String footerNote,

    required bool showPayments,

    bool proforma = false,

  }) {

    final restaurant = config?.name ?? 'Ritagestion';

    final computed = totals ??

        CalculateOrderTotal.call(

          lines: PaymentOrderMapper.toLineInputs(order),

          discount: PaymentOrderMapper.toDiscountInput(order.order),

        );

    final taxLines = TaxBreakdown.fromLines(

      PaymentOrderMapper.toLineInputs(order),

    );



    final buffer = <String>[

      '*** $title ***',

      restaurant,

      if (config?.address != null) config!.address!,

      if (config?.phone != null) 'Tel: ${config!.phone}',

      if (config?.ice != null) 'ICE: ${config!.ice}',

      _dateTime.format(DateTime.now()),

      '--------------------------------',

      'Ticket ${order.order.id.substring(0, 8)}',

      'Type: ${_orderTypeLabel(order.orderType)}',

      'Caissier: ${order.waiter.name}',

      if (proforma) 'Statut: PROFORMA (table verrouillée)',

      '--------------------------------',

    ];



    for (final line in order.items) {

      final qty = _formatQty(line.orderItem.quantity);

      buffer.add('$qty x ${line.product.name}');

      if (line.modifierSummary.isNotEmpty) {

        buffer.add('   ${line.modifierSummary}');

      }

      buffer.add('   ${PriceFormatter.format(line.lineSubtotal)}');

    }



    buffer.add('--------------------------------');

    buffer.add('Sous-total: ${PriceFormatter.format(computed.subtotal)}');

    if (computed.discountAmount > 0) {

      buffer.add('Remise:   -${PriceFormatter.format(computed.discountAmount)}');

    }

    buffer.add('');

    buffer.add('Detail TVA:');

    for (final row in taxLines) {

      final rateLabel = _formatTaxRate(row.taxRate);

      buffer.add(

        '  $rateLabel — Base ${PriceFormatter.format(row.taxableBase)}',

      );

      buffer.add('           TVA ${PriceFormatter.format(row.taxAmount)}');

    }

    buffer.add('--------------------------------');

    buffer.add('TVA totale: ${PriceFormatter.format(computed.taxAmount)}');

    buffer.add('TOTAL TTC:  ${PriceFormatter.format(computed.grandTotal)}');



    if (showPayments && order.payments.isNotEmpty) {

      buffer.add('--------------------------------');

      buffer.add('Paiements:');

      for (final payment in order.payments) {

        final label =

            PaymentMethod.fromDb(payment.paymentMethod)?.label ??

                payment.paymentMethod;

        buffer.add('  $label: ${PriceFormatter.format(payment.amount)}');

      }

      final paid = roundMoney(

        order.payments.fold<double>(0, (s, p) => s + p.amount),

      );

      final remaining = roundMoney((computed.grandTotal - paid).clamp(0, double.infinity));

      if (remaining > 0.009) {

        buffer.add('Reste a payer: ${PriceFormatter.format(remaining)}');

      }

    }



    buffer.addAll(['--------------------------------', footerNote, '']);

    return buffer;

  }



  static String _formatTaxRate(double rate) {

    final rounded = rate == rate.roundToDouble() ? rate.toInt().toString() : rate.toStringAsFixed(1);

    return 'TVA $rounded%';

  }



  static String _formatQty(double quantity) {

    return quantity == quantity.roundToDouble()

        ? '${quantity.toInt()}'

        : quantity.toStringAsFixed(1);

  }



  static String _orderTypeLabel(OrderType type) {

    return switch (type) {

      OrderType.dineIn => 'Sur place',

      OrderType.takeaway => 'Emporter',

      OrderType.delivery => 'Livraison',

    };

  }

}


