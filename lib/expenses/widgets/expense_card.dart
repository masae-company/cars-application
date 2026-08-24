import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/expense_model.dart';
import '../../core/constants/route_names.dart';
import '../../core/utils/date_formatters.dart';
import '../../allocations/providers/allocation_provider.dart';

class ExpenseCard extends ConsumerWidget {
  final ExpenseModel expense;

  const ExpenseCard({super.key, required this.expense});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: InkWell(
        onTap: () {
          context.go('${RouteNames.expenses}/${expense.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (expense.category != null)
                          Chip(
                            label: Text(expense.category!),
                            labelStyle: const TextStyle(fontSize: 12),
                          ),
                        const SizedBox(width: 8),
                        Text(
                          '\$${expense.amount.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormatters.formatDisplayDate(expense.transactionDate),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (expense.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        expense.description,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (expense.allocationId != null) ...[
                      const SizedBox(height: 4),
                      ref.watch(allocationProvider(expense.allocationId!)).when(
                        data: (allocation) {
                          if (allocation == null) {
                            return Text(
                              'Allocation: ${expense.allocationId!.substring(0, 8)}...',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontStyle: FontStyle.italic,
                                  ),
                            );
                          }
                          final amount = double.tryParse(allocation.vehicleId) ?? 0.0;
                          return Text(
                            'From Allocation: \$${amount.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontStyle: FontStyle.italic,
                                ),
                          );
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => Text(
                          'Allocation: ${expense.allocationId!.substring(0, 8)}...',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (expense.receiptUrl != null)
                    const Icon(Icons.receipt),
                  if (expense.allocationId != null)
                    Icon(
                      Icons.account_balance_wallet,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

