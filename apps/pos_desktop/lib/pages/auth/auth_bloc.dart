import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthRepository authRepository,
    required TimeAttendanceRepository timeAttendanceRepository,
    this.minPinLength = 6,
    this.maxPinLength = 8,
  })  : _authRepository = authRepository,
        _timeAttendance = timeAttendanceRepository,
        super(const AuthInitial()) {
    on<AuthModeChanged>(_onModeChanged);
    on<AuthPinDigitPressed>(_onDigitPressed);
    on<AuthPinBackspacePressed>(_onBackspacePressed);
    on<AuthPinClearPressed>(_onClearPressed);
    on<AuthPinSubmitPressed>(_onSubmitPressed);
    on<AuthClockInRequested>(_onClockIn);
    on<AuthClockOutRequested>(_onClockOut);
    on<AuthAutoLocked>(_onAutoLocked);

    // Vérifier le verrouillage persistant au démarrage du BLoC.
    _checkPersistentLock();
  }

  final AuthRepository _authRepository;
  final TimeAttendanceRepository _timeAttendance;

  /// Security fix [BAS-A06] — PIN minimum 6 chiffres (anciennement 4).
  final int minPinLength;
  final int maxPinLength;

  AuthScreenMode _mode = AuthScreenMode.login;

  /// Security fix [MOY-A05] — PIN buffer sécurisé en [Uint8List] au lieu de
  /// String pour éviter qu'il reste dans le heap GC. Effacé (zero-out) après
  /// chaque usage (succès, échec, ou annulation).
  final Uint8List _pinBuffer = Uint8List(8);
  int _pinLength = 0;

  /// Cache local pour empêcher les interactions pendant le verrouillage.
  bool _isLocked = false;

  AuthScreenMode get mode => _mode;

  /// Retourne la représentation String du PIN actuel (effacer après usage).
  String _readPin() {
    return String.fromCharCodes(_pinBuffer.sublist(0, _pinLength));
  }

  /// Security fix [MOY-A05] — Zero-out le buffer PIN.
  void _zeroOutPin() {
    for (int i = 0; i < _pinBuffer.length; i++) {
      _pinBuffer[i] = 0;
    }
    _pinLength = 0;
  }

  /// Vérifie le verrouillage persistant au démarrage (anti-contournement A02).
  Future<void> _checkPersistentLock() async {
    final remaining = await _authRepository.checkLockStatus();
    if (remaining != null) {
      _isLocked = true;
      // ignore: invalid_use_of_visible_for_testing_member
      emit(
        AuthLocked(
          message:
              'Caisse verrouillée. Réessayez dans ${_formatDuration(remaining)}.',
        ),
      );
    }
  }

  void _onModeChanged(AuthModeChanged event, Emitter<AuthState> emit) {
    if (_isLocked || state is AuthLoading) {
      return;
    }
    _mode = event.mode;
    _resetPinBuffer(emit);
  }

  void _onDigitPressed(AuthPinDigitPressed event, Emitter<AuthState> emit) {
    if (_isLocked || state is AuthLoading) {
      return;
    }

    if (!RegExp(r'^\d$').hasMatch(event.digit)) {
      return;
    }

    if (_pinLength >= maxPinLength) {
      return;
    }

    _pinBuffer[_pinLength] = event.digit.codeUnitAt(0);
    _pinLength++;
    emit(
      AuthEnteringPin(
        pinLength: _pinLength,
        maxLength: maxPinLength,
        mode: _mode,
      ),
    );

    if (_mode == AuthScreenMode.login &&
        _pinLength >= minPinLength) {
      add(const AuthPinSubmitPressed());
    }
  }

  void _onBackspacePressed(
    AuthPinBackspacePressed event,
    Emitter<AuthState> emit,
  ) {
    if (_isLocked || state is AuthLoading || _pinLength == 0) {
      return;
    }

    _pinLength--;
    _pinBuffer[_pinLength] = 0;
    if (_pinLength == 0) {
      emit(AuthInitial(mode: _mode));
    } else {
      emit(
        AuthEnteringPin(
          pinLength: _pinLength,
          maxLength: maxPinLength,
          mode: _mode,
        ),
      );
    }
  }

  void _onClearPressed(AuthPinClearPressed event, Emitter<AuthState> emit) {
    if (_isLocked || state is AuthLoading) {
      return;
    }
    _resetPinBuffer(emit);
  }

  Future<void> _onSubmitPressed(
    AuthPinSubmitPressed event,
    Emitter<AuthState> emit,
  ) async {
    // Vérifier le verrouillage persistant avant chaque tentative.
    final lockRemaining = await _authRepository.checkLockStatus();
    if (lockRemaining != null) {
      _isLocked = true;
      _zeroOutPin();
      emit(
        AuthLocked(
          message:
              'Caisse verrouillée. Réessayez dans ${_formatDuration(lockRemaining)}.',
        ),
      );
      return;
    }
    _isLocked = false;

    if (state is AuthLoading || _pinLength < minPinLength) {
      return;
    }

    final pinLength = _pinLength;
    emit(AuthLoading(pinLength: pinLength, mode: _mode));

    final pin = _readPin();
    final user = await _authRepository.verifyPin(pin);
    _zeroOutPin();

    if (user != null) {
      await _authRepository.resetFailedAttempts();
      _isLocked = false;
      emit(AuthSuccess(user));
      return;
    }

    // Échec → enregistrer en BDD (persistant + délai exponentiel).
    final failedCount = await _authRepository.recordFailedAttempt();

    // Re-vérifier si le nouveau compteur déclenche un verrouillage.
    final newLock = await _authRepository.checkLockStatus();
    if (newLock != null) {
      _isLocked = true;
      emit(
        AuthLocked(
          message:
              'PIN incorrect — caisse verrouillée pour ${_formatDuration(newLock)}.',
        ),
      );
      return;
    }

    final remaining = 3 - (failedCount % 3);
    emit(
      AuthFailure(
        message: 'PIN incorrect. $remaining tentative(s) restante(s).',
        remainingAttempts: remaining,
        pinLength: 0,
        mode: _mode,
      ),
    );
  }

  Future<void> _onClockIn(
    AuthClockInRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _performClock(emit, clockIn: true);
  }

  Future<void> _onClockOut(
    AuthClockOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _performClock(emit, clockIn: false);
  }

  Future<void> _performClock(
    Emitter<AuthState> emit, {
    required bool clockIn,
  }) async {
    // Vérifier le verrouillage persistant.
    final lockRemaining = await _authRepository.checkLockStatus();
    if (lockRemaining != null) {
      _isLocked = true;
      _zeroOutPin();
      emit(
        AuthLocked(
          message:
              'Caisse verrouillée. Réessayez dans ${_formatDuration(lockRemaining)}.',
        ),
      );
      return;
    }
    _isLocked = false;

    if (_pinLength < minPinLength) {
      _zeroOutPin();
      emit(
        AuthFailure(
          message: 'Entrez votre PIN ($minPinLength chiffres minimum).',
          remainingAttempts: 3,
          pinLength: 0,
          mode: AuthScreenMode.attendance,
        ),
      );
      return;
    }

    final pinLength = _pinLength;
    emit(AuthLoading(pinLength: pinLength, mode: AuthScreenMode.attendance));

    try {
      final pin = _readPin();
      final result = await _timeAttendance.clockWithPin(
        pin: pin,
        clockIn: clockIn,
      );
      _zeroOutPin();
      await _authRepository.resetFailedAttempts();
      _isLocked = false;
      emit(
        AuthAttendanceRecorded(
          result: result,
          mode: AuthScreenMode.attendance,
        ),
      );
    } on StateError catch (e) {
      _zeroOutPin();
      final isPinError = e.message == 'PIN incorrect';
      if (isPinError) {
        final failedCount = await _authRepository.recordFailedAttempt();
        final newLock = await _authRepository.checkLockStatus();
        if (newLock != null) {
          _isLocked = true;
          emit(
            AuthLocked(
              message:
                  'PIN incorrect — caisse verrouillée pour ${_formatDuration(newLock)}.',
            ),
          );
          return;
        }
        final remaining = 3 - (failedCount % 3);
        emit(
          AuthFailure(
            message: 'PIN incorrect. $remaining tentative(s) restante(s).',
            remainingAttempts: remaining,
            pinLength: 0,
            mode: AuthScreenMode.attendance,
          ),
        );
        return;
      }

      emit(
        AuthFailure(
          message: e.message,
          remainingAttempts: 3,
          pinLength: 0,
          mode: AuthScreenMode.attendance,
        ),
      );
    }
  }

  void _onAutoLocked(AuthAutoLocked event, Emitter<AuthState> emit) {
    // Security fix [HAUTE-F02] — Verrouillage automatique après inactivité.
    _zeroOutPin();
    emit(const AuthAutoLockedState());
  }

  void _resetPinBuffer(Emitter<AuthState> emit) {
    _zeroOutPin();
    emit(AuthInitial(mode: _mode));
  }

  /// Formate une Duration pour affichage (ex: "2 min 30 s").
  static String _formatDuration(Duration d) {
    if (d.inMinutes >= 1) {
      final secs = d.inSeconds % 60;
      return secs > 0
          ? '${d.inMinutes} min $secs s'
          : '${d.inMinutes} min';
    }
    return '${d.inSeconds} s';
  }
}