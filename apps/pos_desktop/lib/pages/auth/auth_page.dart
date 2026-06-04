import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../di/service_locator.dart';
import '../../theme/app_spacing.dart';
import '../../services/pos_service_mode.dart';
import '../../widgets/atoms/pos_button.dart';
import '../floor_plan/floor_plan_page.dart';
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
      create: (_) => AuthBloc(
        authRepository: sl<AuthRepository>(),
        timeAttendanceRepository: sl<TimeAttendanceRepository>(),
      ),
      child: const _AuthView(),
    );
  }
}

class _AuthView extends StatelessWidget {
  const _AuthView();

  static final DateFormat _timeFormat = DateFormat('HH:mm', 'fr_FR');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listenWhen: (prev, curr) =>
              curr is AuthSuccess || curr is AuthAttendanceRecorded,
          listener: (context, state) {
            if (state is AuthSuccess) {
              final home = PosServiceMode.instance.isQuickService
                  ? PosPage(user: state.user)
                  : FloorPlanPage(user: state.user);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(builder: (_) => home),
              );
              return;
            }

            if (state is AuthAttendanceRecorded) {
              final time = _timeFormat.format(state.result.recordedAt.toLocal());
              final label = state.result.isClockIn ? 'Entrée' : 'Sortie';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${state.result.userName} — $label pointée à $time',
                  ),
                  duration: const Duration(seconds: 3),
                ),
              );
              context.read<AuthBloc>().add(const AuthPinClearPressed());
            }
          },
          builder: (context, state) {
            final bloc = context.read<AuthBloc>();
            final mode = _modeFor(state, bloc.mode);
            final pinLength = _pinLengthFor(state);
            final maxLength = bloc.maxPinLength;
            final isLoading = state is AuthLoading;
            final isLocked = state is AuthLocked;
            final enabled = !isLoading && !isLocked;
            final canClock = pinLength >= bloc.minPinLength && enabled;

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
                      const SizedBox(height: AppSpacing.l),
                      SizedBox(
                        height: AppSpacing.minTouchTarget,
                        child: SegmentedButton<AuthScreenMode>(
                          segments: const [
                            ButtonSegment(
                              value: AuthScreenMode.login,
                              label: Text('Connexion'),
                              icon: Icon(Icons.login),
                            ),
                            ButtonSegment(
                              value: AuthScreenMode.attendance,
                              label: Text('Pointage'),
                              icon: Icon(Icons.schedule),
                            ),
                          ],
                          selected: {mode},
                          onSelectionChanged: enabled
                              ? (selection) {
                                  if (selection.isNotEmpty) {
                                    context.read<AuthBloc>().add(
                                          AuthModeChanged(selection.first),
                                        );
                                  }
                                }
                              : null,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.m),
                      Text(
                        mode == AuthScreenMode.login
                            ? 'Entrez votre code PIN'
                            : 'PIN puis pointez entrée ou sortie',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
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
                        canSubmit: mode == AuthScreenMode.login &&
                            pinLength >= bloc.minPinLength,
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
                      if (mode == AuthScreenMode.attendance) ...[
                        const SizedBox(height: AppSpacing.l),
                        PosButton(
                          label: 'POINTER L\'ENTRÉE',
                          icon: Icons.login,
                          expand: true,
                          onPressed: canClock
                              ? () => context
                                  .read<AuthBloc>()
                                  .add(const AuthClockInRequested())
                              : null,
                        ),
                        const SizedBox(height: AppSpacing.s),
                        PosButton(
                          label: 'POINTER LA SORTIE',
                          icon: Icons.logout,
                          variant: PosButtonVariant.outlined,
                          expand: true,
                          onPressed: canClock
                              ? () => context
                                  .read<AuthBloc>()
                                  .add(const AuthClockOutRequested())
                              : null,
                        ),
                      ],
                      const SizedBox(height: AppSpacing.l),
                      Text(
                        'Démo : PIN serveur 9012 · admin 1234',
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

  AuthScreenMode _modeFor(AuthState state, AuthScreenMode blocMode) {
    return switch (state) {
      AuthInitial(:final mode) => mode,
      AuthEnteringPin(:final mode) => mode,
      AuthLoading(:final mode) => mode,
      AuthFailure(:final mode) => mode,
      AuthAttendanceRecorded(:final mode) => mode,
      _ => blocMode,
    };
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
