// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tool_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ToolModel _$ToolModelFromJson(Map<String, dynamic> json) {
  return _ToolModel.fromJson(json);
}

/// @nodoc
mixin _$ToolModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_id')
  String get ownerId => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ToolModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ToolModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ToolModelCopyWith<ToolModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToolModelCopyWith<$Res> {
  factory $ToolModelCopyWith(ToolModel value, $Res Function(ToolModel) then) =
      _$ToolModelCopyWithImpl<$Res, ToolModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'owner_id') String ownerId,
      String? image,
      String? description,
      String? category,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$ToolModelCopyWithImpl<$Res, $Val extends ToolModel>
    implements $ToolModelCopyWith<$Res> {
  _$ToolModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ToolModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? ownerId = null,
    Object? image = freezed,
    Object? description = freezed,
    Object? category = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ToolModelImplCopyWith<$Res>
    implements $ToolModelCopyWith<$Res> {
  factory _$$ToolModelImplCopyWith(
          _$ToolModelImpl value, $Res Function(_$ToolModelImpl) then) =
      __$$ToolModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'owner_id') String ownerId,
      String? image,
      String? description,
      String? category,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$ToolModelImplCopyWithImpl<$Res>
    extends _$ToolModelCopyWithImpl<$Res, _$ToolModelImpl>
    implements _$$ToolModelImplCopyWith<$Res> {
  __$$ToolModelImplCopyWithImpl(
      _$ToolModelImpl _value, $Res Function(_$ToolModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ToolModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? ownerId = null,
    Object? image = freezed,
    Object? description = freezed,
    Object? category = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ToolModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
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
@JsonSerializable()
class _$ToolModelImpl implements _ToolModel {
  const _$ToolModelImpl(
      {required this.id,
      required this.name,
      @JsonKey(name: 'owner_id') required this.ownerId,
      this.image,
      this.description,
      this.category,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$ToolModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ToolModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey(name: 'owner_id')
  final String ownerId;
  @override
  final String? image;
  @override
  final String? description;
  @override
  final String? category;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ToolModel(id: $id, name: $name, ownerId: $ownerId, image: $image, description: $description, category: $category, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToolModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, ownerId, image,
      description, category, createdAt, updatedAt);

  /// Create a copy of ToolModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ToolModelImplCopyWith<_$ToolModelImpl> get copyWith =>
      __$$ToolModelImplCopyWithImpl<_$ToolModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ToolModelImplToJson(
      this,
    );
  }
}

abstract class _ToolModel implements ToolModel {
  const factory _ToolModel(
          {required final String id,
          required final String name,
          @JsonKey(name: 'owner_id') required final String ownerId,
          final String? image,
          final String? description,
          final String? category,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$ToolModelImpl;

  factory _ToolModel.fromJson(Map<String, dynamic> json) =
      _$ToolModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'owner_id')
  String get ownerId;
  @override
  String? get image;
  @override
  String? get description;
  @override
  String? get category;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of ToolModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ToolModelImplCopyWith<_$ToolModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
