// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cost_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CostReportImpl _$$CostReportImplFromJson(Map<String, dynamic> json) =>
    _$CostReportImpl(
      totalCost: (json['totalCost'] as num).toDouble(),
      costsByCategory: (json['costsByCategory'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      periodStart: DateTime.parse(json['periodStart'] as String),
      periodEnd: DateTime.parse(json['periodEnd'] as String),
    );

Map<String, dynamic> _$$CostReportImplToJson(_$CostReportImpl instance) =>
    <String, dynamic>{
      'totalCost': instance.totalCost,
      'costsByCategory': instance.costsByCategory,
      'periodStart': instance.periodStart.toIso8601String(),
      'periodEnd': instance.periodEnd.toIso8601String(),
    };
