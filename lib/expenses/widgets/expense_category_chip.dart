import 'package:flutter/material.dart';
import '../models/expense_category.dart';

class ExpenseCategoryChip extends StatelessWidget {
  final ExpenseCategory category;

  const ExpenseCategoryChip({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        category.displayName,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}


