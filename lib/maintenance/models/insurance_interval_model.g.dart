// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insurance_interval_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InsuranceIntervalModelImpl _$$InsuranceIntervalModelImplFromJson(
        Map<String, dynamic> json) =>
    _$InsuranceIntervalModelImpl(
      id: json['id'] as String,
      carId: json['car_id'] as String,
      intervalKilometers: (json['interval_kilometers'] as num).toInt(),
      intervalYears: (json['interval_years'] as num).toInt(),
      startDate: DateTime.parse(json['start_date'] as String),
      initialKilometers: (json['initial_kilometers'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$InsuranceIntervalModelImplToJson(
        _$InsuranceIntervalModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'car_id': instance.carId,
      'interval_kilometers': instance.intervalKilometers,
      'interval_years': instance.intervalYears,
      'start_date': instance.startDate.toIso8601String(),
      'initial_kilometers': instance.initialKilometers,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
