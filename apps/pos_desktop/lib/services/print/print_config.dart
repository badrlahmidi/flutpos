/// Configuration imprimantes caisse (réseau ESC/POS port 9100).
abstract final class PrintConfig {
  PrintConfig._();

  /// `true` = journal console/fichier sans matériel (défaut dev).
  static const bool simulate = bool.fromEnvironment(
    'PRINT_SIMULATE',
    defaultValue: true,
  );

  static const int networkPort = 9100;

  /// Imprimante ticket client (USB/Ethernet exposée en TCP).
  static const String customerPrinterHost = String.fromEnvironment(
    'RECEIPT_PRINTER_HOST',
    defaultValue: '192.168.1.200',
  );

  static const String customerPrinterName = 'Caisse — Ticket client';
}
