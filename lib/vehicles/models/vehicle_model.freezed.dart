// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$VehicleModel {
  String get id => throw _privateConstructorUsedError;
  String get model => throw _privateConstructorUsedError;
  String get number =>
      throw _privateConstructorUsedError; // Registration number
  String get ownerId => throw _privateConstructorUsedError;
  Map<String, dynamic>? get image => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  CarLocation? get location => throw _privateConstructorUsedError;
  bool get isNew => throw _privateConstructorUsedError;
  VehicleStatus get status => throw _privateConstructorUsedError;
  bool get isAccident => throw _privateConstructorUsedError;
  String? get accidentReportUrl => throw _privateConstructorUsedError;
  int? get accidentDeductibleRate => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get make => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  int? get year => throw _privateConstructorUsedError;

  /// Create a copy of VehicleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VehicleModelCopyWith<VehicleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VehicleModelCopyWith<$Res> {
  factory $VehicleModelCopyWith(
          VehicleModel value, $Res Function(VehicleModel) then) =
      _$VehicleModelCopyWithImpl<$Res, VehicleModel>;
  @useResult
  $Res call(
      {String id,
      String model,
      String number,
      String ownerId,
      Map<String, dynamic>? image,
      String? description,
      CarLocation? location,
      bool isNew,
      VehicleStatus status,
      bool isAccident,
      String? accidentReportUrl,
      int? accidentDeductibleRate,
      DateTime createdAt,
      DateTime updatedAt,
      String? make,
      String? color,
      int? year});
}

/// @nodoc
class _$VehicleModelCopyWithImpl<$Res, $Val extends VehicleModel>
    implements $VehicleModelCopyWith<$Res> {
  _$VehicleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VehicleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? model = null,
    Object? number = null,
    Object? ownerId = null,
    Object? image = freezed,
    Object? description = freezed,
    Object? location = freezed,
    Object? isNew = null,
    Object? status = null,
    Object? isAccident = null,
    Object? accidentReportUrl = freezed,
    Object? accidentDeductibleRate = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? make = freezed,
    Object? color = freezed,
    Object? year = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      number: null == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as CarLocation?,
      isNew: null == isNew
          ? _value.isNew
          : isNew // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as VehicleStatus,
      isAccident: null == isAccident
          ? _value.isAccident
          : isAccident // ignore: cast_nullable_to_non_nullable
              as bool,
      accidentReportUrl: freezed == accidentReportUrl
          ? _value.accidentReportUrl
          : accidentReportUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      accidentDeductibleRate: freezed == accidentDeductibleRate
          ? _value.accidentDeductibleRate
          : accidentDeductibleRate // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      make: freezed == make
          ? _value.make
          : make // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      year: freezed == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VehicleModelImplCopyWith<$Res>
    implements $VehicleModelCopyWith<$Res> {
  factory _$$VehicleModelImplCopyWith(
          _$VehicleModelImpl value, $Res Function(_$VehicleModelImpl) then) =
      __$$VehicleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String model,
      String number,
      String ownerId,
      Map<String, dynamic>? image,
      String? description,
      CarLocation? location,
      bool isNew,
      VehicleStatus status,
      bool isAccident,
      String? accidentReportUrl,
      int? accidentDeductibleRate,
      DateTime createdAt,
      DateTime updatedAt,
      String? make,
      String? color,
      int? year});
}

