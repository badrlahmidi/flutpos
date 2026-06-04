import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di/service_locator.dart';
import '../../theme/app_spacing.dart';
import '../pos/pos_page.dart';
import 'auth_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'widgets/pin_dots_indicator.dart';
import 'widgets/pin_numpad.dart';

/// Écran d'authentification par PIN (caisse Windows).
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(authRepository: sl<AuthRepository>()),
      child: const _AuthView(),
    );
  }
}

class _AuthView extends StatelessWidget {
  const _AuthView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listenWhen: (prev, curr) => curr is AuthSuccess,
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (_) => PosPage(user: state.user),
                ),
              );
            }
          },
          builder: (context, state) {
            final pinLength = _pinLengthFor(state);
            final maxLength = context.read<AuthBloc>().maxPinLength;
            final isLoading = state is AuthLoading;
            final isLocked = state is AuthLocked;
            final enabled = !isLoading && !isLocked;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.l),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.point_of_sale,
                        size: AppSpacing.minTouchTarget,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: AppSpacing.m),
                      Text(
                        'Ritagestion',
                        style: theme.textTheme.headlineLarge,
                      ),
                      const SizedBox(height: AppSpacing.s),
                      Text(
                        'Entrez votre code PIN',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.l),
                      PinDotsIndicator(
                        filledCount: pinLength,
                        maxLength: maxLength,
                        isLoading: isLoading,
                      ),
                      if (isLoading) ...[
                        const SizedBox(height: AppSpacing.m),
                        const SizedBox(
                          width: AppSpacing.minTouchTarget,
                          height: AppSpacing.minTouchTarget,
                          child: CircularProgressIndicator(),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.m),
                      _AuthMessage(state: state),
                      const SizedBox(height: AppSpacing.l),
                      PinNumpad(
                        enabled: enabled,
                        canSubmit: pinLength >= context.read<AuthBloc>().minPinLength,
                        onDigit: (d) => context
                            .read<AuthBloc>()
                            .add(AuthPinDigitPressed(d)),
                        onBackspace: () => context
                            .read<AuthBloc>()
                            .add(const AuthPinBackspacePressed()),
                        onClear: () => context
                            .read<AuthBloc>()
                            .add(const AuthPinClearPressed()),
                        onSubmit: () => context
                            .read<AuthBloc>()
                            .add(const AuthPinSubmitPressed()),
                      ),
                      const SizedBox(height: AppSpacing.l),
                      Text(
                        'Démo : PIN admin 1234',
                        style: theme.textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  int _pinLengthFor(AuthState state) {
    return switch (state) {
      AuthEnteringPin(:final pinLength) => pinLength,
      AuthLoading(:final pinLength) => pinLength,
      AuthFailure(:final pinLength) => pinLength,
      _ => 0,
    };
  }
}

class _AuthMessage extends StatelessWidget {
  const _AuthMessage({required this.state});

  final AuthState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final String text;
    final bool isError;

    switch (state) {
      case AuthFailure(:final message):
        text = message;
        isError = true;
      case AuthLocked(:final message):
        text = message;
        isError = true;
      default:
        return const SizedBox(height: AppSpacing.m);
    }

    return SizedBox(
      height: AppSpacing.minTouchTarget,
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isError ? scheme.error : scheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
