import '../models/allocation_model.dart';
import '../models/allocation_status.dart';
import '../../core/config/supabase_config.dart';
import '../../core/config/database_schema.dart';

// NOTE: Allocations are stored in the petty_cash_transactions table
// with transaction_type = 'allocation'. This repository has been updated
// to use the correct table and filter accordingly.

class AllocationRepository {
  final _client = SupabaseConfig.client;
  
  AllocationRepository() {
    print('🚗 [AllocationRepository] Constructor called');
    print('   - Supabase client initialized: true');
  }

  /// Fetch all allocations with optional filters
  /// Allocations are stored in petty_cash_transactions table with transaction_type = 'allocation'
  Future<List<AllocationModel>> getAllocations({
    AllocationStatus? statusFilter,
    String? vehicleId,
    String? userId,
    int? limit,
    int? offset,
  }) async {
    print('🚗 [AllocationRepository] getAllocations called');
    print('   - statusFilter: $statusFilter');
    print('   - vehicleId: $vehicleId');
    print('   - userId: $userId');
    print('   - limit: $limit');
    print('   - offset: $offset');
    print('   - Table name: ${DatabaseSchema.pettyCashTransactions}');
    
    try {
      print('🚗 [AllocationRepository] Creating base query...');
      // Use petty_cash_transactions table and filter by transaction_type = 'allocation'
      dynamic query = _client
          .from(DatabaseSchema.pettyCashTransactions)
          .select()
          .eq(DatabaseSchema.transactionType, 'allocation');
      print('🚗 [AllocationRepository] Base query created with transaction_type filter');

      // Note: The petty_cash_transactions table doesn't have status, vehicle_id, or allocated_to fields
      // These filters might need to be removed or mapped to different fields
      // For now, we'll comment them out and handle them differently if needed
      
      // if (statusFilter != null) {
      //   print('🚗 [AllocationRepository] Applying status filter: ${statusFilter.name}');
      //   query = query.eq(DatabaseSchema.status, statusFilter.name);
      // }

      // if (vehicleId != null) {
      //   print('🚗 [AllocationRepository] Applying vehicle_id filter: $vehicleId');
      //   query = query.eq(DatabaseSchema.vehicleId, vehicleId);
      // }

      if (userId != null) {
        print('🚗 [AllocationRepository] Applying employee_id filter: $userId');
        query = query.eq(DatabaseSchema.employeeId, userId);
      }

      print('🚗 [AllocationRepository] Applying order by created_at');
      query = query.order(DatabaseSchema.createdAt, ascending: false);

      // Apply pagination if provided
      if (limit != null && offset != null) {
        print('🚗 [AllocationRepository] Applying range: $offset to ${offset + limit - 1}');
        query = query.range(offset, offset + limit - 1);
      } else if (limit != null) {
        print('🚗 [AllocationRepository] Applying limit: $limit');
        query = query.limit(limit);
      }

      print('🚗 [AllocationRepository] Executing query...');
      final response = await query;
      print('🚗 [AllocationRepository] Query executed successfully');
      print('🚗 [AllocationRepository] Response type: ${response.runtimeType}');
      print('🚗 [AllocationRepository] Response is List: ${response is List}');
      
      if (response is List) {
        print('🚗 [AllocationRepository] Response length: ${response.length}');
        if (response.isNotEmpty) {
          print('🚗 [AllocationRepository] First item: ${response.first.toString().substring(0, response.first.toString().length > 100 ? 100 : response.first.toString().length)}...');
        }
      }
      
      print('🚗 [AllocationRepository] Converting response to AllocationModel list...');
      final allocations = (response as List)
          .map((json) {
            try {
              print('🚗 [AllocationRepository] Parsing allocation: ${json.toString().substring(0, json.toString().length > 100 ? 100 : json.toString().length)}...');
              return _mapDbToAllocationModel(json as Map<String, dynamic>);
            } catch (e, stack) {
              print('🚗 [AllocationRepository] ERROR parsing allocation: $e');
              print('🚗 [AllocationRepository] Stack trace: $stack');
              print('🚗 [AllocationRepository] JSON data: $json');
              rethrow;
            }
          })
          .toList();

      print('🚗 [AllocationRepository] Loading history for ${allocations.length} allocations...');
      // Load history for each allocation
      for (var i = 0; i < allocations.length; i++) {
        print('🚗 [AllocationRepository] Loading history for allocation ${i + 1}/${allocations.length}');
        allocations[i] = await _loadHistory(allocations[i]);
      }

      print('🚗 [AllocationRepository] Successfully parsed ${allocations.length} allocations');
      return allocations;
    } catch (e, stack) {
      print('🚗 [AllocationRepository] ERROR in getAllocations: $e');
      print('🚗 [AllocationRepository] Stack trace: $stack');
      print('🚗 [AllocationRepository] Error type: ${e.runtimeType}');
      throw Exception('Failed to fetch allocations: $e');
    }
  }

  /// Fetch a single allocation by ID
  Future<AllocationModel?> getAllocationById(String id) async {
    try {
      final response = await _client
          .from(DatabaseSchema.pettyCashTransactions)
          .select()
          .eq(DatabaseSchema.id, id)
          .eq(DatabaseSchema.transactionType, 'allocation')
          .maybeSingle();

      if (response == null) {
        return null;
      }

      var allocation = _mapDbToAllocationModel(response);
      allocation = await _loadHistory(allocation);
      return allocation;
    } catch (e) {
      throw Exception('Failed to fetch allocation: $e');
    }
  }

