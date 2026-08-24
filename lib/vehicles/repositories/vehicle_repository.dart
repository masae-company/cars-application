import '../models/vehicle_model.dart';
import '../../core/config/supabase_config.dart';
import '../../core/config/database_schema.dart';

class VehicleRepository {
  final _client = SupabaseConfig.client;
  
  VehicleRepository() {
    print('🚗 [VehicleRepository] Constructor called');
    print('   - Supabase client initialized: true');
  }

  /// Fetch all vehicles with optional filters
  Future<List<VehicleModel>> getAllVehicles({
    CarLocation? locationFilter,
    bool? isNewFilter,
    VehicleStatus? statusFilter,
    bool? isAccidentFilter,
    String? modelFilter,
    String? searchQuery,
    int? limit,
    int? offset,
  }) async {
    print('🚗 [VehicleRepository] getAllVehicles called');
    print('   - locationFilter: $locationFilter');
    print('   - isNewFilter: $isNewFilter');
    print('   - statusFilter: $statusFilter');
    print('   - isAccidentFilter: $isAccidentFilter');
    print('   - modelFilter: $modelFilter');
    print('   - searchQuery: $searchQuery');
    print('   - limit: $limit');
    print('   - offset: $offset');
    print('   - Table name: ${DatabaseSchema.cars}');
    
    try {
      print('🚗 [VehicleRepository] Creating base query...');
      // Start with base query - select all columns from cars table
      dynamic query = _client.from(DatabaseSchema.cars).select();
      print('🚗 [VehicleRepository] Base query created');

      // Apply location filter if provided
      if (locationFilter != null) {
        print('🚗 [VehicleRepository] Applying location filter: ${locationFilter.toDbValue()}');
        query = query.eq(DatabaseSchema.location, locationFilter.toDbValue());
      }

      if (isNewFilter != null) {
        print('🚗 [VehicleRepository] Applying is_new filter: $isNewFilter');
        query = query.eq(DatabaseSchema.isNew, isNewFilter);
      }

      // Apply status filter if provided
      if (statusFilter != null) {
        print('🚗 [VehicleRepository] Applying status filter: ${statusFilter.toDbValue()}');
        query = query.eq(DatabaseSchema.status, statusFilter.toDbValue());
      }

      // Apply is_accident filter if provided
      if (isAccidentFilter != null) {
        print('🚗 [VehicleRepository] Applying is_accident filter: $isAccidentFilter');
        query = query.eq(DatabaseSchema.isAccident, isAccidentFilter);
      }

      // Apply model filter if provided (case-insensitive)
      if (modelFilter != null && modelFilter.isNotEmpty) {
        print('🚗 [VehicleRepository] Applying model filter: $modelFilter');
        // Use ilike for case-insensitive matching
        query = query.ilike(DatabaseSchema.model, modelFilter);
      }

      // Apply search query if provided (only if model filter is not set)
      if (searchQuery != null && searchQuery.isNotEmpty && (modelFilter == null || modelFilter.isEmpty)) {
        print('🚗 [VehicleRepository] Applying search query: $searchQuery');
        query = query.or(
          '${DatabaseSchema.number}.ilike.%$searchQuery%,'
          '${DatabaseSchema.model}.ilike.%$searchQuery%',
        );
      }

      // Apply ordering by created_at descending (newest first)
      print('🚗 [VehicleRepository] Applying order by created_at');
      query = query.order(DatabaseSchema.createdAt, ascending: false);

      // Apply pagination if provided
      if (limit != null && offset != null) {
        print('🚗 [VehicleRepository] Applying range: $offset to ${offset + limit - 1}');
        query = query.range(offset, offset + limit - 1);
      } else if (limit != null) {
        print('🚗 [VehicleRepository] Applying limit: $limit');
        query = query.limit(limit);
      }

      print('🚗 [VehicleRepository] Executing query...');
      final response = await query;
      print('🚗 [VehicleRepository] Query executed successfully');
      print('🚗 [VehicleRepository] Response type: ${response.runtimeType}');
      print('🚗 [VehicleRepository] Response is List: ${response is List}');
      
      if (response is List) {
        print('🚗 [VehicleRepository] Response length: ${response.length}');
        if (response.isNotEmpty) {
          print('🚗 [VehicleRepository] First item: ${response.first}');
        }
      }
      
      // Convert response to VehicleModel list
      print('🚗 [VehicleRepository] Converting response to VehicleModel list...');
      final vehicles = (response as List)
          .map((json) {
            try {
              print('🚗 [VehicleRepository] Parsing vehicle: ${json.toString().substring(0, json.toString().length > 100 ? 100 : json.toString().length)}...');
              return VehicleModel.fromJson(json as Map<String, dynamic>);
            } catch (e, stack) {
              print('🚗 [VehicleRepository] ERROR parsing vehicle: $e');
              print('🚗 [VehicleRepository] Stack trace: $stack');
              print('🚗 [VehicleRepository] JSON data: $json');
              rethrow;
            }
          })
          .toList();
      
      print('🚗 [VehicleRepository] Successfully parsed ${vehicles.length} vehicles');
      return vehicles;
    } catch (e, stack) {
      print('🚗 [VehicleRepository] ERROR in getAllVehicles: $e');
      print('🚗 [VehicleRepository] Stack trace: $stack');
      print('🚗 [VehicleRepository] Error type: ${e.runtimeType}');
      throw Exception('Failed to fetch vehicles: $e');
    }
  }

