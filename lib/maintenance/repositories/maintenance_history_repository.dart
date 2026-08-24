import '../models/maintenance_history_model.dart';
import '../../core/config/supabase_config.dart';
import '../../core/config/database_schema.dart';

class MaintenanceHistoryRepository {
  final _client = SupabaseConfig.client;

  /// Fetch all maintenance history records with optional filters
  Future<List<MaintenanceHistoryModel>> getAllMaintenanceHistory({
    String? carId,
    MaintenanceType? maintenanceTypeFilter,
    ServiceCenterType? serviceCenterTypeFilter,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  }) async {
    try {
      // Start with base query - select all columns
      dynamic query = _client
          .from(DatabaseSchema.maintenanceHistory)
          .select();

      // Apply filters BEFORE ordering
      if (carId != null) {
        query = query.eq(DatabaseSchema.carId, carId);
      }

      if (maintenanceTypeFilter != null) {
        query = query.eq(DatabaseSchema.maintenanceType, maintenanceTypeFilter.toDbValue());
      }

      if (serviceCenterTypeFilter != null) {
        query = query.eq(DatabaseSchema.serviceCenterType, serviceCenterTypeFilter.toDbValue());
      }

      if (startDate != null) {
        query = query.gte(DatabaseSchema.performedAt, startDate.toIso8601String());
      }

      if (endDate != null) {
        query = query.lte(DatabaseSchema.performedAt, endDate.toIso8601String());
      }

      // Apply ordering after filters
      query = query.order(DatabaseSchema.performedAt, ascending: false);

      // Apply pagination
      if (limit != null && offset != null) {
        query = query.range(offset, offset + limit - 1);
      } else if (limit != null) {
        query = query.limit(limit);
      }

      final response = await query;
      return (response as List)
          .map((json) => MaintenanceHistoryModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch maintenance history: $e');
    }
  }

  /// Fetch a single maintenance history record by ID
  Future<MaintenanceHistoryModel?> getMaintenanceHistoryById(String id) async {
    try {
      final response = await _client
          .from(DatabaseSchema.maintenanceHistory)
          .select()
          .eq(DatabaseSchema.id, id)
          .maybeSingle();

      if (response == null) return null;
      return MaintenanceHistoryModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch maintenance history: $e');
    }
  }

  /// Fetch maintenance history for a specific car
  Future<List<MaintenanceHistoryModel>> getMaintenanceHistoryByCarId(
    String carId, {
    MaintenanceType? maintenanceTypeFilter,
    int? limit,
    int? offset,
  }) async {
    try {
      dynamic query = _client
          .from(DatabaseSchema.maintenanceHistory)
          .select()
          .eq(DatabaseSchema.carId, carId);

      if (maintenanceTypeFilter != null) {
        query = query.eq(DatabaseSchema.maintenanceType, maintenanceTypeFilter.toDbValue());
      }

      query = query.order(DatabaseSchema.performedAt, ascending: false);

      if (limit != null && offset != null) {
        query = query.range(offset, offset + limit - 1);
      } else if (limit != null) {
        query = query.limit(limit);
      }

      final response = await query;
      return (response as List)
          .map((json) => MaintenanceHistoryModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch maintenance history for car: $e');
    }
  }

  /// Get total count of maintenance history records
  Future<int> getMaintenanceHistoryCount({
    String? carId,
    MaintenanceType? maintenanceTypeFilter,
  }) async {
    try {
      dynamic query = _client.from(DatabaseSchema.maintenanceHistory).select('id');

      if (carId != null) {
        query = query.eq(DatabaseSchema.carId, carId);
      }

      if (maintenanceTypeFilter != null) {
        query = query.eq(DatabaseSchema.maintenanceType, maintenanceTypeFilter.toDbValue());
      }

      final response = await query;
      return (response as List).length;
    } catch (e) {
      throw Exception('Failed to get maintenance history count: $e');
    }
  }
}


