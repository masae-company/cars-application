import 'dart:io';
import 'dart:typed_data';
import '../models/expense_model.dart';
import '../../core/config/supabase_config.dart';
import '../../core/config/database_schema.dart';

class ExpenseRepository {
  final _client = SupabaseConfig.client;
  
  ExpenseRepository() {
    print('💰 [ExpenseRepository] Constructor called');
    print('   - Supabase client initialized: true');
  }

  /// Fetch all expenses with optional filters
  Future<List<ExpenseModel>> getAllExpenses({
    TransactionType? transactionTypeFilter,
    String? categoryFilter,
    String? employeeId,
    String? allocationId,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  }) async {
    print('💰 [ExpenseRepository] getAllExpenses called');
    print('   - transactionTypeFilter: $transactionTypeFilter');
    print('   - categoryFilter: $categoryFilter');
    print('   - employeeId: $employeeId');
    print('   - allocationId: $allocationId');
    print('   - startDate: $startDate');
    print('   - endDate: $endDate');
    print('   - limit: $limit');
    print('   - offset: $offset');
    print('   - Table name: ${DatabaseSchema.pettyCashTransactions}');
    
    try {
      print('💰 [ExpenseRepository] Creating base query...');
      dynamic query = _client.from(DatabaseSchema.pettyCashTransactions).select();
      print('💰 [ExpenseRepository] Base query created');

      if (transactionTypeFilter != null) {
        print('💰 [ExpenseRepository] Applying transaction_type filter: ${transactionTypeFilter.toDbValue()}');
        query = query.eq(DatabaseSchema.transactionType, transactionTypeFilter.toDbValue());
      }

      if (categoryFilter != null && categoryFilter.isNotEmpty) {
        print('💰 [ExpenseRepository] Applying category filter: $categoryFilter');
        query = query.eq(DatabaseSchema.category, categoryFilter);
      }

      if (employeeId != null) {
        print('💰 [ExpenseRepository] Applying employee_id filter: $employeeId');
        query = query.eq(DatabaseSchema.employeeId, employeeId);
      }

      if (allocationId != null) {
        print('💰 [ExpenseRepository] Applying allocation_id filter: $allocationId');
        query = query.eq(DatabaseSchema.allocationId, allocationId);
      }

      if (startDate != null) {
        print('💰 [ExpenseRepository] Applying startDate filter: $startDate');
        query = query.gte(
          DatabaseSchema.transactionDate,
          startDate.toIso8601String(),
        );
      }

      if (endDate != null) {
        print('💰 [ExpenseRepository] Applying endDate filter: $endDate');
        query = query.lte(
          DatabaseSchema.transactionDate,
          endDate.toIso8601String(),
        );
      }

      print('💰 [ExpenseRepository] Applying order by transaction_date');
      query = query.order(DatabaseSchema.transactionDate, ascending: false);

      // Apply pagination if provided
      if (limit != null && offset != null) {
        print('💰 [ExpenseRepository] Applying range: $offset to ${offset + limit - 1}');
        query = query.range(offset, offset + limit - 1);
      } else if (limit != null) {
        print('💰 [ExpenseRepository] Applying limit: $limit');
        query = query.limit(limit);
      }

      print('💰 [ExpenseRepository] Executing query...');
      final response = await query;
      print('💰 [ExpenseRepository] Query executed successfully');
      print('💰 [ExpenseRepository] Response type: ${response.runtimeType}');
      print('💰 [ExpenseRepository] Response is List: ${response is List}');
      
      if (response is List) {
        print('💰 [ExpenseRepository] Response length: ${response.length}');
        if (response.isNotEmpty) {
          print('💰 [ExpenseRepository] First item: ${response.first.toString().substring(0, response.first.toString().length > 100 ? 100 : response.first.toString().length)}...');
        }
      }
      
      print('💰 [ExpenseRepository] Converting response to ExpenseModel list...');
      final expenses = (response as List)
          .map((json) {
            try {
              print('💰 [ExpenseRepository] Parsing expense: ${json.toString().substring(0, json.toString().length > 100 ? 100 : json.toString().length)}...');
              return ExpenseModel.fromJson(json as Map<String, dynamic>);
            } catch (e, stack) {
              print('💰 [ExpenseRepository] ERROR parsing expense: $e');
              print('💰 [ExpenseRepository] Stack trace: $stack');
              print('💰 [ExpenseRepository] JSON data: $json');
              rethrow;
            }
          })
          .toList();
      
      print('💰 [ExpenseRepository] Successfully parsed ${expenses.length} expenses');
      return expenses;
    } catch (e, stack) {
      print('💰 [ExpenseRepository] ERROR in getAllExpenses: $e');
      print('💰 [ExpenseRepository] Stack trace: $stack');
      print('💰 [ExpenseRepository] Error type: ${e.runtimeType}');
      throw Exception('Failed to fetch expenses: $e');
    }
  }

