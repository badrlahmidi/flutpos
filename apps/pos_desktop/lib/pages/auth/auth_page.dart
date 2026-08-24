import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../di/service_locator.dart';
import '../../navigation/app_session.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/atoms/glass_card.dart';
import '../../widgets/atoms/loading_skeleton.dart';
import '../../widgets/atoms/pos_button.dart';
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

class _AuthView extends StatefulWidget {
  const _AuthView();

  @override
  State<_AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<_AuthView> {
  static final _timeFormat = DateFormat('HH:mm', 'fr_FR');
  late Timer _clockTimer;
  String _currentTime = _timeFormat.format(DateTime.now());
  int _shakeTick = 0;
  
  final _focusNode = FocusNode();
  String _barcodeBuffer = '';
  Timer? _barcodeDebounce;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _clockTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) {
        setState(() {
          _currentTime = _timeFormat.format(DateTime.now());
        });
      }
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    _focusNode.dispose();
    _barcodeDebounce?.cancel();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    final char = event.character;
    if (char != null && char.isNotEmpty) {
      _barcodeBuffer += char;
      _barcodeDebounce?.cancel();
      _barcodeDebounce = Timer(const Duration(milliseconds: 50), () {
        if (_barcodeBuffer.isNotEmpty) {
          _processBarcode(_barcodeBuffer.trim());
          _barcodeBuffer = '';
        }
      });
    } else if (event.logicalKey == LogicalKeyboardKey.enter) {
      _barcodeDebounce?.cancel();
      if (_barcodeBuffer.isNotEmpty) {
        _processBarcode(_barcodeBuffer.trim());
        _barcodeBuffer = '';
      }
    }
  }

  /// Security fix [BAS-F04] — Validation format code-barres PIN.
  /// N'accepte que les formats `^[0-9]{4,8}$` (chiffres uniquement, longueur
  /// entre 4 et 8). Rejette silencieusement les formats invalides.
  static final _pinBarcodeRegex = RegExp(r'^[0-9]{4,8}$');

  void _processBarcode(String barcode) {
    // Si le code commence par user:, on extrait le PIN.
    // Sinon, on suppose que c'est le PIN directement.
    final pin = barcode.startsWith('user:') ? barcode.substring(5) : barcode;

    // Valider le format — rejeter silencieusement les formats invalides.
    if (!_pinBarcodeRegex.hasMatch(pin)) {
      return;
    }

    // Nettoyer l'état précédent et soumettre le PIN complet.
    final bloc = context.read<AuthBloc>();
    bloc.add(const AuthPinClearPressed());

    // Simuler la frappe des chiffres pour déclencher le login automatique.
    for (var i = 0; i < pin.length; i++) {
      bloc.add(AuthPinDigitPressed(pin[i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.3),
            radius: 1.2,
            colors: isDark
                ? const [
                    AppColors.scaffoldDark,
                    Color(0xFF0A0C12),
                  ]
                : [
                    scheme.surfaceContainerLow,
                    scheme.surface,
                  ],
          ),
        ),
        child: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
            listenWhen: (prev, curr) =>
                curr is AuthSuccess ||
                curr is AuthAttendanceRecorded ||
                curr is AuthFailure ||
                curr is AuthLocked,
            listener: (context, state) {
              if (state is AuthSuccess) {
                AppSession.instance.setUser(state.user);
                context.go('/menu');
                return;
              }

              if (state is AuthAttendanceRecorded) {
                final time =
                    _timeFormat.format(state.result.recordedAt.toLocal());
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

              if (state is AuthFailure || state is AuthLocked) {
                setState(() => _shakeTick++);
              }
            },
            builder: (context, state) {
              final theme = Theme.of(context);
              final scheme = theme.colorScheme;
              final bloc = context.read<AuthBloc>();
              final mode = _modeFor(state, bloc.mode);
              final pinLength = _pinLengthFor(state);
              final maxLength = bloc.maxPinLength;
              final isLoading = state is AuthLoading;
              final isLocked = state is AuthLocked;
              final enabled = !isLoading && !isLocked;
              final canClock = pinLength >= bloc.minPinLength && enabled;

              Widget pinCard = GlassCard(
                        maxWidth: 420,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _BrandLogo(scheme: scheme),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'RESTO CLOUD & OFFLINE',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: scheme.primary.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.s),
                            Text(
                              'Bienvenue · مرحبا',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.l),
                            
                            // Live Status Indicators
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.m,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: scheme.surfaceContainerHighest.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: scheme.outlineVariant.withValues(alpha: 0.1),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.storage_rounded,
                                    size: 13,
                                    color: scheme.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'SQLite',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: scheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 4,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: scheme.onSurfaceVariant.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green,
                                    ),
                                  )
                                      .animate(onPlay: (controller) => controller.repeat(reverse: true))
                                      .scale(begin: const Offset(1, 1), end: const Offset(1.5, 1.5), duration: 1000.ms),
                                  const SizedBox(width: 6),
                                  Text(
                                    'mDNS & Cloud OK',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: scheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.l),
                            
                            SizedBox(
                              height: AppSpacing.minTouchTarget,
                              child: SegmentedButton<AuthScreenMode>(
                                segments: const [
                                  ButtonSegment(
                                    value: AuthScreenMode.login,
                                    label: Text('Connexion'),
                                    icon: Icon(Icons.login_rounded),
                                  ),
                                  ButtonSegment(
                                    value: AuthScreenMode.attendance,
                                    label: Text('Pointage'),
                                    icon: Icon(Icons.schedule_rounded),
                                  ),
                                ],
                                selected: {mode},
                                onSelectionChanged: enabled
                                    ? (selection) {
                                        if (selection.isNotEmpty) {
                                          context.read<AuthBloc>().add(
                                                AuthModeChanged(
                                                  selection.first,
                                                ),
                                              );
                                        }
                                      }
                                    : null,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.m),
                            Text(
                              mode == AuthScreenMode.login
                                  ? 'Saisissez votre code PIN d\'accès'
                                  : 'PIN puis validez votre entrée / sortie',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: scheme.onSurfaceVariant,
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
                              const LoadingSkeletonBox(height: 48, width: 48),
                            ],
                            const SizedBox(height: AppSpacing.m),
                            _AuthMessage(state: state),
                            const SizedBox(height: AppSpacing.m),
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
                                icon: Icons.login_rounded,
                                expand: true,
                                onPressed: canClock
                                    ? () => context.read<AuthBloc>().add(
                                          const AuthClockInRequested(),
                                        )
                                    : null,
                              ),
                              const SizedBox(height: AppSpacing.s),
                              PosButton(
                                label: 'POINTER LA SORTIE',
                                icon: Icons.logout_rounded,
                                variant: PosButtonVariant.outlined,
                                expand: true,
                                onPressed: canClock
                                    ? () => context.read<AuthBloc>().add(
                                          const AuthClockOutRequested(),
                                        )
                                    : null,
                              ),
                            ],
                            const SizedBox(height: AppSpacing.l),
                            if (kDebugMode) Text(
                              'Démo : PIN serveur 9012 · admin 1234',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: scheme.onSurfaceVariant.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      );

              pinCard = pinCard
                  .animate()
                  .fadeIn(duration: 450.ms)
                  .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic);

              if (_shakeTick > 0) {
                pinCard = pinCard
                    .animate(key: ValueKey('shake-$_shakeTick'))
                    .shake(hz: 4, duration: 350.ms);
              }

              return Stack(
                children: [
                  // Glowing decorative shapes in background
                  Positioned(
                    top: -120,
                    left: -120,
                    child: Container(
                      width: 320,
                      height: 320,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: scheme.primary.withValues(alpha: 0.15),
                      ),
                    ),
                  ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOut),
                  Positioned(
                    bottom: -150,
                    right: -100,
                    child: Container(
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: scheme.tertiary.withValues(alpha: 0.12),
                      ),
                    ),
                  ).animate().fadeIn(duration: 1000.ms).scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOut),

                  Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.l),
                      child: pinCard,
                    ),
                  ),
                  Positioned(
                    left: AppSpacing.l,
                    right: AppSpacing.l,
                    bottom: AppSpacing.m,
                    child: Row(
                      children: [
                        Text(
                          'Caisse Principale · Windows POS',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Heure locale: $_currentTime',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: scheme.onSurfaceVariant.withValues(alpha: 0.8),
                            fontFeatures: const [FontFeature.tabularFigures()],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    ));
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

class _BrandLogo extends StatelessWidget {
  const _BrandLogo({required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [scheme.primary, scheme.tertiary],
      ).createShader(bounds),
      child: Text(
        'RITAGESTION',
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              letterSpacing: 2,
              fontWeight: FontWeight.w800,
            ),
      ),
    );
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
