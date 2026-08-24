// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cost_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CostReport _$CostReportFromJson(Map<String, dynamic> json) {
  return _CostReport.fromJson(json);
}

/// @nodoc
mixin _$CostReport {
  double get totalCost => throw _privateConstructorUsedError;
  Map<String, double> get costsByCategory => throw _privateConstructorUsedError;
  DateTime get periodStart => throw _privateConstructorUsedError;
  DateTime get periodEnd => throw _privateConstructorUsedError;

  /// Serializes this CostReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CostReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CostReportCopyWith<CostReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CostReportCopyWith<$Res> {
  factory $CostReportCopyWith(
          CostReport value, $Res Function(CostReport) then) =
      _$CostReportCopyWithImpl<$Res, CostReport>;
  @useResult
  $Res call(
      {double totalCost,
      Map<String, double> costsByCategory,
      DateTime periodStart,
      DateTime periodEnd});
}

/// @nodoc
class _$CostReportCopyWithImpl<$Res, $Val extends CostReport>
    implements $CostReportCopyWith<$Res> {
  _$CostReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CostReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCost = null,
    Object? costsByCategory = null,
    Object? periodStart = null,
    Object? periodEnd = null,
  }) {
    return _then(_value.copyWith(
      totalCost: null == totalCost
          ? _value.totalCost
          : totalCost // ignore: cast_nullable_to_non_nullable
              as double,
      costsByCategory: null == costsByCategory
          ? _value.costsByCategory
          : costsByCategory // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
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
abstract class _$$CostReportImplCopyWith<$Res>
    implements $CostReportCopyWith<$Res> {
  factory _$$CostReportImplCopyWith(
          _$CostReportImpl value, $Res Function(_$CostReportImpl) then) =
      __$$CostReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double totalCost,
      Map<String, double> costsByCategory,
      DateTime periodStart,
      DateTime periodEnd});
}

/// @nodoc
class __$$CostReportImplCopyWithImpl<$Res>
    extends _$CostReportCopyWithImpl<$Res, _$CostReportImpl>
    implements _$$CostReportImplCopyWith<$Res> {
  __$$CostReportImplCopyWithImpl(
      _$CostReportImpl _value, $Res Function(_$CostReportImpl) _then)
      : super(_value, _then);

  /// Create a copy of CostReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCost = null,
    Object? costsByCategory = null,
    Object? periodStart = null,
    Object? periodEnd = null,
  }) {
    return _then(_$CostReportImpl(
      totalCost: null == totalCost
          ? _value.totalCost
          : totalCost // ignore: cast_nullable_to_non_nullable
              as double,
      costsByCategory: null == costsByCategory
          ? _value._costsByCategory
          : costsByCategory // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
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
class _$CostReportImpl implements _CostReport {
  const _$CostReportImpl(
      {required this.totalCost,
      required final Map<String, double> costsByCategory,
      required this.periodStart,
      required this.periodEnd})
      : _costsByCategory = costsByCategory;

  factory _$CostReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$CostReportImplFromJson(json);

  @override
  final double totalCost;
  final Map<String, double> _costsByCategory;
  @override
  Map<String, double> get costsByCategory {
    if (_costsByCategory is EqualUnmodifiableMapView) return _costsByCategory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_costsByCategory);
  }

  @override
  final DateTime periodStart;
  @override
  final DateTime periodEnd;

  @override
  String toString() {
    return 'CostReport(totalCost: $totalCost, costsByCategory: $costsByCategory, periodStart: $periodStart, periodEnd: $periodEnd)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CostReportImpl &&
            (identical(other.totalCost, totalCost) ||
                other.totalCost == totalCost) &&
            const DeepCollectionEquality()
                .equals(other._costsByCategory, _costsByCategory) &&
            (identical(other.periodStart, periodStart) ||
                other.periodStart == periodStart) &&
            (identical(other.periodEnd, periodEnd) ||
                other.periodEnd == periodEnd));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalCost,
      const DeepCollectionEquality().hash(_costsByCategory),
      periodStart,
      periodEnd);

  /// Create a copy of CostReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CostReportImplCopyWith<_$CostReportImpl> get copyWith =>
      __$$CostReportImplCopyWithImpl<_$CostReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CostReportImplToJson(
      this,
    );
  }
}

abstract class _CostReport implements CostReport {
  const factory _CostReport(
      {required final double totalCost,
      required final Map<String, double> costsByCategory,
      required final DateTime periodStart,
      required final DateTime periodEnd}) = _$CostReportImpl;

  factory _CostReport.fromJson(Map<String, dynamic> json) =
      _$CostReportImpl.fromJson;

  @override
  double get totalCost;
  @override
  Map<String, double> get costsByCategory;
  @override
  DateTime get periodStart;
  @override
  DateTime get periodEnd;

  /// Create a copy of CostReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CostReportImplCopyWith<_$CostReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
