import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Affichage des points masqués pendant la saisie.
final class AuthEnteringPin extends AuthState {
  const AuthEnteringPin({
    required this.pinLength,
    required this.maxLength,
  });

  final int pinLength;
  final int maxLength;

  @override
  List<Object?> get props => [pinLength, maxLength];
}

final class AuthLoading extends AuthState {
  const AuthLoading({required this.pinLength});

  final int pinLength;

  @override
  List<Object?> get props => [pinLength];
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
  });

  final String message;
  final int remainingAttempts;
  final int pinLength;

  @override
  List<Object?> get props => [message, remainingAttempts, pinLength];
}

/// Verrouillage après 3 tentatives échouées (cf. `07_security_and_auth.md`).
final class AuthLocked extends AuthState {
  const AuthLocked({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
