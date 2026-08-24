import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/monthly_checkup_model.dart';
import '../repositories/monthly_checkup_repository.dart';

final monthlyCheckupRepositoryProvider = Provider<MonthlyCheckupRepository>((ref) {
  return MonthlyCheckupRepository();
});

final monthlyCheckupListProvider =
    FutureProvider.family<List<MonthlyCheckupModel>, MonthlyCheckupListParams>(
  (ref, params) async {
    try {
      final repository = ref.watch(monthlyCheckupRepositoryProvider);
      return await repository.getAllMonthlyCheckups(
        carId: params.carId,
        performedBy: params.performedBy,
        startDate: params.startDate,
        endDate: params.endDate,
        completedOnly: params.completedOnly,
        limit: params.limit,
        offset: params.offset,
      );
    } catch (e) {
      rethrow;
    }
  },
);

final monthlyCheckupProvider =
    FutureProvider.family<MonthlyCheckupModel?, String>(
  (ref, id) async {
    try {
      final repository = ref.watch(monthlyCheckupRepositoryProvider);
      return await repository.getMonthlyCheckupById(id);
    } catch (e) {
      rethrow;
    }
  },
);

final monthlyCheckupByCarProvider =
    FutureProvider.family<List<MonthlyCheckupModel>, MonthlyCheckupByCarParams>(
  (ref, params) async {
    try {
      final repository = ref.watch(monthlyCheckupRepositoryProvider);
      return await repository.getMonthlyCheckupsByCarId(
        params.carId,
        completedOnly: params.completedOnly,
        limit: params.limit,
        offset: params.offset,
      );
    } catch (e) {
      rethrow;
    }
  },
);

final pendingMonthlyCheckupListProvider =
    FutureProvider.family<List<MonthlyCheckupModel>, PendingMonthlyCheckupParams>(
  (ref, params) async {
    try {
      final repository = ref.watch(monthlyCheckupRepositoryProvider);
      return await repository.getPendingMonthlyCheckups(
        carId: params.carId,
        limit: params.limit,
        offset: params.offset,
      );
    } catch (e) {
      rethrow;
    }
  },
);

class MonthlyCheckupListParams {
  final String? carId;
  final String? performedBy;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? completedOnly;
  final int? limit;
  final int? offset;

  MonthlyCheckupListParams({
    this.carId,
    this.performedBy,
    this.startDate,
    this.endDate,
    this.completedOnly,
    this.limit,
    this.offset,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MonthlyCheckupListParams &&
        other.carId == carId &&
        other.performedBy == performedBy &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.completedOnly == completedOnly &&
        other.limit == limit &&
        other.offset == offset;
  }

  @override
  int get hashCode => Object.hash(
        carId,
        performedBy,
        startDate,
        endDate,
        completedOnly,
        limit,
        offset,
      );
}

class MonthlyCheckupByCarParams {
  final String carId;
  final bool? completedOnly;
  final int? limit;
  final int? offset;

  MonthlyCheckupByCarParams({
    required this.carId,
    this.completedOnly,
    this.limit,
    this.offset,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MonthlyCheckupByCarParams &&
        other.carId == carId &&
        other.completedOnly == completedOnly &&
        other.limit == limit &&
        other.offset == offset;
  }

  @override
  int get hashCode => Object.hash(carId, completedOnly, limit, offset);
}

class PendingMonthlyCheckupParams {
  final String? carId;
  final int? limit;
  final int? offset;

  PendingMonthlyCheckupParams({
    this.carId,
    this.limit,
    this.offset,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PendingMonthlyCheckupParams &&
        other.carId == carId &&
        other.limit == limit &&
        other.offset == offset;
  }

  @override
  int get hashCode => Object.hash(carId, limit, offset);
}

final createMonthlyCheckupProvider =
    FutureProvider.family<MonthlyCheckupModel, MonthlyCheckupModel>(
  (ref, checkup) async {
    try {
      final repository = ref.watch(monthlyCheckupRepositoryProvider);
      return await repository.createMonthlyCheckup(checkup);
    } catch (e) {
      rethrow;
    }
  },
);

final updateMonthlyCheckupProvider =
    FutureProvider.family<MonthlyCheckupModel, MonthlyCheckupModel>(
  (ref, checkup) async {
    try {
      final repository = ref.watch(monthlyCheckupRepositoryProvider);
      return await repository.updateMonthlyCheckup(checkup);
    } catch (e) {
      rethrow;
    }
  },
);

