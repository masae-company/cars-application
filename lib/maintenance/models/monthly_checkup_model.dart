import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_checkup_model.freezed.dart';
part 'monthly_checkup_model.g.dart';

@freezed
class MonthlyCheckupModel with _$MonthlyCheckupModel {
  const factory MonthlyCheckupModel({
    required String id,
    @JsonKey(name: 'car_id') required String carId,
    @JsonKey(name: 'checkup_date') required DateTime checkupDate,
    @JsonKey(name: 'performed_by') required String performedBy,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    String? notes,
    @JsonKey(name: 'engine_oil_replaced') @Default(false) bool engineOilReplaced,
    @JsonKey(name: 'engine_air_filter_inspected') @Default(false) bool engineAirFilterInspected,
    @JsonKey(name: 'engine_air_filter_replaced') @Default(false) bool engineAirFilterReplaced,
    @JsonKey(name: 'ac_air_filter_inspected') @Default(false) bool acAirFilterInspected,
    @JsonKey(name: 'automatic_transmission_fluid_inspected') @Default(false) bool automaticTransmissionFluidInspected,
    @JsonKey(name: 'manual_transmission_fluid_inspected') @Default(false) bool manualTransmissionFluidInspected,
    @JsonKey(name: 'differential_fluid_inspected') @Default(false) bool differentialFluidInspected,
    @JsonKey(name: 'spark_plugs_inspected') @Default(false) bool sparkPlugsInspected,
    @JsonKey(name: 'coolant_level_inspected') @Default(false) bool coolantLevelInspected,
    @JsonKey(name: 'coolant_condition_inspected') @Default(false) bool coolantConditionInspected,
    @JsonKey(name: 'brake_clutch_fluid_inspected') @Default(false) bool brakeClutchFluidInspected,
    @JsonKey(name: 'fluid_leaks_inspected') @Default(false) bool fluidLeaksInspected,
    @JsonKey(name: 'radiator_hoses_inspected') @Default(false) bool radiatorHosesInspected,
    @JsonKey(name: 'drive_shafts_boots_inspected') @Default(false) bool driveShaftsBootsInspected,
    @JsonKey(name: 'fuel_filter_inspected') @Default(false) bool fuelFilterInspected,
    @JsonKey(name: 'suspension_inspected') @Default(false) bool suspensionInspected,
    @JsonKey(name: 'shock_absorber_inspected') @Default(false) bool shockAbsorberInspected,
    @JsonKey(name: 'suspension_retightened') @Default(false) bool suspensionRetightened,
    @JsonKey(name: 'engine_support_inspected') @Default(false) bool engineSupportInspected,
    @JsonKey(name: 'drive_belt_pulleys_inspected') @Default(false) bool driveBeltPulleysInspected,
    @JsonKey(name: 'brake_lines_inspected') @Default(false) bool brakeLinesInspected,
    @JsonKey(name: 'brake_pads_inspected') @Default(false) bool brakePadsInspected,
    @JsonKey(name: 'park_brake_inspected') @Default(false) bool parkBrakeInspected,
    @JsonKey(name: 'tires_inspected') @Default(false) bool tiresInspected,
    @JsonKey(name: 'exhaust_system_inspected') @Default(false) bool exhaustSystemInspected,
    @JsonKey(name: 'tires_rotated') @Default(false) bool tiresRotated,
    @JsonKey(name: 'lights_inspected') @Default(false) bool lightsInspected,
    @JsonKey(name: 'battery_inspected') @Default(false) bool batteryInspected,
    @JsonKey(name: 'ac_operation_inspected') @Default(false) bool acOperationInspected,
    @JsonKey(name: 'wipers_inspected') @Default(false) bool wipersInspected,
    @JsonKey(name: 'diagnostic_tools_used') @Default(false) bool diagnosticToolsUsed,
    @JsonKey(name: 'oil_service_reset') @Default(false) bool oilServiceReset,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _MonthlyCheckupModel;

  factory MonthlyCheckupModel.fromJson(Map<String, dynamic> json) =>
      _$MonthlyCheckupModelFromJson(json);
}

