import 'package:freezed_annotation/freezed_annotation.dart';
import 'allocation_status.dart';

part 'allocation_model.freezed.dart';
part 'allocation_model.g.dart';

@freezed
class AllocationHistory with _$AllocationHistory {
  const factory AllocationHistory({
    required String id,
    required String allocationId,
    required AllocationStatus status,
    String? changedBy,
    String? notes,
    required DateTime createdAt,
  }) = _AllocationHistory;

  factory AllocationHistory.fromJson(Map<String, dynamic> json) =>
      _$AllocationHistoryFromJson(json);
}

@freezed
class AllocationModel with _$AllocationModel {
  const factory AllocationModel({
    required String id,
    required String vehicleId,
    required String allocatedTo,
    required String requestedBy,
    String? approvedBy,
    @Default(AllocationStatus.pending) AllocationStatus status,
    required DateTime requestDate,
    DateTime? approvalDate,
    DateTime? handoverDate,
    DateTime? returnDate,
    DateTime? expectedReturnDate,
    int? handoverMileage,
    int? returnMileage,
    String? handoverNotes,
    String? returnNotes,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default([]) List<AllocationHistory> history,
  }) = _AllocationModel;

  factory AllocationModel.fromJson(Map<String, dynamic> json) =>
      _$AllocationModelFromJson(json);
}


