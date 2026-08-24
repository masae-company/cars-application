import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/allocation_model.dart';
import '../models/allocation_status.dart';
import '../repositories/allocation_repository.dart';

final allocationRepositoryProvider = Provider<AllocationRepository>((ref) {
  return AllocationRepository();
});

final allocationListProvider =
    FutureProvider.family<List<AllocationModel>, AllocationListParams>(
  (ref, params) async {
    print('📦 [AllocationProvider] allocationListProvider called');
    print('   - params: $params');
    
    try {
      print('📦 [AllocationProvider] Getting repository...');
      final repository = ref.watch(allocationRepositoryProvider);
      print('📦 [AllocationProvider] Repository obtained, calling getAllocations...');
      
      final result = await repository.getAllocations(
        statusFilter: params.statusFilter,
        vehicleId: params.vehicleId,
        userId: params.userId,
        limit: params.limit,
        offset: params.offset,
      );
      
      print('📦 [AllocationProvider] getAllocations completed successfully');
      print('📦 [AllocationProvider] Result count: ${result.length}');
      return result;
    } catch (e, stack) {
      print('📦 [AllocationProvider] ERROR in allocationListProvider: $e');
      print('📦 [AllocationProvider] Stack trace: $stack');
      rethrow;
    }
  },
);

class AllocationListParams {
  final AllocationStatus? statusFilter;
  final String? vehicleId;
  final String? userId;
  final int? limit;
  final int? offset;

  AllocationListParams({
    this.statusFilter,
    this.vehicleId,
    this.userId,
    this.limit,
    this.offset,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AllocationListParams &&
        other.statusFilter == statusFilter &&
        other.vehicleId == vehicleId &&
        other.userId == userId &&
        other.limit == limit &&
        other.offset == offset;
  }

  @override
  int get hashCode {
    return Object.hash(
      statusFilter,
      vehicleId,
      userId,
      limit,
      offset,
    );
  }

  @override
  String toString() {
    return 'AllocationListParams(statusFilter: $statusFilter, vehicleId: $vehicleId, userId: $userId, limit: $limit, offset: $offset)';
  }
}

final allocationProvider = FutureProvider.family<AllocationModel?, String>(
  (ref, id) async {
    if (id.isEmpty) return null;
    final repository = ref.watch(allocationRepositoryProvider);
    return repository.getAllocationById(id);
  },
);

final createAllocationProvider =
    FutureProvider.family<AllocationModel, AllocationModel>(
  (ref, allocation) async {
    final repository = ref.watch(allocationRepositoryProvider);
    return repository.createAllocation(allocation);
  },
);

final updateAllocationProvider =
    FutureProvider.family<AllocationModel, AllocationModel>(
  (ref, allocation) async {
    final repository = ref.watch(allocationRepositoryProvider);
    return repository.updateAllocation(allocation);
  },
);

final deleteAllocationProvider = FutureProvider.family<void, String>(
  (ref, id) async {
    final repository = ref.watch(allocationRepositoryProvider);
    await repository.deleteAllocation(id);
  },
);

