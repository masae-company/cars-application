import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/allocation_model.dart';
import 'allocation_status_chip.dart';
import '../../core/constants/route_names.dart';
import '../../core/utils/date_formatters.dart';
import '../../auth/providers/user_provider.dart';
import '../providers/allocation_balance_provider.dart';

class AllocationCard extends ConsumerWidget {
  final AllocationModel allocation;

  const AllocationCard({super.key, required this.allocation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch employee name
    final employeeAsync = ref.watch(userProvider(allocation.allocatedTo));
    final givenByAsync = ref.watch(userProvider(allocation.requestedBy));
    
    // Get amount from vehicleId field (where we stored it temporarily)
    final amount = double.tryParse(allocation.vehicleId) ?? 0.0;
    
    // Get remaining balance
    final balanceAsync = ref.watch(allocationBalanceProvider(allocation.id));
    
    return Card(
      child: InkWell(
        onTap: () {
          context.go('${RouteNames.allocations}/${allocation.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Allocation #${allocation.id.length > 8 ? allocation.id.substring(0, 8) : allocation.id}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Amount: \$${amount.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        balanceAsync.when(
                          data: (balance) => Text(
                            'Remaining: \$${balance.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: balance >= 0 
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.error,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          loading: () => Text(
                            'Remaining: Calculating...',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                  AllocationStatusChip(status: allocation.status),
                ],
              ),
              const SizedBox(height: 8),
              employeeAsync.when(
                data: (employee) => Text(
                  'Employee: ${employee?.name ?? employee?.email ?? allocation.allocatedTo}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                loading: () => Text(
                  'Employee: Loading...',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                error: (_, __) => Text(
                  'Employee: ${allocation.allocatedTo}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 4),
              givenByAsync.when(
                data: (user) => Text(
                  'Given by: ${user?.name ?? user?.email ?? allocation.requestedBy}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                ),
                loading: () => Text(
                  'Given by: Loading...',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                ),
                error: (_, __) => Text(
                  'Given by: ${allocation.requestedBy}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Date: ${DateFormatters.formatDisplayDate(allocation.requestDate)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (allocation.handoverNotes != null && allocation.handoverNotes!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  'Notes: ${allocation.handoverNotes}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

