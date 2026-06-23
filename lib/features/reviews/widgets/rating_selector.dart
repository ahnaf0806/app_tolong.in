import 'package:flutter/material.dart';

class RatingSelector extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onChanged;

  const RatingSelector({
    super.key,
    required this.rating,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        final value = index + 1;
        final isSelected = value <= rating;

        return IconButton(
          onPressed: () => onChanged(value),
          icon: Icon(
            isSelected ? Icons.star_rounded : Icons.star_border_rounded,
            color: Colors.amber,
            size: 34,
          ),
        );
      }),
    );
  }
}
