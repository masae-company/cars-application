import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_model.freezed.dart';

enum TransactionType {
  allocation,
  expense;

  static TransactionType? fromString(String? value) {
    if (value == null) return null;
    try {
      return TransactionType.values.firstWhere(
        (type) => type.name == value.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  String get displayName {
    switch (this) {
      case TransactionType.allocation:
        return 'Allocation';
      case TransactionType.expense:
        return 'Expense';
    }
  }

  String toDbValue() => name;
}

@freezed
class ExpenseModel with _$ExpenseModel {
  const factory ExpenseModel({
    required String id,
    required TransactionType transactionType,
    required double amount,
    required String description,
    required String employeeId,
    required String createdBy,
    String? receiptUrl,
    String? category,
    required DateTime transactionDate,
    String? allocationId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ExpenseModel;

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    print('💰 [ExpenseModel] fromJson called');
    print('   - JSON keys: ${json.keys.toList()}');
    
    try {
      // Handle transaction type enum conversion
      final transactionTypeValue = json['transaction_type'] as String?;
      print('   - transaction_type value: $transactionTypeValue');
      final transactionType = transactionTypeValue != null
          ? TransactionType.fromString(transactionTypeValue)
          : TransactionType.expense;
      print('   - parsed transaction_type: $transactionType');
      
      // Handle timestamp parsing - Supabase returns ISO 8601 strings
      DateTime parseTimestamp(dynamic value) {
        if (value == null) {
          print('   - timestamp is null, using now()');
          return DateTime.now();
        }
        if (value is DateTime) {
          print('   - timestamp is DateTime: $value');
          return value;
        }
        if (value is String) {
          try {
            print('   - parsing timestamp string: $value');
            final parsed = DateTime.parse(value);
            print('   - parsed timestamp: $parsed');
            return parsed;
          } catch (e) {
            print('   - ERROR parsing timestamp: $e, using now()');
            return DateTime.now();
          }
        }
        print('   - timestamp is unknown type: ${value.runtimeType}, using now()');
        return DateTime.now();
      }
      
      // Handle amount - can be num, int, double, or string
      double parseAmount(dynamic value) {
        if (value == null) {
          print('   - amount is null, using 0.0');
          return 0.0;
        }
        if (value is num) {
          print('   - amount is num: $value');
          return value.toDouble();
        }
        if (value is String) {
          try {
            print('   - parsing amount string: $value');
            final parsed = double.parse(value);
            print('   - parsed amount: $parsed');
            return parsed;
          } catch (e) {
            print('   - ERROR parsing amount: $e, using 0.0');
            return 0.0;
          }
        }
        print('   - amount is unknown type: ${value.runtimeType}, using 0.0');
        return 0.0;
      }
      
      print('   - Parsing id: ${json['id']}');
      print('   - Parsing amount: ${json['amount']}');
      print('   - Parsing description: ${json['description']}');
      print('   - Parsing employee_id: ${json['employee_id']}');
      print('   - Parsing created_by: ${json['created_by']}');
      
      final expense = ExpenseModel(
        id: json['id'] as String,
        transactionType: transactionType ?? TransactionType.expense,
        amount: parseAmount(json['amount']),
        description: json['description'] as String,
        employeeId: json['employee_id'] as String,
        createdBy: json['created_by'] as String,
        receiptUrl: json['receipt_url'] as String?,
        category: json['category'] as String?,
        transactionDate: parseTimestamp(json['transaction_date']),
        allocationId: json['allocation_id'] as String?,
        createdAt: parseTimestamp(json['created_at']),
        updatedAt: parseTimestamp(json['updated_at']),
      );
      
      print('💰 [ExpenseModel] Successfully created expense: ${expense.id} - ${expense.description}');
      return expense;
    } catch (e, stack) {
      print('💰 [ExpenseModel] ERROR in fromJson: $e');
      print('💰 [ExpenseModel] Stack trace: $stack');
      print('💰 [ExpenseModel] JSON data: $json');
      rethrow;
    }
  }
}

extension ExpenseModelX on ExpenseModel {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction_type': transactionType.toDbValue(),
      'amount': amount,
      'description': description,
      'employee_id': employeeId,
      'created_by': createdBy,
      'receipt_url': receiptUrl,
      'category': category,
      'transaction_date': transactionDate.toIso8601String(),
      'allocation_id': allocationId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

