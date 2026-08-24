import 'package:freezed_annotation/freezed_annotation.dart';

part 'oil_change_progress_model.freezed.dart';
part 'oil_change_progress_model.g.dart';

@freezed
class OilChangeProgressModel with _$OilChangeProgressModel {
  const factory OilChangeProgressModel({
    required String id,
    @JsonKey(name: 'car_id') required String carId,
    @JsonKey(name: 'current_kilometers') @Default(0) int currentKilometers,
    @JsonKey(name: 'last_oil_change_kilometers') @Default(0) int lastOilChangeKilometers,
    @JsonKey(name: 'next_oil_change_kilometers') @Default(5000) int nextOilChangeKilometers,
    @JsonKey(name: 'last_updated') required DateTime lastUpdated,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _OilChangeProgressModel;

  factory OilChangeProgressModel.fromJson(Map<String, dynamic> json) =>
      _$OilChangeProgressModelFromJson(json);
}