  /// Maps database fields from petty_cash_transactions to AllocationModel
  /// Allocations are money given to employees, stored in petty_cash_transactions
  AllocationModel _mapDbToAllocationModel(Map<String, dynamic> dbData) {
    // Parse dates once
    final transactionDate = dbData[DatabaseSchema.transactionDate] != null
        ? DateTime.parse(dbData[DatabaseSchema.transactionDate] as String)
        : null;
    final createdAt = DateTime.parse(dbData[DatabaseSchema.createdAt] as String);
    final updatedAt = dbData[DatabaseSchema.updatedAt] != null
        ? DateTime.parse(dbData[DatabaseSchema.updatedAt] as String)
        : createdAt;
    
    final requestDate = transactionDate ?? createdAt;
    final handoverDate = transactionDate ?? createdAt;
    
    // Get amount from database (money allocated)
    final amount = (dbData[DatabaseSchema.amount] as num?)?.toDouble() ?? 0.0;
    
    final mappedData = <String, dynamic>{
      'id': dbData[DatabaseSchema.id] as String,
      // vehicleId field is required by model but not applicable for money allocations
      // Store amount as string in vehicleId field for now (will display in UI)
      'vehicleId': amount.toStringAsFixed(2),
      // employee_id -> allocatedTo (employee receiving the money)
      'allocatedTo': dbData[DatabaseSchema.employeeId] as String? ?? '',
      // created_by -> requestedBy (person who created the allocation)
      'requestedBy': dbData[DatabaseSchema.createdBy] as String? ?? '',
      'approvedBy': null,
      // Default to handedOver since we removed approvals
      'status': 'handedOver',
      // transaction_date -> requestDate (convert to ISO8601 string)
      'requestDate': requestDate.toIso8601String(),
      'approvalDate': null,
      'handoverDate': handoverDate.toIso8601String(),
      'returnDate': null,
      'expectedReturnDate': null,
      'handoverMileage': null,
      'returnMileage': null,
      // Store description and category in notes
      'handoverNotes': dbData[DatabaseSchema.description] as String? ?? 
                      (dbData[DatabaseSchema.category] as String?),
      'returnNotes': null,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'history': <Map<String, dynamic>>[],
    };
    
    return AllocationModel.fromJson(mappedData);
  }

  Future<AllocationModel> _loadHistory(AllocationModel allocation) async {
    // Note: There's no allocation_history table in the schema
    // History might be stored differently or not available
    // For now, return allocation without history
    // History is already set to empty list in _mapDbToAllocationModel
    return allocation;
  }

  Future<AllocationModel> createAllocation(
    AllocationModel allocation, {
    String? receiptUrl,
  }) async {
    try {
      // Parse amount from vehicleId field (where we temporarily store it)
      final amount = double.tryParse(allocation.vehicleId) ?? 0.0;
      
      // Map AllocationModel fields to database fields
      final data = <String, dynamic>{
        DatabaseSchema.transactionType: 'allocation',
        DatabaseSchema.employeeId: allocation.allocatedTo,
        DatabaseSchema.createdBy: allocation.requestedBy,
        DatabaseSchema.transactionDate: allocation.handoverDate?.toIso8601String() ?? 
                                        allocation.requestDate.toIso8601String(),
        DatabaseSchema.description: allocation.handoverNotes,
        DatabaseSchema.category: allocation.handoverNotes, // Use notes as category
        DatabaseSchema.amount: amount, // Money allocated to employee
      };

      // Add receipt URL if available
      if (receiptUrl != null && receiptUrl.isNotEmpty) {
        data[DatabaseSchema.receiptUrl] = receiptUrl;
      }

      final response = await _client
          .from(DatabaseSchema.pettyCashTransactions)
          .insert(data)
          .select()
          .single();

      return _mapDbToAllocationModel(response);
    } catch (e) {
      throw Exception('Failed to create allocation: $e');
    }
  }

  Future<AllocationModel> updateAllocation(AllocationModel allocation) async {
    try {
      // Parse amount from vehicleId field (where we temporarily store it)
      final amount = double.tryParse(allocation.vehicleId) ?? 0.0;
      
      // Map AllocationModel fields to database fields
      final data = <String, dynamic>{
        DatabaseSchema.employeeId: allocation.allocatedTo,
        DatabaseSchema.createdBy: allocation.requestedBy,
        DatabaseSchema.transactionDate: allocation.handoverDate?.toIso8601String() ?? 
                                        allocation.requestDate.toIso8601String(),
        DatabaseSchema.description: allocation.handoverNotes,
        DatabaseSchema.category: allocation.handoverNotes,
        DatabaseSchema.amount: amount, // Money allocated to employee
        DatabaseSchema.updatedAt: DateTime.now().toIso8601String(),
      };

      final response = await _client
          .from(DatabaseSchema.pettyCashTransactions)
          .update(data)
          .eq(DatabaseSchema.id, allocation.id)
          .eq(DatabaseSchema.transactionType, 'allocation')
          .select()
          .single();

      return _mapDbToAllocationModel(response);
    } catch (e) {
      throw Exception('Failed to update allocation: $e');
    }
  }

  Future<void> addHistoryEntry(
    String allocationId,
    AllocationStatus status,
    String? notes,
    String? changedBy,
  ) async {
    // Note: History might need to be stored differently since there's no allocation_history table
    // This might need to be redesigned based on your requirements
    try {
      // For now, we could create a new transaction with allocation_id pointing to parent
      // But this would require different fields - this needs to be redesigned
      throw Exception('History entry not implemented - needs schema redesign');
    } catch (e) {
      throw Exception('Failed to add history entry: $e');
    }
  }

  Future<void> deleteAllocation(String id) async {
    try {
      await _client
          .from(DatabaseSchema.pettyCashTransactions)
          .delete()
          .eq(DatabaseSchema.id, id)
          .eq(DatabaseSchema.transactionType, 'allocation');
    } catch (e) {
      throw Exception('Failed to delete allocation: $e');
    }
  }
}

