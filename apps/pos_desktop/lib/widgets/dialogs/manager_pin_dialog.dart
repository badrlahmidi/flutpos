import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../di/service_locator.dart';
import '../../theme/app_spacing.dart';
import '../../pages/auth/widgets/pin_dots_indicator.dart';
import '../../pages/auth/widgets/pin_numpad.dart';

/// Modal PIN Manager pour actions sensibles (niveau d'accès requis).
Future<User?> showManagerPinDialog(
  BuildContext context, {
  int requiredLevel = 1,
  String? operationLabel,
}) {
  return showDialog<User>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _ManagerPinDialog(
      requiredLevel: requiredLevel,
      operationLabel: operationLabel,
    ),
  );
}

class _ManagerPinDialog extends StatefulWidget {
  const _ManagerPinDialog({
    required this.requiredLevel,
    this.operationLabel,
  });

  final int requiredLevel;
  final String? operationLabel;

  @override
  State<_ManagerPinDialog> createState() => _ManagerPinDialogState();
}

class _ManagerPinDialogState extends State<_ManagerPinDialog> {
  static const int _pinLength = 4;

  final StringBuffer _pin = StringBuffer();
  bool _loading = false;
  String? _errorMessage;

  Future<void> _submit() async {
    if (_pin.length != _pinLength) {
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    final manager = await sl<AuthRepository>().verifyManagerPin(
      _pin.toString(),
      minLevel: widget.requiredLevel,
    );

    if (!mounted) {
      return;
    }

    if (manager == null) {
      setState(() {
        _loading = false;
        _errorMessage = 'PIN Manager invalide';
        _pin.clear();
      });
      return;
    }

    Navigator.of(context).pop(manager);
  }

  void _onDigit(String digit) {
    if (_loading || _pin.length >= _pinLength) {
      return;
    }
    setState(() => _pin.write(digit));
    if (_pin.length == _pinLength) {
      _submit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Autorisation Manager'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.operationLabel != null
                  ? 'Autorisation requise : ${widget.operationLabel}'
                  : 'Entrez le PIN d\'un utilisateur niveau ≥ ${widget.requiredLevel}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.m),
            PinDotsIndicator(
              filledCount: _pin.length,
              maxLength: _pinLength,
              isLoading: _loading,
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: AppSpacing.s),
              Text(
                _errorMessage!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.m),
            PinNumpad(
              enabled: !_loading,
              canSubmit: _pin.length == _pinLength,
              onDigit: _onDigit,
              onBackspace: () {
                if (_pin.isEmpty || _loading) {
                  return;
                }
                setState(() {
                  final text = _pin.toString();
                  _pin.clear();
                  if (text.isNotEmpty) {
                    _pin.write(text.substring(0, text.length - 1));
                  }
                  _errorMessage = null;
                });
              },
              onClear: () {
                if (_loading) {
                  return;
                }
                setState(() {
                  _pin.clear();
                  _errorMessage = null;
                });
              },
              onSubmit: _submit,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
      ],
    );
  }
}
