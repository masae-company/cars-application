// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_checkup_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MonthlyCheckupModelImpl _$$MonthlyCheckupModelImplFromJson(
        Map<String, dynamic> json) =>
    _$MonthlyCheckupModelImpl(
      id: json['id'] as String,
      carId: json['car_id'] as String,
      checkupDate: DateTime.parse(json['checkup_date'] as String),
      performedBy: json['performed_by'] as String,
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      notes: json['notes'] as String?,
      engineOilReplaced: json['engine_oil_replaced'] as bool? ?? false,
      engineAirFilterInspected:
          json['engine_air_filter_inspected'] as bool? ?? false,
      engineAirFilterReplaced:
          json['engine_air_filter_replaced'] as bool? ?? false,
      acAirFilterInspected: json['ac_air_filter_inspected'] as bool? ?? false,
      automaticTransmissionFluidInspected:
          json['automatic_transmission_fluid_inspected'] as bool? ?? false,
      manualTransmissionFluidInspected:
          json['manual_transmission_fluid_inspected'] as bool? ?? false,
      differentialFluidInspected:
          json['differential_fluid_inspected'] as bool? ?? false,
      sparkPlugsInspected: json['spark_plugs_inspected'] as bool? ?? false,
      coolantLevelInspected: json['coolant_level_inspected'] as bool? ?? false,
      coolantConditionInspected:
          json['coolant_condition_inspected'] as bool? ?? false,
      brakeClutchFluidInspected:
          json['brake_clutch_fluid_inspected'] as bool? ?? false,
      fluidLeaksInspected: json['fluid_leaks_inspected'] as bool? ?? false,
      radiatorHosesInspected:
          json['radiator_hoses_inspected'] as bool? ?? false,
      driveShaftsBootsInspected:
          json['drive_shafts_boots_inspected'] as bool? ?? false,
      fuelFilterInspected: json['fuel_filter_inspected'] as bool? ?? false,
      suspensionInspected: json['suspension_inspected'] as bool? ?? false,
      shockAbsorberInspected:
          json['shock_absorber_inspected'] as bool? ?? false,
      suspensionRetightened: json['suspension_retightened'] as bool? ?? false,
      engineSupportInspected:
          json['engine_support_inspected'] as bool? ?? false,
      driveBeltPulleysInspected:
          json['drive_belt_pulleys_inspected'] as bool? ?? false,
      brakeLinesInspected: json['brake_lines_inspected'] as bool? ?? false,
      brakePadsInspected: json['brake_pads_inspected'] as bool? ?? false,
      parkBrakeInspected: json['park_brake_inspected'] as bool? ?? false,
      tiresInspected: json['tires_inspected'] as bool? ?? false,
      exhaustSystemInspected:
          json['exhaust_system_inspected'] as bool? ?? false,
      tiresRotated: json['tires_rotated'] as bool? ?? false,
      lightsInspected: json['lights_inspected'] as bool? ?? false,
      batteryInspected: json['battery_inspected'] as bool? ?? false,
      acOperationInspected: json['ac_operation_inspected'] as bool? ?? false,
      wipersInspected: json['wipers_inspected'] as bool? ?? false,
      diagnosticToolsUsed: json['diagnostic_tools_used'] as bool? ?? false,
      oilServiceReset: json['oil_service_reset'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$MonthlyCheckupModelImplToJson(
        _$MonthlyCheckupModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'car_id': instance.carId,
      'checkup_date': instance.checkupDate.toIso8601String(),
      'performed_by': instance.performedBy,
      'completed_at': instance.completedAt?.toIso8601String(),
      'notes': instance.notes,
      'engine_oil_replaced': instance.engineOilReplaced,
      'engine_air_filter_inspected': instance.engineAirFilterInspected,
      'engine_air_filter_replaced': instance.engineAirFilterReplaced,
      'ac_air_filter_inspected': instance.acAirFilterInspected,
      'automatic_transmission_fluid_inspected':
          instance.automaticTransmissionFluidInspected,
      'manual_transmission_fluid_inspected':
          instance.manualTransmissionFluidInspected,
      'differential_fluid_inspected': instance.differentialFluidInspected,
      'spark_plugs_inspected': instance.sparkPlugsInspected,
      'coolant_level_inspected': instance.coolantLevelInspected,
      'coolant_condition_inspected': instance.coolantConditionInspected,
      'brake_clutch_fluid_inspected': instance.brakeClutchFluidInspected,
      'fluid_leaks_inspected': instance.fluidLeaksInspected,
      'radiator_hoses_inspected': instance.radiatorHosesInspected,
      'drive_shafts_boots_inspected': instance.driveShaftsBootsInspected,
      'fuel_filter_inspected': instance.fuelFilterInspected,
      'suspension_inspected': instance.suspensionInspected,
      'shock_absorber_inspected': instance.shockAbsorberInspected,
      'suspension_retightened': instance.suspensionRetightened,
      'engine_support_inspected': instance.engineSupportInspected,
      'drive_belt_pulleys_inspected': instance.driveBeltPulleysInspected,
      'brake_lines_inspected': instance.brakeLinesInspected,
      'brake_pads_inspected': instance.brakePadsInspected,
      'park_brake_inspected': instance.parkBrakeInspected,
      'tires_inspected': instance.tiresInspected,
      'exhaust_system_inspected': instance.exhaustSystemInspected,
      'tires_rotated': instance.tiresRotated,
      'lights_inspected': instance.lightsInspected,
      'battery_inspected': instance.batteryInspected,
      'ac_operation_inspected': instance.acOperationInspected,
      'wipers_inspected': instance.wipersInspected,
      'diagnostic_tools_used': instance.diagnosticToolsUsed,
      'oil_service_reset': instance.oilServiceReset,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
