import 'dart:async';

import 'package:flutter/widgets.dart';

/// Service de verrouillage automatique de session après inactivité
/// (security fix [HAUTE-F02]).
///
/// Écoute les interactions (souris, clavier, tactile) via [Listener] / raw
/// keyboard hooks et déclenche un callback après [timeout] sans activité.
///
/// Contraintes :
/// * Le timeout est configurable (défaut 5 minutes).
/// * Le timeout est suspendu en mode "train de payer" (payment en cours).
/// * Le timeout redémarre après chaque interaction détectée.
class SessionTimeoutService {
  SessionTimeoutService({
    this.timeout = const Duration(minutes: 5),
  });

  /// Durée d'inactivité avant verrouillage.
  Duration timeout;

  /// Callback appelé au déclenchement du timeout.
  VoidCallback? onTimeout;

  Timer? _timer;
  bool _isPaymentInProgress = false;
  bool _isPaused = false;

  /// Démarrer la surveillance. [onTimeout] sera appelé après inactivité.
  void start({required VoidCallback onTimeout}) {
    this.onTimeout = onTimeout;
    _isPaused = false;
    _resetTimer();
  }

  /// Suspend le timeout (payment en cours, dialogue sensible, etc.).
  void suspendForPayment() {
    _isPaymentInProgress = true;
    _timer?.cancel();
  }

  /// Reprend le timeout après un payment.
  void resumeAfterPayment() {
    _isPaymentInProgress = false;
    _resetTimer();
  }

  /// Met en pause manuellement (ex: dialogue PIN ouvert).
  void pause() {
    _isPaused = true;
    _timer?.cancel();
  }

  /// Reprend après pause manuelle.
  void resume() {
    _isPaused = false;
    _resetTimer();
  }

  /// À appeler sur chaque interaction utilisateur (PointerDownEvent, etc.).
  void registerActivity() {
    if (_isPaymentInProgress || _isPaused) return;
    _resetTimer();
  }

  /// Arrête complètement la surveillance.
  void stop() {
    _timer?.cancel();
    _timer = null;
    onTimeout = null;
  }

  void _resetTimer() {
    if (onTimeout == null) return;
    _timer?.cancel();
    _timer = Timer(timeout, () {
      onTimeout?.call();
    });
  }
}

/// Mixin / helper pour connecter [Listener] et [SessionTimeoutService].
///
/// Usage : dans un widget racine, utiliser un [Listener] qui appelle
/// `sessionTimeoutService.registerActivity()` sur `onPointerDown`.
class SessionActivityListener extends StatelessWidget {
  const SessionActivityListener({
    super.key,
    required this.service,
    required this.child,
  });

  final SessionTimeoutService service;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => service.registerActivity(),
      onPointerMove: (_) => service.registerActivity(),
      child: KeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKeyEvent: (_) => service.registerActivity(),
        child: child,
      ),
    );
  }
}