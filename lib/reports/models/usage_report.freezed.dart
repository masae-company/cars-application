// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'usage_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UsageReport _$UsageReportFromJson(Map<String, dynamic> json) {
  return _UsageReport.fromJson(json);
}

/// @nodoc
mixin _$UsageReport {
  String get vehicleId => throw _privateConstructorUsedError;
  String get vehicleRegistration => throw _privateConstructorUsedError;
  int get totalAllocations => throw _privateConstructorUsedError;
  int get totalDays => throw _privateConstructorUsedError;
  int get totalMileage => throw _privateConstructorUsedError;
  DateTime get periodStart => throw _privateConstructorUsedError;
  DateTime get periodEnd => throw _privateConstructorUsedError;

  /// Serializes this UsageReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UsageReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UsageReportCopyWith<UsageReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsageReportCopyWith<$Res> {
  factory $UsageReportCopyWith(
          UsageReport value, $Res Function(UsageReport) then) =
      _$UsageReportCopyWithImpl<$Res, UsageReport>;
  @useResult
  $Res call(
      {String vehicleId,
      String vehicleRegistration,
      int totalAllocations,
      int totalDays,
      int totalMileage,
      DateTime periodStart,
      DateTime periodEnd});
}

/// @nodoc
class _$UsageReportCopyWithImpl<$Res, $Val extends UsageReport>
    implements $UsageReportCopyWith<$Res> {
  _$UsageReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UsageReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vehicleId = null,
    Object? vehicleRegistration = null,
    Object? totalAllocations = null,
    Object? totalDays = null,
    Object? totalMileage = null,
    Object? periodStart = null,
    Object? periodEnd = null,
  }) {
    return _then(_value.copyWith(
      vehicleId: null == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleRegistration: null == vehicleRegistration
          ? _value.vehicleRegistration
          : vehicleRegistration // ignore: cast_nullable_to_non_nullable
              as String,
      totalAllocations: null == totalAllocations
          ? _value.totalAllocations
          : totalAllocations // ignore: cast_nullable_to_non_nullable
              as int,
      totalDays: null == totalDays
          ? _value.totalDays
          : totalDays // ignore: cast_nullable_to_non_nullable
              as int,
      totalMileage: null == totalMileage
          ? _value.totalMileage
          : totalMileage // ignore: cast_nullable_to_non_nullable
              as int,
      periodStart: null == periodStart
          ? _value.periodStart
          : periodStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      periodEnd: null == periodEnd
          ? _value.periodEnd
          : periodEnd // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UsageReportImplCopyWith<$Res>
    implements $UsageReportCopyWith<$Res> {
  factory _$$UsageReportImplCopyWith(
          _$UsageReportImpl value, $Res Function(_$UsageReportImpl) then) =
      __$$UsageReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String vehicleId,
      String vehicleRegistration,
      int totalAllocations,
      int totalDays,
      int totalMileage,
      DateTime periodStart,
      DateTime periodEnd});
}

/// @nodoc
class __$$UsageReportImplCopyWithImpl<$Res>
    extends _$UsageReportCopyWithImpl<$Res, _$UsageReportImpl>
    implements _$$UsageReportImplCopyWith<$Res> {
  __$$UsageReportImplCopyWithImpl(
      _$UsageReportImpl _value, $Res Function(_$UsageReportImpl) _then)
      : super(_value, _then);

  /// Create a copy of UsageReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vehicleId = null,
    Object? vehicleRegistration = null,
    Object? totalAllocations = null,
    Object? totalDays = null,
    Object? totalMileage = null,
    Object? periodStart = null,
    Object? periodEnd = null,
  }) {
    return _then(_$UsageReportImpl(
      vehicleId: null == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleRegistration: null == vehicleRegistration
          ? _value.vehicleRegistration
          : vehicleRegistration // ignore: cast_nullable_to_non_nullable
              as String,
      totalAllocations: null == totalAllocations
          ? _value.totalAllocations
          : totalAllocations // ignore: cast_nullable_to_non_nullable
              as int,
      totalDays: null == totalDays
          ? _value.totalDays
          : totalDays // ignore: cast_nullable_to_non_nullable
              as int,
      totalMileage: null == totalMileage
          ? _value.totalMileage
          : totalMileage // ignore: cast_nullable_to_non_nullable
              as int,
      periodStart: null == periodStart
          ? _value.periodStart
          : periodStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      periodEnd: null == periodEnd
          ? _value.periodEnd
          : periodEnd // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UsageReportImpl implements _UsageReport {
  const _$UsageReportImpl(
      {required this.vehicleId,
      required this.vehicleRegistration,
      required this.totalAllocations,
      required this.totalDays,
      required this.totalMileage,
      required this.periodStart,
      required this.periodEnd});

  factory _$UsageReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$UsageReportImplFromJson(json);

  @override
  final String vehicleId;
  @override
  final String vehicleRegistration;
  @override
  final int totalAllocations;
  @override
  final int totalDays;
  @override
  final int totalMileage;
  @override
  final DateTime periodStart;
  @override
  final DateTime periodEnd;

  @override
  String toString() {
    return 'UsageReport(vehicleId: $vehicleId, vehicleRegistration: $vehicleRegistration, totalAllocations: $totalAllocations, totalDays: $totalDays, totalMileage: $totalMileage, periodStart: $periodStart, periodEnd: $periodEnd)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UsageReportImpl &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId) &&
            (identical(other.vehicleRegistration, vehicleRegistration) ||
                other.vehicleRegistration == vehicleRegistration) &&
            (identical(other.totalAllocations, totalAllocations) ||
                other.totalAllocations == totalAllocations) &&
            (identical(other.totalDays, totalDays) ||
                other.totalDays == totalDays) &&
            (identical(other.totalMileage, totalMileage) ||
                other.totalMileage == totalMileage) &&
            (identical(other.periodStart, periodStart) ||
                other.periodStart == periodStart) &&
            (identical(other.periodEnd, periodEnd) ||
                other.periodEnd == periodEnd));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, vehicleId, vehicleRegistration,
      totalAllocations, totalDays, totalMileage, periodStart, periodEnd);

  /// Create a copy of UsageReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UsageReportImplCopyWith<_$UsageReportImpl> get copyWith =>
      __$$UsageReportImplCopyWithImpl<_$UsageReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UsageReportImplToJson(
      this,
    );
  }
}

abstract class _UsageReport implements UsageReport {
  const factory _UsageReport(
      {required final String vehicleId,
      required final String vehicleRegistration,
      required final int totalAllocations,
      required final int totalDays,
      required final int totalMileage,
      required final DateTime periodStart,
      required final DateTime periodEnd}) = _$UsageReportImpl;

  factory _UsageReport.fromJson(Map<String, dynamic> json) =
      _$UsageReportImpl.fromJson;

  @override
  String get vehicleId;
  @override
  String get vehicleRegistration;
  @override
  int get totalAllocations;
  @override
  int get totalDays;
  @override
  int get totalMileage;
  @override
  DateTime get periodStart;
  @override
  DateTime get periodEnd;

  /// Create a copy of UsageReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UsageReportImplCopyWith<_$UsageReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
