// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oil_change_progress_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OilChangeProgressModelImpl _$$OilChangeProgressModelImplFromJson(
        Map<String, dynamic> json) =>
    _$OilChangeProgressModelImpl(
      id: json['id'] as String,
      carId: json['car_id'] as String,
      currentKilometers: (json['current_kilometers'] as num?)?.toInt() ?? 0,
      lastOilChangeKilometers:
          (json['last_oil_change_kilometers'] as num?)?.toInt() ?? 0,
      nextOilChangeKilometers:
          (json['next_oil_change_kilometers'] as num?)?.toInt() ?? 5000,
      lastUpdated: DateTime.parse(json['last_updated'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$OilChangeProgressModelImplToJson(
        _$OilChangeProgressModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'car_id': instance.carId,
      'current_kilometers': instance.currentKilometers,
      'last_oil_change_kilometers': instance.lastOilChangeKilometers,
      'next_oil_change_kilometers': instance.nextOilChangeKilometers,
      'last_updated': instance.lastUpdated.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
