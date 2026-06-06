import 'dart:async';

import 'dart:io';

import 'dart:ui' as ui;

import 'package:core/core.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart' show FontWeight, TextStyle;

import 'package:path/path.dart' as p;

import 'package:path_provider/path_provider.dart';

import 'package:unified_esc_pos_printer/unified_esc_pos_printer.dart';

import '../../utils/escpos_arabic_text.dart';



import 'print_config.dart';

import 'ticket_content_builder.dart';



/// Impression thermique : cuisine, client, proforma et tiroir-caisse.

class PosPrintService {

  PosPrintService({

    required PrintRepository printRepository,

    AuditRepository? auditRepository,

    bool? simulate,

  })  : _printRepository = printRepository,

        _auditRepository = auditRepository,

        simulate = simulate ?? PrintConfig.simulate;



  final PrintRepository _printRepository;

  final AuditRepository? _auditRepository;

  final bool simulate;

  final PrinterManager _printerManager = PrinterManager();



  /// Ticket cuisine asynchrone pour une ou plusieurs lignes (routage par catégorie).

  Future<void> printKitchenTickets({

    required CompleteOrder order,

    required List<OrderItemWithProduct> lines,

    int? firedCourseNumber,

    bool isCourseClaim = false,

  }) async {

    if (lines.isEmpty) {

      return;

    }



    final config = await _printRepository.getRestaurantConfig();

    final grouped = <String, List<OrderItemWithProduct>>{};

    final stationById = <String, PrintStation>{};



    for (final line in lines) {

      final station = await _printRepository.resolveStationForCategory(

        line.product.categoryId,

      );

      if (station == null || !station.isActive) {

        continue;

      }

      stationById[station.id] = station;

      grouped.putIfAbsent(station.id, () => []).add(line);

    }



    for (final entry in grouped.entries) {

      final station = stationById[entry.key]!;

      final content = TicketContentBuilder.buildKitchenTicket(

        config: config,

        station: station,

        order: order,

        lines: entry.value,

        groupIdenticalLines: PrintStationTags.isBar(station),

        firedCourseNumber: firedCourseNumber,

        isCourseClaim: isCourseClaim,

      );

      final host = station.ipAddress;

      if (host == null || host.isEmpty) {

        await _logSimulated(

          'Cuisine — ${station.name}',

          content,

          reason: 'IP manquante pour ${station.name}',

        );

        continue;

      }



      unawaited(

        _printToNetwork(

          stationName: station.name,

          host: host,

          lines: content,

        ),

      );

    }

  }



  /// Reçu client final (décomposition TVA + paiements).

  Future<PrintResult> printCustomerReceipt(CompleteOrder order) async {

    if (order.items.isEmpty) {

      return const PrintResult.failure('Panier vide');

    }



    final config = await _printRepository.getRestaurantConfig();

    final totals = CalculateOrderTotal.call(

      lines: PaymentOrderMapper.toLineInputs(order),

      discount: PaymentOrderMapper.toDiscountInput(order.order),

    );

    final content = TicketContentBuilder.buildCustomerReceipt(

      config: config,

      order: order,

      totals: totals,

    );



    return _printToNetwork(

      stationName: PrintConfig.customerPrinterName,

      host: PrintConfig.customerPrinterHost,

      lines: content,

      awaitCompletion: true,

    );

  }



  /// Tickets d'annulation cuisine (VOID).

  Future<void> printKitchenVoidTickets({

    required CompleteOrder order,

    required List<OrderItemWithProduct> lines,

    required String reason,

  }) async {

    if (lines.isEmpty) {

      return;

    }



    final config = await _printRepository.getRestaurantConfig();

    final grouped = <String, List<OrderItemWithProduct>>{};

    final stationById = <String, PrintStation>{};



    for (final line in lines) {

      final station = await _printRepository.resolveStationForCategory(

        line.product.categoryId,

      );

      if (station == null || !station.isActive) {

        continue;

      }

      stationById[station.id] = station;

      grouped.putIfAbsent(station.id, () => []).add(line);

    }



    for (final entry in grouped.entries) {

      final station = stationById[entry.key]!;

      final content = TicketContentBuilder.buildKitchenVoidTicket(

        config: config,

        station: station,

        order: order,

        lines: entry.value,

        reason: reason,

      );

      final host = station.ipAddress;

      if (host == null || host.isEmpty) {

        await _logSimulated(

          'Annulation — ${station.name}',

          content,

          reason: 'IP manquante pour ${station.name}',

        );

        continue;

      }



      unawaited(

        _printToNetwork(

          stationName: '${station.name} (VOID)',

          host: host,

          lines: content,

        ),

      );

    }

  }



