import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/allocation_provider.dart';
import '../providers/allocation_balance_provider.dart';
import '../models/allocation_model.dart';
import '../widgets/allocation_status_chip.dart';
import '../widgets/allocation_timeline.dart';
import '../../core/utils/date_formatters.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../auth/providers/user_provider.dart';

class AllocationDetailScreen extends ConsumerWidget {
  final String allocationId;

  const AllocationDetailScreen({super.key, required this.allocationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allocationAsync = ref.watch(allocationProvider(allocationId));

    return allocationAsync.when(
      data: (allocation) {
        if (allocation == null) {
          return const Center(child: Text('Allocation not found'));
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
                    'Allocation Details',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  AllocationStatusChip(status: allocation.status),
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
                        'Allocation Information',
                        [
                          _buildAmountRow(context, allocation),
                          _buildBalanceRow(context, ref, allocation.id),
                          _buildInfoRowWithUser(
                            ref,
                            'Allocated To',
                            allocation.allocatedTo,
                          ),
                          _buildInfoRowWithUser(
                            ref,
                            'Given By',
                            allocation.requestedBy,
                          ),
                          _buildInfoRow(
                            'Status',
                            allocation.status.displayName,
                          ),
                          _buildInfoRow(
                            'Date Given',
                            DateFormatters.formatDisplayDateTime(
                              allocation.requestDate,
                            ),
                          ),
                          if (allocation.handoverDate != null)
                            _buildInfoRow(
                              'Handover Date',
                              DateFormatters.formatDisplayDateTime(
                                allocation.handoverDate!,
                              ),
                            ),
                        ],
                      ),
                      if (allocation.handoverNotes != null ||
                          allocation.returnNotes != null) ...[
                        const SizedBox(height: 16),
                        _buildInfoCard(
                          context,
                          'Notes',
                          [
                            if (allocation.handoverNotes != null) ...[
                              const Text(
                                'Handover Notes:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(allocation.handoverNotes!),
                              const SizedBox(height: 16),
                            ],
                            if (allocation.returnNotes != null) ...[
                              const Text(
                                'Return Notes:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(allocation.returnNotes!),
                            ],
                          ],
                        ),
                      ],
                      if (allocation.history.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildInfoCard(
                          context,
                          'History',
                          [
                            AllocationTimeline(history: allocation.history),
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
      loading: () =>
          const LoadingIndicator(message: 'Loading allocation...'),
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
            width: 150,
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

  Widget _buildAmountRow(BuildContext context, AllocationModel allocation) {
    final amount = double.tryParse(allocation.vehicleId) ?? 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              'Amount Given',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              '\$${amount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceRow(BuildContext context, WidgetRef ref, String allocationId) {
    final balanceAsync = ref.watch(allocationBalanceProvider(allocationId));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              'Remaining Balance',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: balanceAsync.when(
              data: (balance) => Text(
                '\$${balance.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: balance >= 0 
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              loading: () => const Text('Calculating...'),
              error: (_, __) => const Text('Error calculating balance'),
            ),
          ),
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
            width: 150,
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
}

