import 'package:freezed_annotation/freezed_annotation.dart';

part 'insurance_interval_model.freezed.dart';
part 'insurance_interval_model.g.dart';

@freezed
class InsuranceIntervalModel with _$InsuranceIntervalModel {
  const factory InsuranceIntervalModel({
    required String id,
    @JsonKey(name: 'car_id') required String carId,
    @JsonKey(name: 'interval_kilometers') required int intervalKilometers, // 30000-200000
    @JsonKey(name: 'interval_years') required int intervalYears, // 3-10
    @JsonKey(name: 'start_date') required DateTime startDate,
    @JsonKey(name: 'initial_kilometers') int? initialKilometers,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _InsuranceIntervalModel;

  factory InsuranceIntervalModel.fromJson(Map<String, dynamic> json) =>
      _$InsuranceIntervalModelFromJson(json);
}