  /// Facture entreprise (ICE client + ICE restaurant).
  Future<PrintResult> printEnterpriseInvoice(CompleteOrder order) async {
    if (order.items.isEmpty) {
      return const PrintResult.failure('Panier vide');
    }
    if (order.order.companyIce == null || order.order.companyIce!.isEmpty) {
      return const PrintResult.failure('Données facture manquantes');
    }

    final config = await _printRepository.getRestaurantConfig();
    final totals = CalculateOrderTotal.call(
      lines: PaymentOrderMapper.toLineInputs(order),
      discount: PaymentOrderMapper.toDiscountInput(order.order),
    );
    final content = TicketContentBuilder.buildEnterpriseInvoice(
      config: config,
      order: order,
      totals: totals,
    );

    return _printToNetwork(
      stationName: '${PrintConfig.customerPrinterName} (facture)',
      host: PrintConfig.customerPrinterHost,
      lines: content,
      awaitCompletion: true,
    );
  }

  /// Rapport Z de clôture session.
  Future<PrintResult> printZReport(
    CashSessionReport report, {
    double? closingBalance,
    double? variance,
    String? closingNote,
  }) async {
    final config = await _printRepository.getRestaurantConfig();
    final content = TicketContentBuilder.buildZReport(
      config: config,
      report: report,
      closingBalance: closingBalance,
      variance: variance,
      closingNote: closingNote,
    );

    return _printToNetwork(
      stationName: '${PrintConfig.customerPrinterName} (Z)',
      host: PrintConfig.customerPrinterHost,
      lines: content,
      awaitCompletion: true,
    );
  }

  /// Note provisoire — verrouillage géré par [OrderRepository.markOrderProforma].

  Future<PrintResult> printProforma(CompleteOrder order) async {

    if (order.items.isEmpty) {

      return const PrintResult.failure('Panier vide');

    }



    final config = await _printRepository.getRestaurantConfig();

    final totals = CalculateOrderTotal.call(

      lines: PaymentOrderMapper.toLineInputs(order),

      discount: PaymentOrderMapper.toDiscountInput(order.order),

    );

    final content = TicketContentBuilder.buildProformaTicket(

      config: config,

      order: order,

      totals: totals,

    );



    return _printToNetwork(

      stationName: '${PrintConfig.customerPrinterName} (proforma)',

      host: PrintConfig.customerPrinterHost,

      lines: content,

      awaitCompletion: true,

    );

  }



  /// Ouvre le tiroir-caisse (ESC/POS `ESC p 0` — pin 2).

  Future<PrintResult> openCashDrawer() async {

    return _withCustomerPrinter(

      stationLabel: 'Tiroir caisse',

      action: () async {

        await _printerManager.openCashDrawer(pin: CashDrawer.pin2);

        return const PrintResult.success('Tiroir caisse');

      },

      simulatedLines: const [

        '*** TIROIR CAISSE ***',

        'Commande ESC/POS : ouverture tiroir (pin 2)',

        '27 112 0 25 250 (équivalent driver)',

      ],

    );

  }



  /// Ouverture manuelle du tiroir — audit [CASH_DRAWER_OPEN] obligatoire.

  Future<PrintResult> openCashDrawerWithAudit({

    required String userId,

    required String sessionId,

    String? reason,

  }) async {

    final audit = _auditRepository;

    if (audit == null) {

      return const PrintResult.failure('Audit non configuré');

    }



    await audit.logActionTyped(

      userId: userId,

      action: AuditAction.cashDrawerOpen,

      targetType: AuditTargetType.cashSession,

      targetId: sessionId,

      details: {'reason': reason ?? 'Ouverture manuelle'},

    );



    return openCashDrawer();

  }



