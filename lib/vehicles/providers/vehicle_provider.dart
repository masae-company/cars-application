import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vehicle_model.dart';
import '../repositories/vehicle_repository.dart';

// Note: CarLocation enum is imported via VehicleModel

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  return VehicleRepository();
});

final vehicleListProvider = FutureProvider.family<List<VehicleModel>, VehicleListParams>(
  (ref, params) async {
    print('📦 [VehicleProvider] vehicleListProvider called');
    print('   - locationFilter: ${params.locationFilter}');
    print('   - isNewFilter: ${params.isNewFilter}');
    print('   - searchQuery: ${params.searchQuery}');
    print('   - limit: ${params.limit}');
    print('   - offset: ${params.offset}');
    
    try {
      print('📦 [VehicleProvider] Getting repository...');
      final repository = ref.watch(vehicleRepositoryProvider);
      print('📦 [VehicleProvider] Repository obtained, calling getAllVehicles...');
      
      final result = await repository.getAllVehicles(
        locationFilter: params.locationFilter,
        isNewFilter: params.isNewFilter,
        statusFilter: params.statusFilter,
        isAccidentFilter: params.isAccidentFilter,
        modelFilter: params.modelFilter,
        searchQuery: params.searchQuery,
        limit: params.limit,
        offset: params.offset,
      );
      
      print('📦 [VehicleProvider] getAllVehicles completed successfully');
      print('📦 [VehicleProvider] Result count: ${result.length}');
      return result;
    } catch (e, stack) {
      print('📦 [VehicleProvider] ERROR in vehicleListProvider: $e');
      print('📦 [VehicleProvider] Stack trace: $stack');
      rethrow;
    }
  },
);

final vehicleCountProvider = FutureProvider<int>((ref) async {
  try {
    final repository = ref.watch(vehicleRepositoryProvider);
    return await repository.getVehicleCount();
  } catch (e) {
    rethrow;
  }
});

class VehicleListParams {
  final CarLocation? locationFilter;
  final bool? isNewFilter;
  final VehicleStatus? statusFilter;
  final bool? isAccidentFilter;
  final String? modelFilter;
  final String? searchQuery;
  final int? limit;
  final int? offset;

  VehicleListParams({
    this.locationFilter,
    this.isNewFilter,
    this.statusFilter,
    this.isAccidentFilter,
    this.modelFilter,
    this.searchQuery,
    this.limit,
    this.offset,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VehicleListParams &&
        other.locationFilter == locationFilter &&
        other.isNewFilter == isNewFilter &&
        other.statusFilter == statusFilter &&
        other.isAccidentFilter == isAccidentFilter &&
        other.modelFilter == modelFilter &&
        other.searchQuery == searchQuery &&
        other.limit == limit &&
        other.offset == offset;
  }

  @override
  int get hashCode {
    return Object.hash(
      locationFilter,
      isNewFilter,
      statusFilter,
      isAccidentFilter,
      modelFilter,
      searchQuery,
      limit,
      offset,
    );
  }

  @override
  String toString() {
    return 'VehicleListParams(locationFilter: $locationFilter, isNewFilter: $isNewFilter, statusFilter: $statusFilter, isAccidentFilter: $isAccidentFilter, modelFilter: $modelFilter, searchQuery: $searchQuery, limit: $limit, offset: $offset)';
  }
}

final vehicleProvider = FutureProvider.family<VehicleModel?, String>(
  (ref, id) async {
    if (id.isEmpty) return null;
    final repository = ref.watch(vehicleRepositoryProvider);
    return repository.getVehicleById(id);
  },
);

final createVehicleProvider = FutureProvider.family<VehicleModel, VehicleModel>(
  (ref, vehicle) async {
    final repository = ref.watch(vehicleRepositoryProvider);
    return repository.createVehicle(vehicle);
  },
);

final updateVehicleProvider = FutureProvider.family<VehicleModel, VehicleModel>(
  (ref, vehicle) async {
    final repository = ref.watch(vehicleRepositoryProvider);
    return repository.updateVehicle(vehicle);
  },
);

final deleteVehicleProvider = FutureProvider.family<void, String>(
  (ref, id) async {
    final repository = ref.watch(vehicleRepositoryProvider);
    await repository.deleteVehicle(id);
  },
);

