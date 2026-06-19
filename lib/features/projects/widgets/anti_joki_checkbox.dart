import 'package:flutter/material.dart';

class AntiJokiCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AntiJokiCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      contentPadding: EdgeInsets.zero,
      title: const Text(
        'Saya menyatakan project ini bukan joki tugas, ujian, kuis, skripsi penuh, atau pekerjaan akademik yang melanggar etika.',
      ),
      onChanged: (newValue) {
        onChanged(newValue ?? false);
      },
    );
  }
}
