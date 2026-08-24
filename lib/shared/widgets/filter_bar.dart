import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  final List<Widget> filters;
  final VoidCallback? onClear;

  const FilterBar({
    super.key,
    required this.filters,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...filters,
        if (onClear != null)
          OutlinedButton.icon(
            onPressed: onClear,
            icon: const Icon(Icons.clear),
            label: const Text('Clear Filters'),
          ),
      ],
    );
  }
}


