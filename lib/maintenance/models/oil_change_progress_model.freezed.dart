// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'oil_change_progress_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OilChangeProgressModel _$OilChangeProgressModelFromJson(
    Map<String, dynamic> json) {
  return _OilChangeProgressModel.fromJson(json);
}

/// @nodoc
mixin _$OilChangeProgressModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'car_id')
  String get carId => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_kilometers')
  int get currentKilometers => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_oil_change_kilometers')
  int get lastOilChangeKilometers => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_oil_change_kilometers')
  int get nextOilChangeKilometers => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_updated')
  DateTime get lastUpdated => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this OilChangeProgressModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OilChangeProgressModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OilChangeProgressModelCopyWith<OilChangeProgressModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OilChangeProgressModelCopyWith<$Res> {
  factory $OilChangeProgressModelCopyWith(OilChangeProgressModel value,
          $Res Function(OilChangeProgressModel) then) =
      _$OilChangeProgressModelCopyWithImpl<$Res, OilChangeProgressModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'car_id') String carId,
      @JsonKey(name: 'current_kilometers') int currentKilometers,
      @JsonKey(name: 'last_oil_change_kilometers') int lastOilChangeKilometers,
      @JsonKey(name: 'next_oil_change_kilometers') int nextOilChangeKilometers,
      @JsonKey(name: 'last_updated') DateTime lastUpdated,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$OilChangeProgressModelCopyWithImpl<$Res,
        $Val extends OilChangeProgressModel>
    implements $OilChangeProgressModelCopyWith<$Res> {
  _$OilChangeProgressModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OilChangeProgressModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? carId = null,
    Object? currentKilometers = null,
    Object? lastOilChangeKilometers = null,
    Object? nextOilChangeKilometers = null,
    Object? lastUpdated = null,
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
      currentKilometers: null == currentKilometers
          ? _value.currentKilometers
          : currentKilometers // ignore: cast_nullable_to_non_nullable
              as int,
      lastOilChangeKilometers: null == lastOilChangeKilometers
          ? _value.lastOilChangeKilometers
          : lastOilChangeKilometers // ignore: cast_nullable_to_non_nullable
              as int,
      nextOilChangeKilometers: null == nextOilChangeKilometers
          ? _value.nextOilChangeKilometers
          : nextOilChangeKilometers // ignore: cast_nullable_to_non_nullable
              as int,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
abstract class _$$OilChangeProgressModelImplCopyWith<$Res>
    implements $OilChangeProgressModelCopyWith<$Res> {
  factory _$$OilChangeProgressModelImplCopyWith(
          _$OilChangeProgressModelImpl value,
          $Res Function(_$OilChangeProgressModelImpl) then) =
      __$$OilChangeProgressModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'car_id') String carId,
      @JsonKey(name: 'current_kilometers') int currentKilometers,
      @JsonKey(name: 'last_oil_change_kilometers') int lastOilChangeKilometers,
      @JsonKey(name: 'next_oil_change_kilometers') int nextOilChangeKilometers,
      @JsonKey(name: 'last_updated') DateTime lastUpdated,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$OilChangeProgressModelImplCopyWithImpl<$Res>
    extends _$OilChangeProgressModelCopyWithImpl<$Res,
        _$OilChangeProgressModelImpl>
    implements _$$OilChangeProgressModelImplCopyWith<$Res> {
  __$$OilChangeProgressModelImplCopyWithImpl(
      _$OilChangeProgressModelImpl _value,
      $Res Function(_$OilChangeProgressModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of OilChangeProgressModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? carId = null,
    Object? currentKilometers = null,
    Object? lastOilChangeKilometers = null,
    Object? nextOilChangeKilometers = null,
    Object? lastUpdated = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$OilChangeProgressModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      carId: null == carId
          ? _value.carId
          : carId // ignore: cast_nullable_to_non_nullable
              as String,
      currentKilometers: null == currentKilometers
          ? _value.currentKilometers
          : currentKilometers // ignore: cast_nullable_to_non_nullable
              as int,
      lastOilChangeKilometers: null == lastOilChangeKilometers
          ? _value.lastOilChangeKilometers
          : lastOilChangeKilometers // ignore: cast_nullable_to_non_nullable
              as int,
      nextOilChangeKilometers: null == nextOilChangeKilometers
          ? _value.nextOilChangeKilometers
          : nextOilChangeKilometers // ignore: cast_nullable_to_non_nullable
              as int,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
class _$OilChangeProgressModelImpl implements _OilChangeProgressModel {
  const _$OilChangeProgressModelImpl(
      {required this.id,
      @JsonKey(name: 'car_id') required this.carId,
      @JsonKey(name: 'current_kilometers') this.currentKilometers = 0,
      @JsonKey(name: 'last_oil_change_kilometers')
      this.lastOilChangeKilometers = 0,
      @JsonKey(name: 'next_oil_change_kilometers')
      this.nextOilChangeKilometers = 5000,
      @JsonKey(name: 'last_updated') required this.lastUpdated,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$OilChangeProgressModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OilChangeProgressModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'car_id')
  final String carId;
  @override
  @JsonKey(name: 'current_kilometers')
  final int currentKilometers;
  @override
  @JsonKey(name: 'last_oil_change_kilometers')
  final int lastOilChangeKilometers;
  @override
  @JsonKey(name: 'next_oil_change_kilometers')
  final int nextOilChangeKilometers;
  @override
  @JsonKey(name: 'last_updated')
  final DateTime lastUpdated;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'OilChangeProgressModel(id: $id, carId: $carId, currentKilometers: $currentKilometers, lastOilChangeKilometers: $lastOilChangeKilometers, nextOilChangeKilometers: $nextOilChangeKilometers, lastUpdated: $lastUpdated, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OilChangeProgressModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.carId, carId) || other.carId == carId) &&
            (identical(other.currentKilometers, currentKilometers) ||
                other.currentKilometers == currentKilometers) &&
            (identical(
                    other.lastOilChangeKilometers, lastOilChangeKilometers) ||
                other.lastOilChangeKilometers == lastOilChangeKilometers) &&
            (identical(
                    other.nextOilChangeKilometers, nextOilChangeKilometers) ||
                other.nextOilChangeKilometers == nextOilChangeKilometers) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      carId,
      currentKilometers,
      lastOilChangeKilometers,
      nextOilChangeKilometers,
      lastUpdated,
      createdAt,
      updatedAt);

  /// Create a copy of OilChangeProgressModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OilChangeProgressModelImplCopyWith<_$OilChangeProgressModelImpl>
      get copyWith => __$$OilChangeProgressModelImplCopyWithImpl<
          _$OilChangeProgressModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OilChangeProgressModelImplToJson(
      this,
    );
  }
}

abstract class _OilChangeProgressModel implements OilChangeProgressModel {
  const factory _OilChangeProgressModel(
          {required final String id,
          @JsonKey(name: 'car_id') required final String carId,
          @JsonKey(name: 'current_kilometers') final int currentKilometers,
          @JsonKey(name: 'last_oil_change_kilometers')
          final int lastOilChangeKilometers,
          @JsonKey(name: 'next_oil_change_kilometers')
          final int nextOilChangeKilometers,
          @JsonKey(name: 'last_updated') required final DateTime lastUpdated,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$OilChangeProgressModelImpl;

  factory _OilChangeProgressModel.fromJson(Map<String, dynamic> json) =
      _$OilChangeProgressModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'car_id')
  String get carId;
  @override
  @JsonKey(name: 'current_kilometers')
  int get currentKilometers;
  @override
  @JsonKey(name: 'last_oil_change_kilometers')
  int get lastOilChangeKilometers;
  @override
  @JsonKey(name: 'next_oil_change_kilometers')
  int get nextOilChangeKilometers;
  @override
  @JsonKey(name: 'last_updated')
  DateTime get lastUpdated;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of OilChangeProgressModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OilChangeProgressModelImplCopyWith<_$OilChangeProgressModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
