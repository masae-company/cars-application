// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'maintenance_history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MaintenanceHistoryModel {
  String get id => throw _privateConstructorUsedError;
  String get carId => throw _privateConstructorUsedError;
  MaintenanceType get maintenanceType => throw _privateConstructorUsedError;
  DateTime get performedAt => throw _privateConstructorUsedError;
  String get performedBy => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  int? get kilometers => throw _privateConstructorUsedError;
  double? get cost => throw _privateConstructorUsedError;
  DateTime? get nextDueDate => throw _privateConstructorUsedError;
  int? get nextDueKilometers => throw _privateConstructorUsedError;
  String? get requestId => throw _privateConstructorUsedError;
  ServiceCenterType? get serviceCenterType =>
      throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of MaintenanceHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MaintenanceHistoryModelCopyWith<MaintenanceHistoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MaintenanceHistoryModelCopyWith<$Res> {
  factory $MaintenanceHistoryModelCopyWith(MaintenanceHistoryModel value,
          $Res Function(MaintenanceHistoryModel) then) =
      _$MaintenanceHistoryModelCopyWithImpl<$Res, MaintenanceHistoryModel>;
  @useResult
  $Res call(
      {String id,
      String carId,
      MaintenanceType maintenanceType,
      DateTime performedAt,
      String performedBy,
      String? notes,
      int? kilometers,
      double? cost,
      DateTime? nextDueDate,
      int? nextDueKilometers,
      String? requestId,
      ServiceCenterType? serviceCenterType,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$MaintenanceHistoryModelCopyWithImpl<$Res,
        $Val extends MaintenanceHistoryModel>
    implements $MaintenanceHistoryModelCopyWith<$Res> {
  _$MaintenanceHistoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MaintenanceHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? carId = null,
    Object? maintenanceType = null,
    Object? performedAt = null,
    Object? performedBy = null,
    Object? notes = freezed,
    Object? kilometers = freezed,
    Object? cost = freezed,
    Object? nextDueDate = freezed,
    Object? nextDueKilometers = freezed,
    Object? requestId = freezed,
    Object? serviceCenterType = freezed,
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
      maintenanceType: null == maintenanceType
          ? _value.maintenanceType
          : maintenanceType // ignore: cast_nullable_to_non_nullable
              as MaintenanceType,
      performedAt: null == performedAt
          ? _value.performedAt
          : performedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      performedBy: null == performedBy
          ? _value.performedBy
          : performedBy // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      kilometers: freezed == kilometers
          ? _value.kilometers
          : kilometers // ignore: cast_nullable_to_non_nullable
              as int?,
      cost: freezed == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as double?,
      nextDueDate: freezed == nextDueDate
          ? _value.nextDueDate
          : nextDueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nextDueKilometers: freezed == nextDueKilometers
          ? _value.nextDueKilometers
          : nextDueKilometers // ignore: cast_nullable_to_non_nullable
              as int?,
      requestId: freezed == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String?,
      serviceCenterType: freezed == serviceCenterType
          ? _value.serviceCenterType
          : serviceCenterType // ignore: cast_nullable_to_non_nullable
              as ServiceCenterType?,
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
abstract class _$$MaintenanceHistoryModelImplCopyWith<$Res>
    implements $MaintenanceHistoryModelCopyWith<$Res> {
  factory _$$MaintenanceHistoryModelImplCopyWith(
          _$MaintenanceHistoryModelImpl value,
          $Res Function(_$MaintenanceHistoryModelImpl) then) =
      __$$MaintenanceHistoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String carId,
      MaintenanceType maintenanceType,
      DateTime performedAt,
      String performedBy,
      String? notes,
      int? kilometers,
      double? cost,
      DateTime? nextDueDate,
      int? nextDueKilometers,
      String? requestId,
      ServiceCenterType? serviceCenterType,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$MaintenanceHistoryModelImplCopyWithImpl<$Res>
    extends _$MaintenanceHistoryModelCopyWithImpl<$Res,
        _$MaintenanceHistoryModelImpl>
    implements _$$MaintenanceHistoryModelImplCopyWith<$Res> {
  __$$MaintenanceHistoryModelImplCopyWithImpl(
      _$MaintenanceHistoryModelImpl _value,
      $Res Function(_$MaintenanceHistoryModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MaintenanceHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? carId = null,
    Object? maintenanceType = null,
    Object? performedAt = null,
    Object? performedBy = null,
    Object? notes = freezed,
    Object? kilometers = freezed,
    Object? cost = freezed,
    Object? nextDueDate = freezed,
    Object? nextDueKilometers = freezed,
    Object? requestId = freezed,
    Object? serviceCenterType = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$MaintenanceHistoryModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      carId: null == carId
          ? _value.carId
          : carId // ignore: cast_nullable_to_non_nullable
              as String,
      maintenanceType: null == maintenanceType
          ? _value.maintenanceType
          : maintenanceType // ignore: cast_nullable_to_non_nullable
              as MaintenanceType,
      performedAt: null == performedAt
          ? _value.performedAt
          : performedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      performedBy: null == performedBy
          ? _value.performedBy
          : performedBy // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      kilometers: freezed == kilometers
          ? _value.kilometers
          : kilometers // ignore: cast_nullable_to_non_nullable
              as int?,
      cost: freezed == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as double?,
      nextDueDate: freezed == nextDueDate
          ? _value.nextDueDate
          : nextDueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nextDueKilometers: freezed == nextDueKilometers
          ? _value.nextDueKilometers
          : nextDueKilometers // ignore: cast_nullable_to_non_nullable
              as int?,
      requestId: freezed == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String?,
      serviceCenterType: freezed == serviceCenterType
          ? _value.serviceCenterType
          : serviceCenterType // ignore: cast_nullable_to_non_nullable
              as ServiceCenterType?,
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

class _$MaintenanceHistoryModelImpl implements _MaintenanceHistoryModel {
  const _$MaintenanceHistoryModelImpl(
      {required this.id,
      required this.carId,
      required this.maintenanceType,
      required this.performedAt,
      required this.performedBy,
      this.notes,
      this.kilometers,
      this.cost,
      this.nextDueDate,
      this.nextDueKilometers,
      this.requestId,
      this.serviceCenterType,
      required this.createdAt,
      required this.updatedAt});

  @override
  final String id;
  @override
  final String carId;
  @override
  final MaintenanceType maintenanceType;
  @override
  final DateTime performedAt;
  @override
  final String performedBy;
  @override
  final String? notes;
  @override
  final int? kilometers;
  @override
  final double? cost;
  @override
  final DateTime? nextDueDate;
  @override
  final int? nextDueKilometers;
  @override
  final String? requestId;
  @override
  final ServiceCenterType? serviceCenterType;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'MaintenanceHistoryModel(id: $id, carId: $carId, maintenanceType: $maintenanceType, performedAt: $performedAt, performedBy: $performedBy, notes: $notes, kilometers: $kilometers, cost: $cost, nextDueDate: $nextDueDate, nextDueKilometers: $nextDueKilometers, requestId: $requestId, serviceCenterType: $serviceCenterType, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MaintenanceHistoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.carId, carId) || other.carId == carId) &&
            (identical(other.maintenanceType, maintenanceType) ||
                other.maintenanceType == maintenanceType) &&
            (identical(other.performedAt, performedAt) ||
                other.performedAt == performedAt) &&
            (identical(other.performedBy, performedBy) ||
                other.performedBy == performedBy) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.kilometers, kilometers) ||
                other.kilometers == kilometers) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            (identical(other.nextDueDate, nextDueDate) ||
                other.nextDueDate == nextDueDate) &&
            (identical(other.nextDueKilometers, nextDueKilometers) ||
                other.nextDueKilometers == nextDueKilometers) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.serviceCenterType, serviceCenterType) ||
                other.serviceCenterType == serviceCenterType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      carId,
      maintenanceType,
      performedAt,
      performedBy,
      notes,
      kilometers,
      cost,
      nextDueDate,
      nextDueKilometers,
      requestId,
      serviceCenterType,
      createdAt,
      updatedAt);

  /// Create a copy of MaintenanceHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MaintenanceHistoryModelImplCopyWith<_$MaintenanceHistoryModelImpl>
      get copyWith => __$$MaintenanceHistoryModelImplCopyWithImpl<
          _$MaintenanceHistoryModelImpl>(this, _$identity);
}

abstract class _MaintenanceHistoryModel implements MaintenanceHistoryModel {
  const factory _MaintenanceHistoryModel(
      {required final String id,
      required final String carId,
      required final MaintenanceType maintenanceType,
      required final DateTime performedAt,
      required final String performedBy,
      final String? notes,
      final int? kilometers,
      final double? cost,
      final DateTime? nextDueDate,
      final int? nextDueKilometers,
      final String? requestId,
      final ServiceCenterType? serviceCenterType,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$MaintenanceHistoryModelImpl;

  @override
  String get id;
  @override
  String get carId;
  @override
  MaintenanceType get maintenanceType;
  @override
  DateTime get performedAt;
  @override
  String get performedBy;
  @override
  String? get notes;
  @override
  int? get kilometers;
  @override
  double? get cost;
  @override
  DateTime? get nextDueDate;
  @override
  int? get nextDueKilometers;
  @override
  String? get requestId;
  @override
  ServiceCenterType? get serviceCenterType;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of MaintenanceHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MaintenanceHistoryModelImplCopyWith<_$MaintenanceHistoryModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
