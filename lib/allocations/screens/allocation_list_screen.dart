import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/allocation_status.dart';
import '../providers/allocation_provider.dart';
import '../widgets/allocation_card.dart';
import '../../core/constants/route_names.dart';
import '../../core/widgets/loading_indicator.dart';

class AllocationListScreen extends ConsumerStatefulWidget {
  const AllocationListScreen({super.key});

  @override
  ConsumerState<AllocationListScreen> createState() =>
      _AllocationListScreenState();
}

class _AllocationListScreenState extends ConsumerState<AllocationListScreen> {
  AllocationStatus? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    print('🖥️ [AllocationListScreen] build() called');
    
    final params = AllocationListParams(statusFilter: _selectedStatus);
    print('🖥️ [AllocationListScreen] Params: $params');
    
    final allocationsAsync = ref.watch(allocationListProvider(params));
    print('🖥️ [AllocationListScreen] allocationsAsync state: ${allocationsAsync.runtimeType}');
    print('   - isLoading: ${allocationsAsync.isLoading}');
    print('   - hasValue: ${allocationsAsync.hasValue}');
    print('   - hasError: ${allocationsAsync.hasError}');
    if (allocationsAsync.hasError) {
      print('   - error: ${allocationsAsync.error}');
      print('   - stack: ${allocationsAsync.stackTrace}');
    }
    if (allocationsAsync.hasValue) {
      print('   - value length: ${allocationsAsync.value?.length ?? 0}');
      print('   - value is not null: ${allocationsAsync.value != null}');
    }
    
    print('🖥️ [AllocationListScreen] About to call allocationsAsync.when()');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DropdownButton<AllocationStatus?>(
                value: _selectedStatus,
                hint: const Text('Filter by status'),
                items: [
                  const DropdownMenuItem<AllocationStatus?>(
                    value: null,
                    child: Text('All Statuses'),
                  ),
                  ...AllocationStatus.values.map(
                    (status) => DropdownMenuItem<AllocationStatus?>(
                      value: status,
                      child: Text(status.displayName),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {
                  context.push(RouteNames.allocationRequest);
                },
                icon: const Icon(Icons.add),
                label: const Text('Give Allocation'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: allocationsAsync.when(
              data: (allocations) {
                print('🖥️ [AllocationListScreen] when() data callback called with ${allocations.length} allocations');
                if (allocations.isEmpty) {
                  return const Center(
                    child: Text('No allocations found'),
                  );
                }
                return ListView.builder(
                  itemCount: allocations.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: AllocationCard(allocation: allocations[index]),
                    );
                  },
                );
              },
              loading: () {
                print('🖥️ [AllocationListScreen] when() loading callback called');
                return const LoadingIndicator(message: 'Loading allocations...');
              },
              error: (error, stack) {
                print('🖥️ [AllocationListScreen] when() error callback called');
                print('   - error: $error');
                print('   - stack: $stack');
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: $error'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.invalidate(allocationListProvider(params));
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

