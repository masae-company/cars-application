import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/expense_provider.dart';
import '../../core/utils/date_formatters.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../allocations/providers/allocation_provider.dart';
import '../../auth/providers/user_provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/route_names.dart';

class ExpenseDetailScreen extends ConsumerWidget {
  final String expenseId;

  const ExpenseDetailScreen({super.key, required this.expenseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseAsync = ref.watch(expenseProvider(expenseId));

    return expenseAsync.when(
      data: (expense) {
        if (expense == null) {
          return const Center(child: Text('Expense not found'));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Expense Details',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Chip(
                    label: Text(expense.transactionType.displayName),
                    labelStyle: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoCard(
                        context,
                        'Expense Information',
                        [
                          _buildInfoRow('Amount', '\$${expense.amount.toStringAsFixed(2)}'),
                          _buildInfoRow('Transaction Type', expense.transactionType.displayName),
                          _buildInfoRow(
                            'Date',
                            DateFormatters.formatDisplayDate(expense.transactionDate),
                          ),
                          _buildInfoRowWithUser(ref, 'Employee', expense.employeeId),
                          if (expense.category != null)
                            _buildInfoRow('Category', expense.category!),
                          if (expense.allocationId != null)
                            _buildAllocationRow(context, ref, expense.allocationId!),
                          if (expense.description.isNotEmpty)
                            _buildInfoRow('Description', expense.description),
                        ],
                      ),
                      if (expense.receiptUrl != null) ...[
                        const SizedBox(height: 16),
                        _buildInfoCard(
                          context,
                          'Receipt',
                          [
                            InkWell(
                              onTap: () {
                                // Open receipt URL
                              },
                              child: const Text(
                                'View Receipt',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const LoadingIndicator(message: 'Loading expense...'),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildInfoRowWithUser(WidgetRef ref, String label, String userId) {
    final userAsync = ref.watch(userProvider(userId));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: userAsync.when(
              data: (user) => Text(user?.name ?? user?.email ?? userId),
              loading: () => const Text('Loading...'),
              error: (_, __) => Text(userId),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllocationRow(BuildContext context, WidgetRef ref, String allocationId) {
    final allocationAsync = ref.watch(allocationProvider(allocationId));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              'Allocation',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: allocationAsync.when(
              data: (allocation) {
                if (allocation == null) {
                  return Text(allocationId);
                }
                final amount = double.tryParse(allocation.vehicleId) ?? 0.0;
                return InkWell(
                  onTap: () {
                    context.push('${RouteNames.allocations}/$allocationId');
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Allocation #${allocationId.substring(0, 8)}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Text(
                              'Amount: \$${amount.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Text('Loading...'),
              error: (_, __) => Text(allocationId),
            ),
          ),
        ],
      ),
    );
  }
}
