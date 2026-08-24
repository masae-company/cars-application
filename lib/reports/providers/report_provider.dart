import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/usage_report.dart';
import '../models/cost_report.dart';
import '../../expenses/providers/expense_provider.dart';
import '../../expenses/models/expense_model.dart';

final usageReportProvider =
    FutureProvider.family<List<UsageReport>, UsageReportParams>(
  (ref, params) async {
    // This would aggregate allocation data
    // For now, return empty list - implementation would query allocations
    return [];
  },
);

class UsageReportParams {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? vehicleId;

  UsageReportParams({
    this.startDate,
    this.endDate,
    this.vehicleId,
  });
}

final costReportProvider =
    FutureProvider.family<CostReport?, CostReportParams>(
  (ref, params) async {
    // Only get expenses, NOT allocations
    final expenses = await ref.read(
      expenseListProvider(
        ExpenseListParams(
          transactionTypeFilter: TransactionType.expense, // Only expenses
          startDate: params.startDate,
          endDate: params.endDate,
        ),
      ).future,
    );

    double totalCost = 0;
    final costsByCategory = <String, double>{};

    for (var expense in expenses) {
      totalCost += expense.amount;
      final category = expense.category ?? 'Uncategorized';
      costsByCategory[category] =
          (costsByCategory[category] ?? 0) + expense.amount;
    }

    return CostReport(
      totalCost: totalCost,
      costsByCategory: costsByCategory,
      periodStart: params.startDate ?? DateTime.now().subtract(const Duration(days: 30)),
      periodEnd: params.endDate ?? DateTime.now(),
    );
  },
);

class CostReportParams {
  final DateTime? startDate;
  final DateTime? endDate;

  CostReportParams({
    this.startDate,
    this.endDate,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CostReportParams &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    return Object.hash(startDate, endDate);
  }
}

