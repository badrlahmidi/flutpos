import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthRepository authRepository,
    this.minPinLength = 4,
    this.maxPinLength = 6,
  })  : _authRepository = authRepository,
        super(const AuthInitial()) {
    on<AuthPinDigitPressed>(_onDigitPressed);
    on<AuthPinBackspacePressed>(_onBackspacePressed);
    on<AuthPinClearPressed>(_onClearPressed);
    on<AuthPinSubmitPressed>(_onSubmitPressed);
  }

  final AuthRepository _authRepository;
  final int minPinLength;
  final int maxPinLength;

  static const int maxFailedAttempts = 3;

  String _pinBuffer = '';
  int _failedAttempts = 0;

  bool get _isLocked => _failedAttempts >= maxFailedAttempts;

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
      ),
    );

    if (_pinBuffer.length >= minPinLength) {
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
      emit(const AuthInitial());
    } else {
      emit(
        AuthEnteringPin(
          pinLength: _pinBuffer.length,
          maxLength: maxPinLength,
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
    emit(AuthLoading(pinLength: pinLength));

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
      ),
    );
  }

  void _resetPinBuffer(Emitter<AuthState> emit) {
    _pinBuffer = '';
    emit(const AuthInitial());
  }
}
