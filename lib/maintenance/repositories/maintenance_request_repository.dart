import '../models/maintenance_request_model.dart';
import '../../core/config/supabase_config.dart';
import '../../core/config/database_schema.dart';

class MaintenanceRequestRepository {
  final _client = SupabaseConfig.client;

  /// Fetch all maintenance requests with optional filters
  Future<List<MaintenanceRequestModel>> getAllMaintenanceRequests({
    String? carId,
    MaintenanceRequestStatus? statusFilter,
    int? limit,
    int? offset,
  }) async {
    try {
      // Start with base query - select all columns
      dynamic query = _client
          .from(DatabaseSchema.maintenanceRequest)
          .select();

      // Apply filters BEFORE ordering (this is important for Supabase query builder)
      if (carId != null) {
        query = query.eq(DatabaseSchema.carId, carId);
      }

      if (statusFilter != null) {
        query = query.eq(DatabaseSchema.status, statusFilter.toDbValue());
      }

      // Apply ordering after filters
      query = query.order(DatabaseSchema.requestedAt, ascending: false);

      // Apply pagination
      if (limit != null && offset != null) {
        query = query.range(offset, offset + limit - 1);
      } else if (limit != null) {
        query = query.limit(limit);
      }

      final response = await query;
      return (response as List)
          .map((json) => MaintenanceRequestModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch maintenance requests: $e');
    }
  }

  /// Fetch a single maintenance request by ID
  Future<MaintenanceRequestModel?> getMaintenanceRequestById(String id) async {
    try {
      final response = await _client
          .from(DatabaseSchema.maintenanceRequest)
          .select()
          .eq(DatabaseSchema.id, id)
          .maybeSingle();

      if (response == null) return null;
      return MaintenanceRequestModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch maintenance request: $e');
    }
  }

  /// Update maintenance request status
  Future<MaintenanceRequestModel> updateMaintenanceRequestStatus(
    String id,
    MaintenanceRequestStatus status,
  ) async {
    try {
      final updateData = <String, dynamic>{
        DatabaseSchema.status: status.toDbValue(),
        DatabaseSchema.updatedAt: DateTime.now().toIso8601String(),
      };

      if (status == MaintenanceRequestStatus.inProgress) {
        updateData[DatabaseSchema.inProgressAt] = DateTime.now().toIso8601String();
      } else if (status == MaintenanceRequestStatus.completed) {
        updateData[DatabaseSchema.completedAt] = DateTime.now().toIso8601String();
      }

      final response = await _client
          .from(DatabaseSchema.maintenanceRequest)
          .update(updateData)
          .eq(DatabaseSchema.id, id)
          .select()
          .single();

      return MaintenanceRequestModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update maintenance request status: $e');
    }
  }

  /// Create a new maintenance request
  Future<MaintenanceRequestModel> createMaintenanceRequest(
    MaintenanceRequestModel request,
  ) async {
    try {
      final insertData = <String, dynamic>{
        DatabaseSchema.carId: request.carId,
        DatabaseSchema.requestedAt: request.requestedAt.toIso8601String(),
        DatabaseSchema.status: request.status.toDbValue(),
        DatabaseSchema.notes: request.notes,
        DatabaseSchema.oilChangePreviousKm: request.oilChangePreviousKm,
        DatabaseSchema.oilChangeCurrentKm: request.oilChangeCurrentKm,
        DatabaseSchema.brakePadsLastChanged: request.brakePadsLastChanged?.toIso8601String(),
        DatabaseSchema.sparkPlugsLastChanged: request.sparkPlugsLastChanged?.toIso8601String(),
        DatabaseSchema.tyresLastChanged: request.tyresLastChanged?.toIso8601String(),
        DatabaseSchema.acService: request.acService,
        DatabaseSchema.lightsService: request.lightsService,
        DatabaseSchema.tyreStackingService: request.tyreStackingService,
        DatabaseSchema.tyresPositions: request.tyresPositions,
        DatabaseSchema.invoiceUrl: request.invoiceUrl,
      };

      final response = await _client
          .from(DatabaseSchema.maintenanceRequest)
          .insert(insertData)
          .select()
          .single();

      return MaintenanceRequestModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create maintenance request: $e');
    }
  }

  /// Update maintenance request
  Future<MaintenanceRequestModel> updateMaintenanceRequest(
    MaintenanceRequestModel request,
  ) async {
    try {
      final updateData = <String, dynamic>{
        DatabaseSchema.status: request.status.toDbValue(),
        DatabaseSchema.notes: request.notes,
        DatabaseSchema.oilChangePreviousKm: request.oilChangePreviousKm,
        DatabaseSchema.oilChangeCurrentKm: request.oilChangeCurrentKm,
        DatabaseSchema.brakePadsLastChanged: request.brakePadsLastChanged?.toIso8601String(),
        DatabaseSchema.sparkPlugsLastChanged: request.sparkPlugsLastChanged?.toIso8601String(),
        DatabaseSchema.tyresLastChanged: request.tyresLastChanged?.toIso8601String(),
        DatabaseSchema.acService: request.acService,
        DatabaseSchema.lightsService: request.lightsService,
        DatabaseSchema.tyreStackingService: request.tyreStackingService,
        DatabaseSchema.tyresPositions: request.tyresPositions,
        DatabaseSchema.invoiceUrl: request.invoiceUrl,
        DatabaseSchema.updatedAt: DateTime.now().toIso8601String(),
      };

      if (request.status == MaintenanceRequestStatus.inProgress && request.inProgressAt == null) {
        updateData[DatabaseSchema.inProgressAt] = DateTime.now().toIso8601String();
      }

      if (request.status == MaintenanceRequestStatus.completed && request.completedAt == null) {
        updateData[DatabaseSchema.completedAt] = DateTime.now().toIso8601String();
      }

      final response = await _client
          .from(DatabaseSchema.maintenanceRequest)
          .update(updateData)
          .eq(DatabaseSchema.id, request.id)
          .select()
          .single();

      return MaintenanceRequestModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update maintenance request: $e');
    }
  }
}