/// @nodoc
class __$$VehicleModelImplCopyWithImpl<$Res>
    extends _$VehicleModelCopyWithImpl<$Res, _$VehicleModelImpl>
    implements _$$VehicleModelImplCopyWith<$Res> {
  __$$VehicleModelImplCopyWithImpl(
      _$VehicleModelImpl _value, $Res Function(_$VehicleModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of VehicleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? model = null,
    Object? number = null,
    Object? ownerId = null,
    Object? image = freezed,
    Object? description = freezed,
    Object? location = freezed,
    Object? isNew = null,
    Object? status = null,
    Object? isAccident = null,
    Object? accidentReportUrl = freezed,
    Object? accidentDeductibleRate = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? make = freezed,
    Object? color = freezed,
    Object? year = freezed,
  }) {
    return _then(_$VehicleModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      number: null == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      image: freezed == image
          ? _value._image
          : image // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as CarLocation?,
      isNew: null == isNew
          ? _value.isNew
          : isNew // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as VehicleStatus,
      isAccident: null == isAccident
          ? _value.isAccident
          : isAccident // ignore: cast_nullable_to_non_nullable
              as bool,
      accidentReportUrl: freezed == accidentReportUrl
          ? _value.accidentReportUrl
          : accidentReportUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      accidentDeductibleRate: freezed == accidentDeductibleRate
          ? _value.accidentDeductibleRate
          : accidentDeductibleRate // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      make: freezed == make
          ? _value.make
          : make // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      year: freezed == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$VehicleModelImpl extends _VehicleModel {
  const _$VehicleModelImpl(
      {required this.id,
      required this.model,
      required this.number,
      required this.ownerId,
      final Map<String, dynamic>? image,
      this.description,
      this.location,
      this.isNew = false,
      this.status = VehicleStatus.active,
      this.isAccident = false,
      this.accidentReportUrl,
      this.accidentDeductibleRate,
      required this.createdAt,
      required this.updatedAt,
      this.make,
      this.color,
      this.year})
      : _image = image,
        super._();

  @override
  final String id;
  @override
  final String model;
  @override
  final String number;
// Registration number
  @override
  final String ownerId;
  final Map<String, dynamic>? _image;
  @override
  Map<String, dynamic>? get image {
    final value = _image;
    if (value == null) return null;
    if (_image is EqualUnmodifiableMapView) return _image;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? description;
  @override
  final CarLocation? location;
  @override
  @JsonKey()
  final bool isNew;
  @override
  @JsonKey()
  final VehicleStatus status;
  @override
  @JsonKey()
  final bool isAccident;
  @override
  final String? accidentReportUrl;
  @override
  final int? accidentDeductibleRate;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? make;
  @override
  final String? color;
  @override
  final int? year;

  @override
  String toString() {
    return 'VehicleModel(id: $id, model: $model, number: $number, ownerId: $ownerId, image: $image, description: $description, location: $location, isNew: $isNew, status: $status, isAccident: $isAccident, accidentReportUrl: $accidentReportUrl, accidentDeductibleRate: $accidentDeductibleRate, createdAt: $createdAt, updatedAt: $updatedAt, make: $make, color: $color, year: $year)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VehicleModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            const DeepCollectionEquality().equals(other._image, _image) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.isNew, isNew) || other.isNew == isNew) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isAccident, isAccident) ||
                other.isAccident == isAccident) &&
            (identical(other.accidentReportUrl, accidentReportUrl) ||
                other.accidentReportUrl == accidentReportUrl) &&
            (identical(other.accidentDeductibleRate, accidentDeductibleRate) ||
                other.accidentDeductibleRate == accidentDeductibleRate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.make, make) || other.make == make) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.year, year) || other.year == year));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      model,
      number,
      ownerId,
      const DeepCollectionEquality().hash(_image),
      description,
      location,
      isNew,
      status,
      isAccident,
      accidentReportUrl,
      accidentDeductibleRate,
      createdAt,
      updatedAt,
      make,
      color,
      year);

  /// Create a copy of VehicleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VehicleModelImplCopyWith<_$VehicleModelImpl> get copyWith =>
      __$$VehicleModelImplCopyWithImpl<_$VehicleModelImpl>(this, _$identity);
}

abstract class _VehicleModel extends VehicleModel {
  const factory _VehicleModel(
      {required final String id,
      required final String model,
      required final String number,
      required final String ownerId,
      final Map<String, dynamic>? image,
      final String? description,
      final CarLocation? location,
      final bool isNew,
      final VehicleStatus status,
      final bool isAccident,
      final String? accidentReportUrl,
      final int? accidentDeductibleRate,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final String? make,
      final String? color,
      final int? year}) = _$VehicleModelImpl;
  const _VehicleModel._() : super._();

  @override
  String get id;
  @override
  String get model;
  @override
  String get number; // Registration number
  @override
  String get ownerId;
  @override
  Map<String, dynamic>? get image;
  @override
  String? get description;
  @override
  CarLocation? get location;
  @override
  bool get isNew;
  @override
  VehicleStatus get status;
  @override
  bool get isAccident;
  @override
  String? get accidentReportUrl;
  @override
  int? get accidentDeductibleRate;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String? get make;
  @override
  String? get color;
  @override
  int? get year;

  /// Create a copy of VehicleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VehicleModelImplCopyWith<_$VehicleModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