  /// Get total count of vehicles
  Future<int> getVehicleCount({
    CarLocation? locationFilter,
    bool? isNewFilter,
  }) async {
    try {
      // Fetch only IDs to get count efficiently
      dynamic query = _client.from(DatabaseSchema.cars).select('id');

      if (locationFilter != null) {
        query = query.eq(DatabaseSchema.location, locationFilter.toDbValue());
      }

      if (isNewFilter != null) {
        query = query.eq(DatabaseSchema.isNew, isNewFilter);
      }

      final response = await query;
      return (response as List).length;
    } catch (e) {
      throw Exception('Failed to get vehicle count: $e');
    }
  }

  /// Fetch a single vehicle by ID
  Future<VehicleModel?> getVehicleById(String id) async {
    try {
      final response = await _client
          .from(DatabaseSchema.cars)
          .select()
          .eq(DatabaseSchema.id, id)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return VehicleModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch vehicle: $e');
    }
  }

  /// Fetch vehicles one by one (for testing/debugging)
  /// Returns a stream of vehicles fetched individually
  Stream<VehicleModel> fetchVehiclesOneByOne({
    CarLocation? locationFilter,
    bool? isNewFilter,
    int? limit,
  }) async* {
    try {
      // First, get the list of IDs
      dynamic idQuery = _client.from(DatabaseSchema.cars).select('id');

      if (locationFilter != null) {
        idQuery = idQuery.eq(DatabaseSchema.location, locationFilter.toDbValue());
      }

      if (isNewFilter != null) {
        idQuery = idQuery.eq(DatabaseSchema.isNew, isNewFilter);
      }

      idQuery = idQuery.order(DatabaseSchema.createdAt, ascending: false);

      if (limit != null) {
        idQuery = idQuery.limit(limit);
      }

      final idResponse = await idQuery;
      
      final ids = (idResponse as List)
          .map((item) => (item as Map<String, dynamic>)['id'] as String)
          .toList();

      // Fetch each vehicle one by one
      for (final id in ids) {
        final vehicle = await getVehicleById(id);
        if (vehicle != null) {
          yield vehicle;
        }
      }
    } catch (e) {
      throw Exception('Failed to fetch vehicles one by one: $e');
    }
  }


  /// Create a new vehicle
  Future<VehicleModel> createVehicle(VehicleModel vehicle) async {
    try {
      final data = vehicle.toJson();
      // Remove fields that are auto-generated or should not be sent
      data.remove('id');
      data.remove(DatabaseSchema.createdAt);
      data.remove(DatabaseSchema.updatedAt);
      
      // Ensure location is converted to string format
      if (vehicle.location != null) {
        data['location'] = vehicle.location!.toDbValue();
      } else {
        data.remove('location');
      }

      final response = await _client
          .from(DatabaseSchema.cars)
          .insert(data)
          .select()
          .single();

      return VehicleModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create vehicle: $e');
    }
  }

  /// Update an existing vehicle
  Future<VehicleModel> updateVehicle(VehicleModel vehicle) async {
    try {
      final data = vehicle.toJson();
      // Remove fields that should not be updated
      data.remove('id');
      data.remove(DatabaseSchema.createdAt);
      // updated_at is handled by database trigger, but we can set it explicitly
      data[DatabaseSchema.updatedAt] = DateTime.now().toIso8601String();
      
      // Ensure location is converted to string format
      if (vehicle.location != null) {
        data['location'] = vehicle.location!.toDbValue();
      } else {
        data.remove('location');
      }

      final response = await _client
          .from(DatabaseSchema.cars)
          .update(data)
          .eq(DatabaseSchema.id, vehicle.id)
          .select()
          .single();

      return VehicleModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update vehicle: $e');
    }
  }

  /// Delete a vehicle by ID
  Future<void> deleteVehicle(String id) async {
    try {
      await _client
          .from(DatabaseSchema.cars)
          .delete()
          .eq(DatabaseSchema.id, id);
    } catch (e) {
      throw Exception('Failed to delete vehicle: $e');
    }
  }

  /// Batch create multiple vehicles (much faster than individual creates)
  Future<List<VehicleModel>> batchCreateVehicles(List<VehicleModel> vehicles) async {
    if (vehicles.isEmpty) return [];
    
    try {
      final dataList = vehicles.map((vehicle) {
        final data = vehicle.toJson();
        data.remove('id');
        data.remove(DatabaseSchema.createdAt);
        data.remove(DatabaseSchema.updatedAt);
        
        if (vehicle.location != null) {
          data['location'] = vehicle.location!.toDbValue();
        } else {
          data.remove('location');
        }
        
        return data;
      }).toList();

      final response = await _client
          .from(DatabaseSchema.cars)
          .insert(dataList)
          .select();

      return (response as List)
          .map((json) => VehicleModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to batch create vehicles: $e');
    }
  }

  /// Batch update multiple vehicles (much faster than individual updates)
  Future<List<VehicleModel>> batchUpdateVehicles(List<VehicleModel> vehicles) async {
    if (vehicles.isEmpty) return [];
    
    try {
      // Supabase doesn't support true batch updates, so we do them in parallel
      // This is still much faster than sequential updates
      final futures = vehicles.map((vehicle) async {
        final data = vehicle.toJson();
        data.remove('id');
        data.remove(DatabaseSchema.createdAt);
        data[DatabaseSchema.updatedAt] = DateTime.now().toIso8601String();
        
        if (vehicle.location != null) {
          data['location'] = vehicle.location!.toDbValue();
        } else {
          data.remove('location');
        }

        final response = await _client
            .from(DatabaseSchema.cars)
            .update(data)
            .eq(DatabaseSchema.id, vehicle.id)
            .select()
            .single();

        return VehicleModel.fromJson(response);
      }).toList();

      return await Future.wait(futures);
    } catch (e) {
      throw Exception('Failed to batch update vehicles: $e');
    }
  }
}

