import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Saisie d'un chiffre (0–9).
final class AuthPinDigitPressed extends AuthEvent {
  const AuthPinDigitPressed(this.digit);

  final String digit;

  @override
  List<Object?> get props => [digit];
}

final class AuthPinBackspacePressed extends AuthEvent {
  const AuthPinBackspacePressed();
}

final class AuthPinClearPressed extends AuthEvent {
  const AuthPinClearPressed();
}

/// Validation du PIN saisi (bouton OK ou longueur minimale atteinte).
final class AuthPinSubmitPressed extends AuthEvent {
  const AuthPinSubmitPressed();
}
