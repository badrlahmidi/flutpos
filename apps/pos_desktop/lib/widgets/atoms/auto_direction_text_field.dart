import 'package:flutter/material.dart';

/// Détecte la direction du texte selon la présence de caractères arabes.
TextDirection textDirectionFor(String text) {
  if (RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]').hasMatch(text)) {
    return TextDirection.rtl;
  }
  return TextDirection.ltr;
}

/// Champ multilingue FR/AR — direction automatique pendant la saisie.
class AutoDirectionTextField extends StatefulWidget {
  const AutoDirectionTextField({
    super.key,
    required this.controller,
    this.decoration,
    this.maxLines = 1,
    this.onChanged,
    this.readOnly = false,
  });

  final TextEditingController controller;
  final InputDecoration? decoration;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final bool readOnly;

  @override
  State<AutoDirectionTextField> createState() => _AutoDirectionTextFieldState();
}

class _AutoDirectionTextFieldState extends State<AutoDirectionTextField> {
  TextDirection _direction = TextDirection.ltr;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_syncDirection);
    _direction = textDirectionFor(widget.controller.text);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_syncDirection);
    super.dispose();
  }

  void _syncDirection() {
    final next = textDirectionFor(widget.controller.text);
    if (next != _direction && mounted) {
      setState(() => _direction = next);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      textDirection: _direction,
      decoration: widget.decoration,
      maxLines: widget.maxLines,
      onChanged: widget.onChanged,
      readOnly: widget.readOnly,
    );
  }
}
