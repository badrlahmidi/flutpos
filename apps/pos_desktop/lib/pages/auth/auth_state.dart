import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

/// Mode écran auth : connexion caisse ou pointage RH.
enum AuthScreenMode {
  login,
  attendance,
}

sealed class AuthState extends Equatable {
  const AuthState();

  AuthScreenMode get mode => AuthScreenMode.login;

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial({this.mode = AuthScreenMode.login});

  @override
  final AuthScreenMode mode;

  @override
  List<Object?> get props => [mode];
}

/// Affichage des points masqués pendant la saisie.
final class AuthEnteringPin extends AuthState {
  const AuthEnteringPin({
    required this.pinLength,
    required this.maxLength,
    required this.mode,
  });

  final int pinLength;
  final int maxLength;
  @override
  final AuthScreenMode mode;

  @override
  List<Object?> get props => [pinLength, maxLength, mode];
}

final class AuthLoading extends AuthState {
  const AuthLoading({
    required this.pinLength,
    required this.mode,
  });

  final int pinLength;
  @override
  final AuthScreenMode mode;

  @override
  List<Object?> get props => [pinLength, mode];
}

final class AuthSuccess extends AuthState {
  const AuthSuccess(this.user);

  final User user;

  @override
  List<Object?> get props => [user.id];
}

final class AuthFailure extends AuthState {
  const AuthFailure({
    required this.message,
    required this.remainingAttempts,
    required this.pinLength,
    required this.mode,
  });

  final String message;
  final int remainingAttempts;
  final int pinLength;
  @override
  final AuthScreenMode mode;

  @override
  List<Object?> get props => [message, remainingAttempts, pinLength, mode];
}

/// Pointage enregistré — reste sur l'écran auth.
final class AuthAttendanceRecorded extends AuthState {
  const AuthAttendanceRecorded({
    required this.result,
    required this.mode,
  });

  final ClockOperationResult result;
  @override
  final AuthScreenMode mode;

  @override
  List<Object?> get props => [result, mode];
}

/// Verrouillage après 3 tentatives échouées (cf. `07_security_and_auth.md`).
final class AuthLocked extends AuthState {
  const AuthLocked({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Verrouillage automatique après inactivité (security fix [HAUTE-F02]).
final class AuthAutoLockedState extends AuthState {
  const AuthAutoLockedState();
}
