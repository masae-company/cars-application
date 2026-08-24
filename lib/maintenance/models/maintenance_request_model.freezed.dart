// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'maintenance_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MaintenanceRequestModel {
  String get id => throw _privateConstructorUsedError;
  String get carId => throw _privateConstructorUsedError;
  DateTime get requestedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  int? get oilChangePreviousKm => throw _privateConstructorUsedError;
  int? get oilChangeCurrentKm => throw _privateConstructorUsedError;
  DateTime? get brakePadsLastChanged => throw _privateConstructorUsedError;
  DateTime? get sparkPlugsLastChanged => throw _privateConstructorUsedError;
  DateTime? get tyresLastChanged => throw _privateConstructorUsedError;
  bool get acService => throw _privateConstructorUsedError;
  bool get lightsService => throw _privateConstructorUsedError;
  bool get tyreStackingService => throw _privateConstructorUsedError;
  List<String> get tyresPositions => throw _privateConstructorUsedError;
  MaintenanceRequestStatus get status => throw _privateConstructorUsedError;
  DateTime? get inProgressAt => throw _privateConstructorUsedError;
  String? get invoiceUrl => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of MaintenanceRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MaintenanceRequestModelCopyWith<MaintenanceRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MaintenanceRequestModelCopyWith<$Res> {
  factory $MaintenanceRequestModelCopyWith(MaintenanceRequestModel value,
          $Res Function(MaintenanceRequestModel) then) =
      _$MaintenanceRequestModelCopyWithImpl<$Res, MaintenanceRequestModel>;
  @useResult
  $Res call(
      {String id,
      String carId,
      DateTime requestedAt,
      DateTime? completedAt,
      String? notes,
      int? oilChangePreviousKm,
      int? oilChangeCurrentKm,
      DateTime? brakePadsLastChanged,
      DateTime? sparkPlugsLastChanged,
      DateTime? tyresLastChanged,
      bool acService,
      bool lightsService,
      bool tyreStackingService,
      List<String> tyresPositions,
      MaintenanceRequestStatus status,
      DateTime? inProgressAt,
      String? invoiceUrl,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$MaintenanceRequestModelCopyWithImpl<$Res,
        $Val extends MaintenanceRequestModel>
    implements $MaintenanceRequestModelCopyWith<$Res> {
  _$MaintenanceRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MaintenanceRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? carId = null,
    Object? requestedAt = null,
    Object? completedAt = freezed,
    Object? notes = freezed,
    Object? oilChangePreviousKm = freezed,
    Object? oilChangeCurrentKm = freezed,
    Object? brakePadsLastChanged = freezed,
    Object? sparkPlugsLastChanged = freezed,
    Object? tyresLastChanged = freezed,
    Object? acService = null,
    Object? lightsService = null,
    Object? tyreStackingService = null,
    Object? tyresPositions = null,
    Object? status = null,
    Object? inProgressAt = freezed,
    Object? invoiceUrl = freezed,
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
      requestedAt: null == requestedAt
          ? _value.requestedAt
          : requestedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      oilChangePreviousKm: freezed == oilChangePreviousKm
          ? _value.oilChangePreviousKm
          : oilChangePreviousKm // ignore: cast_nullable_to_non_nullable
              as int?,
      oilChangeCurrentKm: freezed == oilChangeCurrentKm
          ? _value.oilChangeCurrentKm
          : oilChangeCurrentKm // ignore: cast_nullable_to_non_nullable
              as int?,
      brakePadsLastChanged: freezed == brakePadsLastChanged
          ? _value.brakePadsLastChanged
          : brakePadsLastChanged // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sparkPlugsLastChanged: freezed == sparkPlugsLastChanged
          ? _value.sparkPlugsLastChanged
          : sparkPlugsLastChanged // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tyresLastChanged: freezed == tyresLastChanged
          ? _value.tyresLastChanged
          : tyresLastChanged // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      acService: null == acService
          ? _value.acService
          : acService // ignore: cast_nullable_to_non_nullable
              as bool,
      lightsService: null == lightsService
          ? _value.lightsService
          : lightsService // ignore: cast_nullable_to_non_nullable
              as bool,
      tyreStackingService: null == tyreStackingService
          ? _value.tyreStackingService
          : tyreStackingService // ignore: cast_nullable_to_non_nullable
              as bool,
      tyresPositions: null == tyresPositions
          ? _value.tyresPositions
          : tyresPositions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MaintenanceRequestStatus,
      inProgressAt: freezed == inProgressAt
          ? _value.inProgressAt
          : inProgressAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      invoiceUrl: freezed == invoiceUrl
          ? _value.invoiceUrl
          : invoiceUrl // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$MaintenanceRequestModelImplCopyWith<$Res>
    implements $MaintenanceRequestModelCopyWith<$Res> {
  factory _$$MaintenanceRequestModelImplCopyWith(
          _$MaintenanceRequestModelImpl value,
          $Res Function(_$MaintenanceRequestModelImpl) then) =
      __$$MaintenanceRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String carId,
      DateTime requestedAt,
      DateTime? completedAt,
      String? notes,
      int? oilChangePreviousKm,
      int? oilChangeCurrentKm,
      DateTime? brakePadsLastChanged,
      DateTime? sparkPlugsLastChanged,
      DateTime? tyresLastChanged,
      bool acService,
      bool lightsService,
      bool tyreStackingService,
      List<String> tyresPositions,
      MaintenanceRequestStatus status,
      DateTime? inProgressAt,
      String? invoiceUrl,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$MaintenanceRequestModelImplCopyWithImpl<$Res>
    extends _$MaintenanceRequestModelCopyWithImpl<$Res,
        _$MaintenanceRequestModelImpl>
    implements _$$MaintenanceRequestModelImplCopyWith<$Res> {
  __$$MaintenanceRequestModelImplCopyWithImpl(
      _$MaintenanceRequestModelImpl _value,
      $Res Function(_$MaintenanceRequestModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MaintenanceRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? carId = null,
    Object? requestedAt = null,
    Object? completedAt = freezed,
    Object? notes = freezed,
    Object? oilChangePreviousKm = freezed,
    Object? oilChangeCurrentKm = freezed,
    Object? brakePadsLastChanged = freezed,
    Object? sparkPlugsLastChanged = freezed,
    Object? tyresLastChanged = freezed,
    Object? acService = null,
    Object? lightsService = null,
    Object? tyreStackingService = null,
    Object? tyresPositions = null,
    Object? status = null,
    Object? inProgressAt = freezed,
    Object? invoiceUrl = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$MaintenanceRequestModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      carId: null == carId
          ? _value.carId
          : carId // ignore: cast_nullable_to_non_nullable
              as String,
      requestedAt: null == requestedAt
          ? _value.requestedAt
          : requestedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      oilChangePreviousKm: freezed == oilChangePreviousKm
          ? _value.oilChangePreviousKm
          : oilChangePreviousKm // ignore: cast_nullable_to_non_nullable
              as int?,
      oilChangeCurrentKm: freezed == oilChangeCurrentKm
          ? _value.oilChangeCurrentKm
          : oilChangeCurrentKm // ignore: cast_nullable_to_non_nullable
              as int?,
      brakePadsLastChanged: freezed == brakePadsLastChanged
          ? _value.brakePadsLastChanged
          : brakePadsLastChanged // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sparkPlugsLastChanged: freezed == sparkPlugsLastChanged
          ? _value.sparkPlugsLastChanged
          : sparkPlugsLastChanged // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tyresLastChanged: freezed == tyresLastChanged
          ? _value.tyresLastChanged
          : tyresLastChanged // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      acService: null == acService
          ? _value.acService
          : acService // ignore: cast_nullable_to_non_nullable
              as bool,
      lightsService: null == lightsService
          ? _value.lightsService
          : lightsService // ignore: cast_nullable_to_non_nullable
              as bool,
      tyreStackingService: null == tyreStackingService
          ? _value.tyreStackingService
          : tyreStackingService // ignore: cast_nullable_to_non_nullable
              as bool,
      tyresPositions: null == tyresPositions
          ? _value._tyresPositions
          : tyresPositions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MaintenanceRequestStatus,
      inProgressAt: freezed == inProgressAt
          ? _value.inProgressAt
          : inProgressAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      invoiceUrl: freezed == invoiceUrl
          ? _value.invoiceUrl
          : invoiceUrl // ignore: cast_nullable_to_non_nullable
              as String?,
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

class _$MaintenanceRequestModelImpl implements _MaintenanceRequestModel {
  const _$MaintenanceRequestModelImpl(
      {required this.id,
      required this.carId,
      required this.requestedAt,
      this.completedAt,
      this.notes,
      this.oilChangePreviousKm,
      this.oilChangeCurrentKm,
      this.brakePadsLastChanged,
      this.sparkPlugsLastChanged,
      this.tyresLastChanged,
      this.acService = false,
      this.lightsService = false,
      this.tyreStackingService = false,
      final List<String> tyresPositions = const [],
      this.status = MaintenanceRequestStatus.pending,
      this.inProgressAt,
      this.invoiceUrl,
      required this.createdAt,
      required this.updatedAt})
      : _tyresPositions = tyresPositions;

  @override
  final String id;
  @override
  final String carId;
  @override
  final DateTime requestedAt;
  @override
  final DateTime? completedAt;
  @override
  final String? notes;
  @override
  final int? oilChangePreviousKm;
  @override
  final int? oilChangeCurrentKm;
  @override
  final DateTime? brakePadsLastChanged;
  @override
  final DateTime? sparkPlugsLastChanged;
  @override
  final DateTime? tyresLastChanged;
  @override
  @JsonKey()
  final bool acService;
  @override
  @JsonKey()
  final bool lightsService;
  @override
  @JsonKey()
  final bool tyreStackingService;
  final List<String> _tyresPositions;
  @override
  @JsonKey()
  List<String> get tyresPositions {
    if (_tyresPositions is EqualUnmodifiableListView) return _tyresPositions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tyresPositions);
  }

  @override
  @JsonKey()
  final MaintenanceRequestStatus status;
  @override
  final DateTime? inProgressAt;
  @override
  final String? invoiceUrl;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'MaintenanceRequestModel(id: $id, carId: $carId, requestedAt: $requestedAt, completedAt: $completedAt, notes: $notes, oilChangePreviousKm: $oilChangePreviousKm, oilChangeCurrentKm: $oilChangeCurrentKm, brakePadsLastChanged: $brakePadsLastChanged, sparkPlugsLastChanged: $sparkPlugsLastChanged, tyresLastChanged: $tyresLastChanged, acService: $acService, lightsService: $lightsService, tyreStackingService: $tyreStackingService, tyresPositions: $tyresPositions, status: $status, inProgressAt: $inProgressAt, invoiceUrl: $invoiceUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MaintenanceRequestModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.carId, carId) || other.carId == carId) &&
            (identical(other.requestedAt, requestedAt) ||
                other.requestedAt == requestedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.oilChangePreviousKm, oilChangePreviousKm) ||
                other.oilChangePreviousKm == oilChangePreviousKm) &&
            (identical(other.oilChangeCurrentKm, oilChangeCurrentKm) ||
                other.oilChangeCurrentKm == oilChangeCurrentKm) &&
            (identical(other.brakePadsLastChanged, brakePadsLastChanged) ||
                other.brakePadsLastChanged == brakePadsLastChanged) &&
            (identical(other.sparkPlugsLastChanged, sparkPlugsLastChanged) ||
                other.sparkPlugsLastChanged == sparkPlugsLastChanged) &&
            (identical(other.tyresLastChanged, tyresLastChanged) ||
                other.tyresLastChanged == tyresLastChanged) &&
            (identical(other.acService, acService) ||
                other.acService == acService) &&
            (identical(other.lightsService, lightsService) ||
                other.lightsService == lightsService) &&
            (identical(other.tyreStackingService, tyreStackingService) ||
                other.tyreStackingService == tyreStackingService) &&
            const DeepCollectionEquality()
                .equals(other._tyresPositions, _tyresPositions) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.inProgressAt, inProgressAt) ||
                other.inProgressAt == inProgressAt) &&
            (identical(other.invoiceUrl, invoiceUrl) ||
                other.invoiceUrl == invoiceUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        carId,
        requestedAt,
        completedAt,
        notes,
        oilChangePreviousKm,
        oilChangeCurrentKm,
        brakePadsLastChanged,
        sparkPlugsLastChanged,
        tyresLastChanged,
        acService,
        lightsService,
        tyreStackingService,
        const DeepCollectionEquality().hash(_tyresPositions),
        status,
        inProgressAt,
        invoiceUrl,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of MaintenanceRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MaintenanceRequestModelImplCopyWith<_$MaintenanceRequestModelImpl>
      get copyWith => __$$MaintenanceRequestModelImplCopyWithImpl<
          _$MaintenanceRequestModelImpl>(this, _$identity);
}

abstract class _MaintenanceRequestModel implements MaintenanceRequestModel {
  const factory _MaintenanceRequestModel(
      {required final String id,
      required final String carId,
      required final DateTime requestedAt,
      final DateTime? completedAt,
      final String? notes,
      final int? oilChangePreviousKm,
      final int? oilChangeCurrentKm,
      final DateTime? brakePadsLastChanged,
      final DateTime? sparkPlugsLastChanged,
      final DateTime? tyresLastChanged,
      final bool acService,
      final bool lightsService,
      final bool tyreStackingService,
      final List<String> tyresPositions,
      final MaintenanceRequestStatus status,
      final DateTime? inProgressAt,
      final String? invoiceUrl,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$MaintenanceRequestModelImpl;

  @override
  String get id;
  @override
  String get carId;
  @override
  DateTime get requestedAt;
  @override
  DateTime? get completedAt;
  @override
  String? get notes;
  @override
  int? get oilChangePreviousKm;
  @override
  int? get oilChangeCurrentKm;
  @override
  DateTime? get brakePadsLastChanged;
  @override
  DateTime? get sparkPlugsLastChanged;
  @override
  DateTime? get tyresLastChanged;
  @override
  bool get acService;
  @override
  bool get lightsService;
  @override
  bool get tyreStackingService;
  @override
  List<String> get tyresPositions;
  @override
  MaintenanceRequestStatus get status;
  @override
  DateTime? get inProgressAt;
  @override
  String? get invoiceUrl;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of MaintenanceRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MaintenanceRequestModelImplCopyWith<_$MaintenanceRequestModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
