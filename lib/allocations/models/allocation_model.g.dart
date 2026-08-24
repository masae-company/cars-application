// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allocation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AllocationHistoryImpl _$$AllocationHistoryImplFromJson(
        Map<String, dynamic> json) =>
    _$AllocationHistoryImpl(
      id: json['id'] as String,
      allocationId: json['allocationId'] as String,
      status: $enumDecode(_$AllocationStatusEnumMap, json['status']),
      changedBy: json['changedBy'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$AllocationHistoryImplToJson(
        _$AllocationHistoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'allocationId': instance.allocationId,
      'status': _$AllocationStatusEnumMap[instance.status]!,
      'changedBy': instance.changedBy,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$AllocationStatusEnumMap = {
  AllocationStatus.pending: 'pending',
  AllocationStatus.approved: 'approved',
  AllocationStatus.handedOver: 'handedOver',
  AllocationStatus.returned: 'returned',
  AllocationStatus.cancelled: 'cancelled',
};

_$AllocationModelImpl _$$AllocationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AllocationModelImpl(
      id: json['id'] as String,
      vehicleId: json['vehicleId'] as String,
      allocatedTo: json['allocatedTo'] as String,
      requestedBy: json['requestedBy'] as String,
      approvedBy: json['approvedBy'] as String?,
      status: $enumDecodeNullable(_$AllocationStatusEnumMap, json['status']) ??
          AllocationStatus.pending,
      requestDate: DateTime.parse(json['requestDate'] as String),
      approvalDate: json['approvalDate'] == null
          ? null
          : DateTime.parse(json['approvalDate'] as String),
      handoverDate: json['handoverDate'] == null
          ? null
          : DateTime.parse(json['handoverDate'] as String),
      returnDate: json['returnDate'] == null
          ? null
          : DateTime.parse(json['returnDate'] as String),
      expectedReturnDate: json['expectedReturnDate'] == null
          ? null
          : DateTime.parse(json['expectedReturnDate'] as String),
      handoverMileage: (json['handoverMileage'] as num?)?.toInt(),
      returnMileage: (json['returnMileage'] as num?)?.toInt(),
      handoverNotes: json['handoverNotes'] as String?,
      returnNotes: json['returnNotes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      history: (json['history'] as List<dynamic>?)
              ?.map(
                  (e) => AllocationHistory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$AllocationModelImplToJson(
        _$AllocationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicleId': instance.vehicleId,
      'allocatedTo': instance.allocatedTo,
      'requestedBy': instance.requestedBy,
      'approvedBy': instance.approvedBy,
      'status': _$AllocationStatusEnumMap[instance.status]!,
      'requestDate': instance.requestDate.toIso8601String(),
      'approvalDate': instance.approvalDate?.toIso8601String(),
      'handoverDate': instance.handoverDate?.toIso8601String(),
      'returnDate': instance.returnDate?.toIso8601String(),
      'expectedReturnDate': instance.expectedReturnDate?.toIso8601String(),
      'handoverMileage': instance.handoverMileage,
      'returnMileage': instance.returnMileage,
      'handoverNotes': instance.handoverNotes,
      'returnNotes': instance.returnNotes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'history': instance.history,
    };
