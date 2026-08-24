import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/expense_provider.dart';
import '../models/expense_model.dart';
import '../widgets/expense_card.dart';
import '../../core/constants/route_names.dart';
import '../../core/widgets/loading_indicator.dart';

class ExpenseListScreen extends ConsumerStatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  ConsumerState<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends ConsumerState<ExpenseListScreen> {
  String? _selectedCategory;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    print('🖥️ [ExpenseListScreen] build() called');
    
    final params = ExpenseListParams(
      transactionTypeFilter: TransactionType.expense, // Only show expenses, not allocations
      categoryFilter: _selectedCategory,
      startDate: _startDate,
      endDate: _endDate,
    );
    print('🖥️ [ExpenseListScreen] Params: $params');
    
    final expensesAsync = ref.watch(expenseListProvider(params));
    print('🖥️ [ExpenseListScreen] expensesAsync state: ${expensesAsync.runtimeType}');
    print('   - isLoading: ${expensesAsync.isLoading}');
    print('   - hasValue: ${expensesAsync.hasValue}');
    print('   - hasError: ${expensesAsync.hasError}');
    if (expensesAsync.hasError) {
      print('   - error: ${expensesAsync.error}');
      print('   - stack: ${expensesAsync.stackTrace}');
    }
    if (expensesAsync.hasValue) {
      print('   - value length: ${expensesAsync.value?.length ?? 0}');
      print('   - value is not null: ${expensesAsync.value != null}');
    }
    
    print('🖥️ [ExpenseListScreen] About to call expensesAsync.when()');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Filter by category',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value.isEmpty ? null : value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  final range = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now(),
                  );
                  if (range != null) {
                    setState(() {
                      _startDate = range.start;
                      _endDate = range.end;
                    });
                  }
                },
                icon: const Icon(Icons.date_range),
                label: const Text('Date Range'),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {
                  context.push(RouteNames.expenseCreate);
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Expense'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: expensesAsync.when(
              data: (expenses) {
                print('🖥️ [ExpenseListScreen] when() data callback called with ${expenses.length} expenses');
                if (expenses.isEmpty) {
                  return const Center(
                    child: Text('No expenses found'),
                  );
                }
                return ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ExpenseCard(expense: expenses[index]),
                    );
                  },
                );
              },
              loading: () {
                print('🖥️ [ExpenseListScreen] when() loading callback called');
                return const LoadingIndicator(message: 'Loading expenses...');
              },
              error: (error, stack) {
                print('🖥️ [ExpenseListScreen] when() error callback called');
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
                          ref.invalidate(expenseListProvider(params));
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
