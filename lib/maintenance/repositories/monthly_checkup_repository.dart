import '../models/monthly_checkup_model.dart';
import '../../core/config/supabase_config.dart';
import '../../core/config/database_schema.dart';

class MonthlyCheckupRepository {
  final _client = SupabaseConfig.client;

  /// Fetch all monthly checkups with optional filters
  Future<List<MonthlyCheckupModel>> getAllMonthlyCheckups({
    String? carId,
    String? performedBy,
    DateTime? startDate,
    DateTime? endDate,
    bool? completedOnly,
    int? limit,
    int? offset,
  }) async {
    try {
      // Start with base query - select all columns
      dynamic query = _client
          .from(DatabaseSchema.monthlyCheckups)
          .select();

      // Apply filters BEFORE ordering
      if (carId != null) {
        query = query.eq(DatabaseSchema.carId, carId);
      }

      if (performedBy != null) {
        query = query.eq(DatabaseSchema.performedBy, performedBy);
      }

      if (startDate != null) {
        query = query.gte(DatabaseSchema.checkupDate, startDate.toIso8601String());
      }

      if (endDate != null) {
        query = query.lte(DatabaseSchema.checkupDate, endDate.toIso8601String());
      }

      if (completedOnly != null && completedOnly) {
        query = query.not(DatabaseSchema.completedAtCheckup, 'is', null);
      }

      // Apply ordering after filters
      query = query.order(DatabaseSchema.checkupDate, ascending: false);

      // Apply pagination
      if (limit != null && offset != null) {
        query = query.range(offset, offset + limit - 1);
      } else if (limit != null) {
        query = query.limit(limit);
      }

      final response = await query;
      return (response as List)
          .map((json) => MonthlyCheckupModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch monthly checkups: $e');
    }
  }

  /// Fetch a single monthly checkup by ID
  Future<MonthlyCheckupModel?> getMonthlyCheckupById(String id) async {
    try {
      final response = await _client
          .from(DatabaseSchema.monthlyCheckups)
          .select()
          .eq(DatabaseSchema.id, id)
          .maybeSingle();

      if (response == null) return null;
      return MonthlyCheckupModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch monthly checkup: $e');
    }
  }

  /// Fetch monthly checkups for a specific car
  Future<List<MonthlyCheckupModel>> getMonthlyCheckupsByCarId(
    String carId, {
    bool? completedOnly,
    int? limit,
    int? offset,
  }) async {
    try {
      dynamic query = _client
          .from(DatabaseSchema.monthlyCheckups)
          .select()
          .eq(DatabaseSchema.carId, carId);

      if (completedOnly != null && completedOnly) {
        query = query.not(DatabaseSchema.completedAtCheckup, 'is', null);
      }

      query = query.order(DatabaseSchema.checkupDate, ascending: false);

      if (limit != null && offset != null) {
        query = query.range(offset, offset + limit - 1);
      } else if (limit != null) {
        query = query.limit(limit);
      }

      final response = await query;
      return (response as List)
          .map((json) => MonthlyCheckupModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch monthly checkups for car: $e');
    }
  }

  /// Get total count of monthly checkups
  Future<int> getMonthlyCheckupCount({
    String? carId,
    bool? completedOnly,
  }) async {
    try {
      dynamic query = _client.from(DatabaseSchema.monthlyCheckups).select('id');

      if (carId != null) {
        query = query.eq(DatabaseSchema.carId, carId);
      }

      if (completedOnly != null && completedOnly) {
        query = query.not(DatabaseSchema.completedAtCheckup, 'is', null);
      }

      final response = await query;
      return (response as List).length;
    } catch (e) {
      throw Exception('Failed to get monthly checkup count: $e');
    }
  }

  /// Fetch pending (incomplete) monthly checkups
  Future<List<MonthlyCheckupModel>> getPendingMonthlyCheckups({
    String? carId,
    int? limit,
    int? offset,
  }) async {
    try {
      dynamic query = _client
          .from(DatabaseSchema.monthlyCheckups)
          .select()
          .isFilter(DatabaseSchema.completedAtCheckup, null);

      if (carId != null) {
        query = query.eq(DatabaseSchema.carId, carId);
      }

      query = query.order(DatabaseSchema.checkupDate, ascending: false);

      if (limit != null && offset != null) {
        query = query.range(offset, offset + limit - 1);
      } else if (limit != null) {
        query = query.limit(limit);
      }

      final response = await query;
      return (response as List)
          .map((json) => MonthlyCheckupModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch pending monthly checkups: $e');
    }
  }

  /// Create a new monthly checkup
  Future<MonthlyCheckupModel> createMonthlyCheckup(
    MonthlyCheckupModel checkup,
  ) async {
    try {
      final insertData = <String, dynamic>{
        DatabaseSchema.carId: checkup.carId,
        DatabaseSchema.checkupDate: checkup.checkupDate.toIso8601String(),
        DatabaseSchema.performedBy: checkup.performedBy,
        DatabaseSchema.notes: checkup.notes,
        DatabaseSchema.engineOilReplaced: checkup.engineOilReplaced,
        DatabaseSchema.engineAirFilterInspected: checkup.engineAirFilterInspected,
        DatabaseSchema.engineAirFilterReplaced: checkup.engineAirFilterReplaced,
        DatabaseSchema.acAirFilterInspected: checkup.acAirFilterInspected,
        DatabaseSchema.automaticTransmissionFluidInspected: checkup.automaticTransmissionFluidInspected,
        DatabaseSchema.manualTransmissionFluidInspected: checkup.manualTransmissionFluidInspected,
        DatabaseSchema.differentialFluidInspected: checkup.differentialFluidInspected,
        DatabaseSchema.sparkPlugsInspected: checkup.sparkPlugsInspected,
        DatabaseSchema.coolantLevelInspected: checkup.coolantLevelInspected,
        DatabaseSchema.coolantConditionInspected: checkup.coolantConditionInspected,
        DatabaseSchema.brakeClutchFluidInspected: checkup.brakeClutchFluidInspected,
        DatabaseSchema.fluidLeaksInspected: checkup.fluidLeaksInspected,
        DatabaseSchema.radiatorHosesInspected: checkup.radiatorHosesInspected,
        DatabaseSchema.driveShaftsBootsInspected: checkup.driveShaftsBootsInspected,
        DatabaseSchema.fuelFilterInspected: checkup.fuelFilterInspected,
        DatabaseSchema.suspensionInspected: checkup.suspensionInspected,
        DatabaseSchema.shockAbsorberInspected: checkup.shockAbsorberInspected,
        DatabaseSchema.suspensionRetightened: checkup.suspensionRetightened,
        DatabaseSchema.engineSupportInspected: checkup.engineSupportInspected,
        DatabaseSchema.driveBeltPulleysInspected: checkup.driveBeltPulleysInspected,
        DatabaseSchema.brakeLinesInspected: checkup.brakeLinesInspected,
        DatabaseSchema.brakePadsInspected: checkup.brakePadsInspected,
        DatabaseSchema.parkBrakeInspected: checkup.parkBrakeInspected,
        DatabaseSchema.tiresInspected: checkup.tiresInspected,
        DatabaseSchema.exhaustSystemInspected: checkup.exhaustSystemInspected,
        DatabaseSchema.tiresRotated: checkup.tiresRotated,
        DatabaseSchema.lightsInspected: checkup.lightsInspected,
        DatabaseSchema.batteryInspected: checkup.batteryInspected,
        DatabaseSchema.acOperationInspected: checkup.acOperationInspected,
        DatabaseSchema.wipersInspected: checkup.wipersInspected,
        DatabaseSchema.diagnosticToolsUsed: checkup.diagnosticToolsUsed,
        DatabaseSchema.oilServiceReset: checkup.oilServiceReset,
      };

      if (checkup.completedAt != null) {
        insertData[DatabaseSchema.completedAtCheckup] = checkup.completedAt!.toIso8601String();
      }

      final response = await _client
          .from(DatabaseSchema.monthlyCheckups)
          .insert(insertData)
          .select()
          .single();

      return MonthlyCheckupModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create monthly checkup: $e');
    }
  }

  /// Update a monthly checkup
  Future<MonthlyCheckupModel> updateMonthlyCheckup(
    MonthlyCheckupModel checkup,
  ) async {
    try {
      final updateData = <String, dynamic>{
        DatabaseSchema.carId: checkup.carId,
        DatabaseSchema.checkupDate: checkup.checkupDate.toIso8601String(),
        DatabaseSchema.performedBy: checkup.performedBy,
        DatabaseSchema.notes: checkup.notes,
        DatabaseSchema.engineOilReplaced: checkup.engineOilReplaced,
        DatabaseSchema.engineAirFilterInspected: checkup.engineAirFilterInspected,
        DatabaseSchema.engineAirFilterReplaced: checkup.engineAirFilterReplaced,
        DatabaseSchema.acAirFilterInspected: checkup.acAirFilterInspected,
        DatabaseSchema.automaticTransmissionFluidInspected: checkup.automaticTransmissionFluidInspected,
        DatabaseSchema.manualTransmissionFluidInspected: checkup.manualTransmissionFluidInspected,
        DatabaseSchema.differentialFluidInspected: checkup.differentialFluidInspected,
        DatabaseSchema.sparkPlugsInspected: checkup.sparkPlugsInspected,
        DatabaseSchema.coolantLevelInspected: checkup.coolantLevelInspected,
        DatabaseSchema.coolantConditionInspected: checkup.coolantConditionInspected,
        DatabaseSchema.brakeClutchFluidInspected: checkup.brakeClutchFluidInspected,
        DatabaseSchema.fluidLeaksInspected: checkup.fluidLeaksInspected,
        DatabaseSchema.radiatorHosesInspected: checkup.radiatorHosesInspected,
        DatabaseSchema.driveShaftsBootsInspected: checkup.driveShaftsBootsInspected,
        DatabaseSchema.fuelFilterInspected: checkup.fuelFilterInspected,
        DatabaseSchema.suspensionInspected: checkup.suspensionInspected,
        DatabaseSchema.shockAbsorberInspected: checkup.shockAbsorberInspected,
        DatabaseSchema.suspensionRetightened: checkup.suspensionRetightened,
        DatabaseSchema.engineSupportInspected: checkup.engineSupportInspected,
        DatabaseSchema.driveBeltPulleysInspected: checkup.driveBeltPulleysInspected,
        DatabaseSchema.brakeLinesInspected: checkup.brakeLinesInspected,
        DatabaseSchema.brakePadsInspected: checkup.brakePadsInspected,
        DatabaseSchema.parkBrakeInspected: checkup.parkBrakeInspected,
        DatabaseSchema.tiresInspected: checkup.tiresInspected,
        DatabaseSchema.exhaustSystemInspected: checkup.exhaustSystemInspected,
        DatabaseSchema.tiresRotated: checkup.tiresRotated,
        DatabaseSchema.lightsInspected: checkup.lightsInspected,
        DatabaseSchema.batteryInspected: checkup.batteryInspected,
        DatabaseSchema.acOperationInspected: checkup.acOperationInspected,
        DatabaseSchema.wipersInspected: checkup.wipersInspected,
        DatabaseSchema.diagnosticToolsUsed: checkup.diagnosticToolsUsed,
        DatabaseSchema.oilServiceReset: checkup.oilServiceReset,
        DatabaseSchema.updatedAt: DateTime.now().toIso8601String(),
      };

      if (checkup.completedAt != null) {
        updateData[DatabaseSchema.completedAtCheckup] = checkup.completedAt!.toIso8601String();
      }

      final response = await _client
          .from(DatabaseSchema.monthlyCheckups)
          .update(updateData)
          .eq(DatabaseSchema.id, checkup.id)
          .select()
          .single();

      return MonthlyCheckupModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update monthly checkup: $e');
    }
  }
}

