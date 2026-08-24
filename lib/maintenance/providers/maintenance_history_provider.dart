import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/maintenance_history_model.dart';
import '../repositories/maintenance_history_repository.dart';

final maintenanceHistoryRepositoryProvider = Provider<MaintenanceHistoryRepository>((ref) {
  return MaintenanceHistoryRepository();
});

final maintenanceHistoryListProvider =
    FutureProvider.family<List<MaintenanceHistoryModel>, MaintenanceHistoryListParams>(
  (ref, params) async {
    try {
      final repository = ref.watch(maintenanceHistoryRepositoryProvider);
      return await repository.getAllMaintenanceHistory(
        carId: params.carId,
        maintenanceTypeFilter: params.maintenanceTypeFilter,
        serviceCenterTypeFilter: params.serviceCenterTypeFilter,
        startDate: params.startDate,
        endDate: params.endDate,
        limit: params.limit,
        offset: params.offset,
      );
    } catch (e) {
      rethrow;
    }
  },
);

final maintenanceHistoryProvider =
    FutureProvider.family<MaintenanceHistoryModel?, String>(
  (ref, id) async {
    try {
      final repository = ref.watch(maintenanceHistoryRepositoryProvider);
      return await repository.getMaintenanceHistoryById(id);
    } catch (e) {
      rethrow;
    }
  },
);

final maintenanceHistoryByCarProvider =
    FutureProvider.family<List<MaintenanceHistoryModel>, MaintenanceHistoryByCarParams>(
  (ref, params) async {
    try {
      final repository = ref.watch(maintenanceHistoryRepositoryProvider);
      return await repository.getMaintenanceHistoryByCarId(
        params.carId,
        maintenanceTypeFilter: params.maintenanceTypeFilter,
        limit: params.limit,
        offset: params.offset,
      );
    } catch (e) {
      rethrow;
    }
  },
);

class MaintenanceHistoryListParams {
  final String? carId;
  final MaintenanceType? maintenanceTypeFilter;
  final ServiceCenterType? serviceCenterTypeFilter;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? limit;
  final int? offset;

  MaintenanceHistoryListParams({
    this.carId,
    this.maintenanceTypeFilter,
    this.serviceCenterTypeFilter,
    this.startDate,
    this.endDate,
    this.limit,
    this.offset,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MaintenanceHistoryListParams &&
        other.carId == carId &&
        other.maintenanceTypeFilter == maintenanceTypeFilter &&
        other.serviceCenterTypeFilter == serviceCenterTypeFilter &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.limit == limit &&
        other.offset == offset;
  }

  @override
  int get hashCode => Object.hash(
        carId,
        maintenanceTypeFilter,
        serviceCenterTypeFilter,
        startDate,
        endDate,
        limit,
        offset,
      );
}

class MaintenanceHistoryByCarParams {
  final String carId;
  final MaintenanceType? maintenanceTypeFilter;
  final int? limit;
  final int? offset;

  MaintenanceHistoryByCarParams({
    required this.carId,
    this.maintenanceTypeFilter,
    this.limit,
    this.offset,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MaintenanceHistoryByCarParams &&
        other.carId == carId &&
        other.maintenanceTypeFilter == maintenanceTypeFilter &&
        other.limit == limit &&
        other.offset == offset;
  }

  @override
  int get hashCode => Object.hash(carId, maintenanceTypeFilter, limit, offset);
}


