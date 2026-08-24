// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'insurance_interval_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InsuranceIntervalModel _$InsuranceIntervalModelFromJson(
    Map<String, dynamic> json) {
  return _InsuranceIntervalModel.fromJson(json);
}

/// @nodoc
mixin _$InsuranceIntervalModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'car_id')
  String get carId => throw _privateConstructorUsedError;
  @JsonKey(name: 'interval_kilometers')
  int get intervalKilometers =>
      throw _privateConstructorUsedError; // 30000-200000
  @JsonKey(name: 'interval_years')
  int get intervalYears => throw _privateConstructorUsedError; // 3-10
  @JsonKey(name: 'start_date')
  DateTime get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'initial_kilometers')
  int? get initialKilometers => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this InsuranceIntervalModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InsuranceIntervalModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InsuranceIntervalModelCopyWith<InsuranceIntervalModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InsuranceIntervalModelCopyWith<$Res> {
  factory $InsuranceIntervalModelCopyWith(InsuranceIntervalModel value,
          $Res Function(InsuranceIntervalModel) then) =
      _$InsuranceIntervalModelCopyWithImpl<$Res, InsuranceIntervalModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'car_id') String carId,
      @JsonKey(name: 'interval_kilometers') int intervalKilometers,
      @JsonKey(name: 'interval_years') int intervalYears,
      @JsonKey(name: 'start_date') DateTime startDate,
      @JsonKey(name: 'initial_kilometers') int? initialKilometers,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$InsuranceIntervalModelCopyWithImpl<$Res,
        $Val extends InsuranceIntervalModel>
    implements $InsuranceIntervalModelCopyWith<$Res> {
  _$InsuranceIntervalModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InsuranceIntervalModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? carId = null,
    Object? intervalKilometers = null,
    Object? intervalYears = null,
    Object? startDate = null,
    Object? initialKilometers = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      carId: null == carId
          ? _value.carId
          : carId // ignore: cast_nullable_to_non_nullable
              as String,
      intervalKilometers: null == intervalKilometers
          ? _value.intervalKilometers
          : intervalKilometers // ignore: cast_nullable_to_non_nullable
              as int,
      intervalYears: null == intervalYears
          ? _value.intervalYears
          : intervalYears // ignore: cast_nullable_to_non_nullable
              as int,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      initialKilometers: freezed == initialKilometers
          ? _value.initialKilometers
          : initialKilometers // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InsuranceIntervalModelImplCopyWith<$Res>
    implements $InsuranceIntervalModelCopyWith<$Res> {
  factory _$$InsuranceIntervalModelImplCopyWith(
          _$InsuranceIntervalModelImpl value,
          $Res Function(_$InsuranceIntervalModelImpl) then) =
      __$$InsuranceIntervalModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'car_id') String carId,
      @JsonKey(name: 'interval_kilometers') int intervalKilometers,
      @JsonKey(name: 'interval_years') int intervalYears,
      @JsonKey(name: 'start_date') DateTime startDate,
      @JsonKey(name: 'initial_kilometers') int? initialKilometers,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$InsuranceIntervalModelImplCopyWithImpl<$Res>
    extends _$InsuranceIntervalModelCopyWithImpl<$Res,
        _$InsuranceIntervalModelImpl>
    implements _$$InsuranceIntervalModelImplCopyWith<$Res> {
  __$$InsuranceIntervalModelImplCopyWithImpl(
      _$InsuranceIntervalModelImpl _value,
      $Res Function(_$InsuranceIntervalModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of InsuranceIntervalModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? carId = null,
    Object? intervalKilometers = null,
    Object? intervalYears = null,
    Object? startDate = null,
    Object? initialKilometers = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$InsuranceIntervalModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      carId: null == carId
          ? _value.carId
          : carId // ignore: cast_nullable_to_non_nullable
              as String,
      intervalKilometers: null == intervalKilometers
          ? _value.intervalKilometers
          : intervalKilometers // ignore: cast_nullable_to_non_nullable
              as int,
      intervalYears: null == intervalYears
          ? _value.intervalYears
          : intervalYears // ignore: cast_nullable_to_non_nullable
              as int,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      initialKilometers: freezed == initialKilometers
          ? _value.initialKilometers
          : initialKilometers // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InsuranceIntervalModelImpl implements _InsuranceIntervalModel {
  const _$InsuranceIntervalModelImpl(
      {required this.id,
      @JsonKey(name: 'car_id') required this.carId,
      @JsonKey(name: 'interval_kilometers') required this.intervalKilometers,
      @JsonKey(name: 'interval_years') required this.intervalYears,
      @JsonKey(name: 'start_date') required this.startDate,
      @JsonKey(name: 'initial_kilometers') this.initialKilometers,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$InsuranceIntervalModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$InsuranceIntervalModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'car_id')
  final String carId;
  @override
  @JsonKey(name: 'interval_kilometers')
  final int intervalKilometers;
// 30000-200000
  @override
  @JsonKey(name: 'interval_years')
  final int intervalYears;
// 3-10
  @override
  @JsonKey(name: 'start_date')
  final DateTime startDate;
  @override
  @JsonKey(name: 'initial_kilometers')
  final int? initialKilometers;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'InsuranceIntervalModel(id: $id, carId: $carId, intervalKilometers: $intervalKilometers, intervalYears: $intervalYears, startDate: $startDate, initialKilometers: $initialKilometers, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsuranceIntervalModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.carId, carId) || other.carId == carId) &&
            (identical(other.intervalKilometers, intervalKilometers) ||
                other.intervalKilometers == intervalKilometers) &&
            (identical(other.intervalYears, intervalYears) ||
                other.intervalYears == intervalYears) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.initialKilometers, initialKilometers) ||
                other.initialKilometers == initialKilometers) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, carId, intervalKilometers,
      intervalYears, startDate, initialKilometers, createdAt, updatedAt);

  /// Create a copy of InsuranceIntervalModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InsuranceIntervalModelImplCopyWith<_$InsuranceIntervalModelImpl>
      get copyWith => __$$InsuranceIntervalModelImplCopyWithImpl<
          _$InsuranceIntervalModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InsuranceIntervalModelImplToJson(
      this,
    );
  }
}

abstract class _InsuranceIntervalModel implements InsuranceIntervalModel {
  const factory _InsuranceIntervalModel(
          {required final String id,
          @JsonKey(name: 'car_id') required final String carId,
          @JsonKey(name: 'interval_kilometers')
          required final int intervalKilometers,
          @JsonKey(name: 'interval_years') required final int intervalYears,
          @JsonKey(name: 'start_date') required final DateTime startDate,
          @JsonKey(name: 'initial_kilometers') final int? initialKilometers,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$InsuranceIntervalModelImpl;

  factory _InsuranceIntervalModel.fromJson(Map<String, dynamic> json) =
      _$InsuranceIntervalModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'car_id')
  String get carId;
  @override
  @JsonKey(name: 'interval_kilometers')
  int get intervalKilometers; // 30000-200000
  @override
  @JsonKey(name: 'interval_years')
  int get intervalYears; // 3-10
  @override
  @JsonKey(name: 'start_date')
  DateTime get startDate;
  @override
  @JsonKey(name: 'initial_kilometers')
  int? get initialKilometers;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of InsuranceIntervalModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InsuranceIntervalModelImplCopyWith<_$InsuranceIntervalModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
