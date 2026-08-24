import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/expense_model.dart';
import '../repositories/expense_repository.dart';

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepository();
});

final expenseListProvider =
    FutureProvider.family<List<ExpenseModel>, ExpenseListParams>(
  (ref, params) async {
    print('📦 [ExpenseProvider] expenseListProvider called');
    print('   - params: $params');
    
    try {
      print('📦 [ExpenseProvider] Getting repository...');
      final repository = ref.watch(expenseRepositoryProvider);
      print('📦 [ExpenseProvider] Repository obtained, calling getAllExpenses...');
      
      final result = await repository.getAllExpenses(
        transactionTypeFilter: params.transactionTypeFilter,
        categoryFilter: params.categoryFilter,
        employeeId: params.employeeId,
        allocationId: params.allocationId,
        startDate: params.startDate,
        endDate: params.endDate,
        limit: params.limit,
        offset: params.offset,
      );
      
      print('📦 [ExpenseProvider] getAllExpenses completed successfully');
      print('📦 [ExpenseProvider] Result count: ${result.length}');
      return result;
    } catch (e, stack) {
      print('📦 [ExpenseProvider] ERROR in expenseListProvider: $e');
      print('📦 [ExpenseProvider] Stack trace: $stack');
      rethrow;
    }
  },
);

class ExpenseListParams {
  final TransactionType? transactionTypeFilter;
  final String? categoryFilter;
  final String? employeeId;
  final String? allocationId;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? limit;
  final int? offset;

  ExpenseListParams({
    this.transactionTypeFilter,
    this.categoryFilter,
    this.employeeId,
    this.allocationId,
    this.startDate,
    this.endDate,
    this.limit,
    this.offset,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExpenseListParams &&
        other.transactionTypeFilter == transactionTypeFilter &&
        other.categoryFilter == categoryFilter &&
        other.employeeId == employeeId &&
        other.allocationId == allocationId &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.limit == limit &&
        other.offset == offset;
  }

  @override
  int get hashCode {
    return Object.hash(
      transactionTypeFilter,
      categoryFilter,
      employeeId,
      allocationId,
      startDate,
      endDate,
      limit,
      offset,
    );
  }

  @override
  String toString() {
    return 'ExpenseListParams(transactionTypeFilter: $transactionTypeFilter, categoryFilter: $categoryFilter, employeeId: $employeeId, allocationId: $allocationId, startDate: $startDate, endDate: $endDate, limit: $limit, offset: $offset)';
  }
}

final expenseProvider = FutureProvider.family<ExpenseModel?, String>(
  (ref, id) async {
    if (id.isEmpty) return null;
    final repository = ref.watch(expenseRepositoryProvider);
    return repository.getExpenseById(id);
  },
);

final createExpenseProvider = FutureProvider.family<ExpenseModel, ExpenseModel>(
  (ref, expense) async {
    final repository = ref.watch(expenseRepositoryProvider);
    return repository.createExpense(expense);
  },
);

final updateExpenseProvider = FutureProvider.family<ExpenseModel, ExpenseModel>(
  (ref, expense) async {
    final repository = ref.watch(expenseRepositoryProvider);
    return repository.updateExpense(expense);
  },
);

final deleteExpenseProvider = FutureProvider.family<void, String>(
  (ref, id) async {
    final repository = ref.watch(expenseRepositoryProvider);
    await repository.deleteExpense(id);
  },
);

