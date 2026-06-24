import 'package:flutter/material.dart';

class DifficultySelector extends StatelessWidget {
  final String selectedDifficulty;
  final ValueChanged<String> onChanged;

  const DifficultySelector({
    super.key,
    required this.selectedDifficulty,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: selectedDifficulty,
      decoration: const InputDecoration(
        labelText: 'Tingkat Kesulitan',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: 'easy', child: Text('Mudah')),
        DropdownMenuItem(value: 'medium', child: Text('Sedang')),
        DropdownMenuItem(value: 'hard', child: Text('Sulit')),
      ],
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }
}
