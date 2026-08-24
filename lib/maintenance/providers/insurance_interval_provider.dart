import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/insurance_interval_model.dart';
import '../repositories/insurance_interval_repository.dart';

/// Provider for InsuranceIntervalRepository
final insuranceIntervalRepositoryProvider =
    Provider<InsuranceIntervalRepository>((ref) {
  return InsuranceIntervalRepository();
});

/// Provider to get insurance interval by car ID
final insuranceIntervalByCarIdProvider =
    FutureProvider.family<InsuranceIntervalModel?, String>((ref, carId) async {
  final repository = ref.watch(insuranceIntervalRepositoryProvider);
  return repository.getInsuranceIntervalByCarId(carId);
});

/// Provider to get all insurance intervals
final allInsuranceIntervalsProvider =
    FutureProvider<List<InsuranceIntervalModel>>((ref) async {
  final repository = ref.watch(insuranceIntervalRepositoryProvider);
  return repository.getAllInsuranceIntervals();
});

/// Provider to create insurance interval
final createInsuranceIntervalProvider =
    FutureProvider.family<InsuranceIntervalModel, InsuranceIntervalModel>(
  (ref, interval) async {
    final repository = ref.watch(insuranceIntervalRepositoryProvider);
    return repository.createInsuranceInterval(interval);
  },
);

/// Provider to update insurance interval
final updateInsuranceIntervalProvider =
    FutureProvider.family<InsuranceIntervalModel, InsuranceIntervalModel>(
  (ref, interval) async {
    final repository = ref.watch(insuranceIntervalRepositoryProvider);
    return repository.updateInsuranceInterval(interval);
  },
);

/// Provider to delete insurance interval
final deleteInsuranceIntervalProvider =
    FutureProvider.family<void, String>((ref, id) async {
  final repository = ref.watch(insuranceIntervalRepositoryProvider);
  return repository.deleteInsuranceInterval(id);
});

