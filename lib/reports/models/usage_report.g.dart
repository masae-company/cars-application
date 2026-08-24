// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usage_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UsageReportImpl _$$UsageReportImplFromJson(Map<String, dynamic> json) =>
    _$UsageReportImpl(
      vehicleId: json['vehicleId'] as String,
      vehicleRegistration: json['vehicleRegistration'] as String,
      totalAllocations: (json['totalAllocations'] as num).toInt(),
      totalDays: (json['totalDays'] as num).toInt(),
      totalMileage: (json['totalMileage'] as num).toInt(),
      periodStart: DateTime.parse(json['periodStart'] as String),
      periodEnd: DateTime.parse(json['periodEnd'] as String),
    );

Map<String, dynamic> _$$UsageReportImplToJson(_$UsageReportImpl instance) =>
    <String, dynamic>{
      'vehicleId': instance.vehicleId,
      'vehicleRegistration': instance.vehicleRegistration,
      'totalAllocations': instance.totalAllocations,
      'totalDays': instance.totalDays,
      'totalMileage': instance.totalMileage,
      'periodStart': instance.periodStart.toIso8601String(),
      'periodEnd': instance.periodEnd.toIso8601String(),
    };
