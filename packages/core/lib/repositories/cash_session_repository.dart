import '../database/app_database.dart';
import '../entities/cash_session_report.dart';

/// Opérations de trésorerie liées à [CashSessions] et [CashMovements].
abstract class CashSessionRepository {
  Future<CashSession?> getOpenSessionForCashier(String cashierId);

  /// Première session ouverte (caisse active), indépendamment du caissier.
  Future<CashSession?> getAnyOpenSession();

  Future<CashSessionReport> buildSessionReport(String sessionId);

  Future<List<CashMovement>> getMovementsForSession(String sessionId);

  Future<CashSession> openSession({
    required String userId,
    required double openingBalance,
  });

  /// Entrée de caisse — audit `PAY_IN` **avant** insertion.
  Future<CashMovement> payIn({
    required String userId,
    required String sessionId,
    required double amount,
    required String reason,
  });

  /// Sortie de caisse — audit `PAY_OUT` **avant** insertion.
  Future<CashMovement> payOut({
    required String userId,
    required String sessionId,
    required double amount,
    required String reason,
  });

  /// Clôture Z — audit `CLOSE_SESSION` **avant** mise à jour session.
  Future<CashSession> closeSession({
    required String userId,
    required String sessionId,
    required double closingBalance,
    required double expectedBalance,
    String? closingNote,
  });
}
