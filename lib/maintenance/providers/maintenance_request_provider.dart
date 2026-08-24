import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/maintenance_request_model.dart';
import '../repositories/maintenance_request_repository.dart';

final maintenanceRequestRepositoryProvider = Provider<MaintenanceRequestRepository>((ref) {
  return MaintenanceRequestRepository();
});

final maintenanceRequestListProvider =
    FutureProvider.family<List<MaintenanceRequestModel>, MaintenanceRequestListParams>(
  (ref, params) async {
    try {
      final repository = ref.watch(maintenanceRequestRepositoryProvider);
      return await repository.getAllMaintenanceRequests(
        carId: params.carId,
        statusFilter: params.statusFilter,
        limit: params.limit,
        offset: params.offset,
      );
    } catch (e) {
      rethrow;
    }
  },
);

final maintenanceRequestProvider =
    FutureProvider.family<MaintenanceRequestModel?, String>(
  (ref, id) async {
    try {
      final repository = ref.watch(maintenanceRequestRepositoryProvider);
      return await repository.getMaintenanceRequestById(id);
    } catch (e) {
      rethrow;
    }
  },
);

final createMaintenanceRequestProvider =
    FutureProvider.family<MaintenanceRequestModel, MaintenanceRequestModel>(
  (ref, request) async {
    try {
      final repository = ref.watch(maintenanceRequestRepositoryProvider);
      return await repository.createMaintenanceRequest(request);
    } catch (e) {
      rethrow;
    }
  },
);

final updateMaintenanceRequestProvider =
    FutureProvider.family<MaintenanceRequestModel, MaintenanceRequestModel>(
  (ref, request) async {
    try {
      final repository = ref.watch(maintenanceRequestRepositoryProvider);
      return await repository.updateMaintenanceRequest(request);
    } catch (e) {
      rethrow;
    }
  },
);

class MaintenanceRequestListParams {
  final String? carId;
  final MaintenanceRequestStatus? statusFilter;
  final int? limit;
  final int? offset;

  MaintenanceRequestListParams({
    this.carId,
    this.statusFilter,
    this.limit,
    this.offset,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MaintenanceRequestListParams &&
        other.carId == carId &&
        other.statusFilter == statusFilter &&
        other.limit == limit &&
        other.offset == offset;
  }

  @override
  int get hashCode => Object.hash(carId, statusFilter, limit, offset);
}

