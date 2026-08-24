import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/oil_change_progress_model.dart';
import '../repositories/oil_change_progress_repository.dart';

/// Provider for oil change progress repository
final oilChangeProgressRepositoryProvider = Provider<OilChangeProgressRepository>((ref) {
  return OilChangeProgressRepository();
});

/// Provider for a single car's oil change progress
final oilChangeProgressProvider = FutureProvider.family<OilChangeProgressModel?, String>((ref, carId) async {
  final repository = ref.read(oilChangeProgressRepositoryProvider);
  return await repository.getByCarId(carId);
});

/// Provider for batch oil change progress (for vehicle list)
final batchOilChangeProgressProvider = FutureProvider.family<Map<String, OilChangeProgressModel>, List<String>>((ref, carIds) async {
  final repository = ref.read(oilChangeProgressRepositoryProvider);
  return await repository.getBatchByCarIds(carIds);
});