  Future<PrintResult> _withCustomerPrinter({

    required String stationLabel,

    required Future<PrintResult> Function() action,

    required List<String> simulatedLines,

  }) async {

    if (simulate || kIsWeb) {

      await _logSimulated(stationLabel, simulatedLines,

          host: PrintConfig.customerPrinterHost);

      return PrintResult.simulated(stationLabel);

    }



    try {

      await _printerManager.connect(

        NetworkPrinterDevice(

          name: stationLabel,

          host: PrintConfig.customerPrinterHost,

          port: PrintConfig.networkPort,

        ),

      );

      final result = await action();

      await _printerManager.disconnect();

      return result;

    } catch (e) {

      try {

        await _printerManager.disconnect();

      } catch (_) {}

      await _logSimulated(

        stationLabel,

        simulatedLines,

        host: PrintConfig.customerPrinterHost,

        reason: 'Erreur: $e',

      );

      return PrintResult.failure('$stationLabel : $e');

    }

  }



  Future<PrintResult> _printToNetwork({

    required String stationName,

    required String host,

    required List<String> lines,

    bool awaitCompletion = false,

  }) async {

    Future<PrintResult> job() async {

      if (simulate || kIsWeb) {

        await _logSimulated(stationName, lines, host: host);

        return PrintResult.simulated(stationName);

      }



      try {

        await _printerManager.connect(

          NetworkPrinterDevice(

            name: stationName,

            host: host,

            port: PrintConfig.networkPort,

          ),

        );



        final ticket = await Ticket.create(PaperSize.mm80);

        for (final line in lines) {
          final isHeader = line.startsWith('***');
          final align =
              isHeader ? PrintAlign.center : PrintAlign.left;
          if (EscPosArabicText.containsArabic(line)) {
            await ticket.textRaster(
              line,
              textDirection: ui.TextDirection.rtl,
              align: align,
              style: TextStyle(
                fontSize: isHeader ? 28 : 24,
                fontWeight:
                    isHeader ? FontWeight.bold : FontWeight.normal,
              ),
            );
          } else {
            ticket.text(
              line,
              align: align,
              style: isHeader
                  ? const PrintTextStyle(
                      bold: true,
                      height: TextSize.size2,
                    )
                  : const PrintTextStyle(),
            );
          }
        }

        ticket.cut();

        await _printerManager.printTicket(ticket);

        await _printerManager.disconnect();

        return PrintResult.success(stationName);

      } catch (e) {

        try {

          await _printerManager.disconnect();

        } catch (_) {}

        await _logSimulated(

          stationName,

          lines,

          host: host,

          reason: 'Erreur imprimante: $e',

        );

        return PrintResult.failure('$stationName : $e');

      }

    }



    if (awaitCompletion) {

      return job();

    }

    unawaited(job());

    return PrintResult.queued(stationName);

  }



  Future<void> _logSimulated(

    String stationName,

    List<String> lines, {

    String? host,

    String? reason,

  }) async {

    final header = StringBuffer()

      ..writeln('')

      ..writeln('════════ IMPRESSION SIMULÉE ════════')

      ..writeln('Station: $stationName');

    if (host != null) {

      header.writeln('Cible: $host:${PrintConfig.networkPort}');

    }

    if (reason != null) {

      header.writeln('Info: $reason');

    }

    header.writeln('────────────────────────────────────');



    final body = lines.join('\n');

    final output = '$header$body\n════════════════════════════════════\n';



    // ignore: avoid_print
    print(output);



    if (!kIsWeb) {

      try {

        final dir = await getApplicationDocumentsDirectory();

        final folder = Directory(p.join(dir.path, 'ritagestion_print_logs'));

        if (!await folder.exists()) {

          await folder.create(recursive: true);

        }

        final file = File(

          p.join(

            folder.path,

            'ticket_${DateTime.now().millisecondsSinceEpoch}.txt',

          ),

        );

        await file.writeAsString(output);

      } catch (_) {}

    }

  }



  void dispose() {

    _printerManager.dispose();

  }

}



/// Résultat d'une impression.

class PrintResult {

  const PrintResult._({

    required this.ok,

    required this.stationName,

    required this.simulated,

    this.error,

  });



  const PrintResult.success(String stationName)

      : this._(ok: true, stationName: stationName, simulated: false);



  const PrintResult.simulated(String stationName)

      : this._(ok: true, stationName: stationName, simulated: true);



  const PrintResult.queued(String stationName)

      : this._(ok: true, stationName: stationName, simulated: false);



  const PrintResult.failure(String message)

      : this._(ok: false, stationName: '', simulated: false, error: message);



  final bool ok;

  final String stationName;

  final bool simulated;

  final String? error;

}


