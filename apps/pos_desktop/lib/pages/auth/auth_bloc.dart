import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthRepository authRepository,
    required TimeAttendanceRepository timeAttendanceRepository,
    this.minPinLength = 4,
    this.maxPinLength = 6,
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
  }

  final AuthRepository _authRepository;
  final TimeAttendanceRepository _timeAttendance;
  final int minPinLength;
  final int maxPinLength;

  AuthScreenMode _mode = AuthScreenMode.login;

  static const int maxFailedAttempts = 3;

  String _pinBuffer = '';
  int _failedAttempts = 0;

  bool get _isLocked => _failedAttempts >= maxFailedAttempts;

  AuthScreenMode get mode => _mode;

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

    if (_pinBuffer.length >= maxPinLength) {
      return;
    }

    _pinBuffer += event.digit;
    emit(
      AuthEnteringPin(
        pinLength: _pinBuffer.length,
        maxLength: maxPinLength,
        mode: _mode,
      ),
    );

    if (_mode == AuthScreenMode.login &&
        _pinBuffer.length >= minPinLength) {
      add(const AuthPinSubmitPressed());
    }
  }

  void _onBackspacePressed(
    AuthPinBackspacePressed event,
    Emitter<AuthState> emit,
  ) {
    if (_isLocked || state is AuthLoading || _pinBuffer.isEmpty) {
      return;
    }

    _pinBuffer = _pinBuffer.substring(0, _pinBuffer.length - 1);
    if (_pinBuffer.isEmpty) {
      emit(AuthInitial(mode: _mode));
    } else {
      emit(
        AuthEnteringPin(
          pinLength: _pinBuffer.length,
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
    if (_isLocked) {
      emit(
        const AuthLocked(
          message:
              'Trop de tentatives. Demandez à un manager de déverrouiller la caisse.',
        ),
      );
      return;
    }

    if (state is AuthLoading || _pinBuffer.length < minPinLength) {
      return;
    }

    final pinLength = _pinBuffer.length;
    emit(AuthLoading(pinLength: pinLength, mode: _mode));

    final user = await _authRepository.verifyPin(_pinBuffer);
    _pinBuffer = '';

    if (user != null) {
      _failedAttempts = 0;
      emit(AuthSuccess(user));
      return;
    }

    _failedAttempts++;
    final remaining = maxFailedAttempts - _failedAttempts;

    if (remaining <= 0) {
      emit(
        const AuthLocked(
          message:
              'PIN incorrect — caisse verrouillée. Contactez un administrateur.',
        ),
      );
      return;
    }

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
    if (_isLocked) {
      emit(
        const AuthLocked(
          message:
              'Trop de tentatives. Demandez à un manager de déverrouiller la caisse.',
        ),
      );
      return;
    }

    if (_pinBuffer.length < minPinLength) {
      emit(
        AuthFailure(
          message: 'Entrez votre PIN ($minPinLength chiffres minimum).',
          remainingAttempts: maxFailedAttempts - _failedAttempts,
          pinLength: _pinBuffer.length,
          mode: AuthScreenMode.attendance,
        ),
      );
      return;
    }

    final pinLength = _pinBuffer.length;
    emit(AuthLoading(pinLength: pinLength, mode: AuthScreenMode.attendance));

    try {
      final result = await _timeAttendance.clockWithPin(
        pin: _pinBuffer,
        clockIn: clockIn,
      );
      _pinBuffer = '';
      _failedAttempts = 0;
      emit(
        AuthAttendanceRecorded(
          result: result,
          mode: AuthScreenMode.attendance,
        ),
      );
    } on StateError catch (e) {
      _pinBuffer = '';
      final isPinError = e.message == 'PIN incorrect';
      if (isPinError) {
        _failedAttempts++;
        final remaining = maxFailedAttempts - _failedAttempts;
        if (remaining <= 0) {
          emit(
            const AuthLocked(
              message:
                  'PIN incorrect — caisse verrouillée. Contactez un administrateur.',
            ),
          );
          return;
        }
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
          remainingAttempts: maxFailedAttempts - _failedAttempts,
          pinLength: 0,
          mode: AuthScreenMode.attendance,
        ),
      );
    }
  }

  void _resetPinBuffer(Emitter<AuthState> emit) {
    _pinBuffer = '';
    emit(AuthInitial(mode: _mode));
  }
}