  /// Fetch a single expense by ID
  Future<ExpenseModel?> getExpenseById(String id) async {
    try {
      final response = await _client
          .from(DatabaseSchema.pettyCashTransactions)
          .select()
          .eq(DatabaseSchema.id, id)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return ExpenseModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch expense: $e');
    }
  }

  Future<ExpenseModel> createExpense(ExpenseModel expense) async {
    try {
      final data = expense.toJson();
      data.remove('id');
      data.remove(DatabaseSchema.createdAt);
      data.remove(DatabaseSchema.updatedAt);
      
      // Convert transaction type enum to string
      if (data['transaction_type'] != null) {
        data['transaction_type'] = expense.transactionType.toDbValue();
      }

      final response = await _client
          .from(DatabaseSchema.pettyCashTransactions)
          .insert(data)
          .select()
          .single();

      return ExpenseModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create expense: $e');
    }
  }

  Future<ExpenseModel> updateExpense(ExpenseModel expense) async {
    try {
      final data = expense.toJson();
      data.remove('id');
      data[DatabaseSchema.updatedAt] = DateTime.now().toIso8601String();
      
      // Convert transaction type enum to string
      if (data['transaction_type'] != null) {
        data['transaction_type'] = expense.transactionType.toDbValue();
      }

      final response = await _client
          .from(DatabaseSchema.pettyCashTransactions)
          .update(data)
          .eq(DatabaseSchema.id, expense.id)
          .select()
          .single();

      return ExpenseModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update expense: $e');
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      await _client
          .from(DatabaseSchema.pettyCashTransactions)
          .delete()
          .eq(DatabaseSchema.id, id);
    } catch (e) {
      throw Exception('Failed to delete expense: $e');
    }
  }

  Future<String> uploadReceipt(String filePath, String fileName) async {
    try {
      // Read file from path
      final file = File(filePath);
      final fileBytes = await file.readAsBytes();

      // Upload to Supabase storage
      await SupabaseConfig.client.storage
          .from('receipts')
          .uploadBinary(fileName, fileBytes);

      // Get public URL
      final url = SupabaseConfig.client.storage
          .from('receipts')
          .getPublicUrl(fileName);

      return url;
    } catch (e) {
      // If bucket doesn't exist or upload fails, return empty string
      // In production, handle this properly with proper error handling
      return '';
    }
  }

  /// Upload receipt from bytes (web-compatible)
  Future<String> uploadReceiptBytes(List<int> fileBytes, String fileName) async {
    try {
      // Convert to Uint8List if needed
      final bytes = fileBytes is Uint8List ? fileBytes : Uint8List.fromList(fileBytes);
      
      // Upload to Supabase storage
      await SupabaseConfig.client.storage
          .from('receipts')
          .uploadBinary(fileName, bytes);

      // Get public URL
      final url = SupabaseConfig.client.storage
          .from('receipts')
          .getPublicUrl(fileName);

      return url;
    } catch (e) {
      // If bucket doesn't exist or upload fails, return empty string
      // In production, handle this properly with proper error handling
      return '';
    }
  }
}

