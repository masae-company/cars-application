import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'allocation_provider.dart';
import '../../expenses/providers/expense_provider.dart';
import '../../expenses/models/expense_model.dart';

/// Calculate remaining balance for an allocation
/// Balance = Allocation Amount - Sum of Expenses for that allocation
final allocationBalanceProvider = FutureProvider.family<double, String>(
  (ref, allocationId) async {
    if (allocationId.isEmpty) return 0.0;
    
    // Get the allocation to find its amount
    final allocation = await ref.read(allocationProvider(allocationId).future);
    
    if (allocation == null) return 0.0;
    
    // Get amount from vehicleId field (where we stored it)
    final allocationAmount = double.tryParse(allocation.vehicleId) ?? 0.0;
    
    // Get all expenses for this allocation
    final expenses = await ref.read(
      expenseListProvider(
        ExpenseListParams(
          allocationId: allocationId,
          transactionTypeFilter: TransactionType.expense,
        ),
      ).future,
    );
    
    // Calculate total expenses
    final totalExpenses = expenses.fold<double>(
      0.0,
      (sum, expense) => sum + expense.amount,
    );
    
    // Return remaining balance
    return allocationAmount - totalExpenses;
  },
);

