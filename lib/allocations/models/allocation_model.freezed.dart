// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'allocation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AllocationHistory _$AllocationHistoryFromJson(Map<String, dynamic> json) {
  return _AllocationHistory.fromJson(json);
}

/// @nodoc
mixin _$AllocationHistory {
  String get id => throw _privateConstructorUsedError;
  String get allocationId => throw _privateConstructorUsedError;
  AllocationStatus get status => throw _privateConstructorUsedError;
  String? get changedBy => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this AllocationHistory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AllocationHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AllocationHistoryCopyWith<AllocationHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AllocationHistoryCopyWith<$Res> {
  factory $AllocationHistoryCopyWith(
          AllocationHistory value, $Res Function(AllocationHistory) then) =
      _$AllocationHistoryCopyWithImpl<$Res, AllocationHistory>;
  @useResult
  $Res call(
      {String id,
      String allocationId,
      AllocationStatus status,
      String? changedBy,
      String? notes,
      DateTime createdAt});
}

/// @nodoc
class _$AllocationHistoryCopyWithImpl<$Res, $Val extends AllocationHistory>
    implements $AllocationHistoryCopyWith<$Res> {
  _$AllocationHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AllocationHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? allocationId = null,
    Object? status = null,
    Object? changedBy = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      allocationId: null == allocationId
          ? _value.allocationId
          : allocationId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AllocationStatus,
      changedBy: freezed == changedBy
          ? _value.changedBy
          : changedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AllocationHistoryImplCopyWith<$Res>
    implements $AllocationHistoryCopyWith<$Res> {
  factory _$$AllocationHistoryImplCopyWith(_$AllocationHistoryImpl value,
          $Res Function(_$AllocationHistoryImpl) then) =
      __$$AllocationHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String allocationId,
      AllocationStatus status,
      String? changedBy,
      String? notes,
      DateTime createdAt});
}

/// @nodoc
class __$$AllocationHistoryImplCopyWithImpl<$Res>
    extends _$AllocationHistoryCopyWithImpl<$Res, _$AllocationHistoryImpl>
    implements _$$AllocationHistoryImplCopyWith<$Res> {
  __$$AllocationHistoryImplCopyWithImpl(_$AllocationHistoryImpl _value,
      $Res Function(_$AllocationHistoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of AllocationHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? allocationId = null,
    Object? status = null,
    Object? changedBy = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$AllocationHistoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      allocationId: null == allocationId
          ? _value.allocationId
          : allocationId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AllocationStatus,
      changedBy: freezed == changedBy
          ? _value.changedBy
          : changedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AllocationHistoryImpl implements _AllocationHistory {
  const _$AllocationHistoryImpl(
      {required this.id,
      required this.allocationId,
      required this.status,
      this.changedBy,
      this.notes,
      required this.createdAt});

  factory _$AllocationHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$AllocationHistoryImplFromJson(json);

  @override
  final String id;
  @override
  final String allocationId;
  @override
  final AllocationStatus status;
  @override
  final String? changedBy;
  @override
  final String? notes;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'AllocationHistory(id: $id, allocationId: $allocationId, status: $status, changedBy: $changedBy, notes: $notes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AllocationHistoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.allocationId, allocationId) ||
                other.allocationId == allocationId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.changedBy, changedBy) ||
                other.changedBy == changedBy) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, allocationId, status, changedBy, notes, createdAt);

  /// Create a copy of AllocationHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AllocationHistoryImplCopyWith<_$AllocationHistoryImpl> get copyWith =>
      __$$AllocationHistoryImplCopyWithImpl<_$AllocationHistoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AllocationHistoryImplToJson(
      this,
    );
  }
}

abstract class _AllocationHistory implements AllocationHistory {
  const factory _AllocationHistory(
      {required final String id,
      required final String allocationId,
      required final AllocationStatus status,
      final String? changedBy,
      final String? notes,
      required final DateTime createdAt}) = _$AllocationHistoryImpl;

  factory _AllocationHistory.fromJson(Map<String, dynamic> json) =
      _$AllocationHistoryImpl.fromJson;

  @override
  String get id;
  @override
  String get allocationId;
  @override
  AllocationStatus get status;
  @override
  String? get changedBy;
  @override
  String? get notes;
  @override
  DateTime get createdAt;

  /// Create a copy of AllocationHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AllocationHistoryImplCopyWith<_$AllocationHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AllocationModel _$AllocationModelFromJson(Map<String, dynamic> json) {
  return _AllocationModel.fromJson(json);
}

/// @nodoc
mixin _$AllocationModel {
  String get id => throw _privateConstructorUsedError;
  String get vehicleId => throw _privateConstructorUsedError;
  String get allocatedTo => throw _privateConstructorUsedError;
  String get requestedBy => throw _privateConstructorUsedError;
  String? get approvedBy => throw _privateConstructorUsedError;
  AllocationStatus get status => throw _privateConstructorUsedError;
  DateTime get requestDate => throw _privateConstructorUsedError;
  DateTime? get approvalDate => throw _privateConstructorUsedError;
  DateTime? get handoverDate => throw _privateConstructorUsedError;
  DateTime? get returnDate => throw _privateConstructorUsedError;
  DateTime? get expectedReturnDate => throw _privateConstructorUsedError;
  int? get handoverMileage => throw _privateConstructorUsedError;
  int? get returnMileage => throw _privateConstructorUsedError;
  String? get handoverNotes => throw _privateConstructorUsedError;
  String? get returnNotes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  List<AllocationHistory> get history => throw _privateConstructorUsedError;

  /// Serializes this AllocationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AllocationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AllocationModelCopyWith<AllocationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AllocationModelCopyWith<$Res> {
  factory $AllocationModelCopyWith(
          AllocationModel value, $Res Function(AllocationModel) then) =
      _$AllocationModelCopyWithImpl<$Res, AllocationModel>;
  @useResult
  $Res call(
      {String id,
      String vehicleId,
      String allocatedTo,
      String requestedBy,
      String? approvedBy,
      AllocationStatus status,
      DateTime requestDate,
      DateTime? approvalDate,
      DateTime? handoverDate,
      DateTime? returnDate,
      DateTime? expectedReturnDate,
      int? handoverMileage,
      int? returnMileage,
      String? handoverNotes,
      String? returnNotes,
      DateTime createdAt,
      DateTime updatedAt,
      List<AllocationHistory> history});
}

/// @nodoc
class _$AllocationModelCopyWithImpl<$Res, $Val extends AllocationModel>
    implements $AllocationModelCopyWith<$Res> {
  _$AllocationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AllocationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vehicleId = null,
    Object? allocatedTo = null,
    Object? requestedBy = null,
    Object? approvedBy = freezed,
    Object? status = null,
    Object? requestDate = null,
    Object? approvalDate = freezed,
    Object? handoverDate = freezed,
    Object? returnDate = freezed,
    Object? expectedReturnDate = freezed,
    Object? handoverMileage = freezed,
    Object? returnMileage = freezed,
    Object? handoverNotes = freezed,
    Object? returnNotes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? history = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleId: null == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String,
      allocatedTo: null == allocatedTo
          ? _value.allocatedTo
          : allocatedTo // ignore: cast_nullable_to_non_nullable
              as String,
      requestedBy: null == requestedBy
          ? _value.requestedBy
          : requestedBy // ignore: cast_nullable_to_non_nullable
              as String,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AllocationStatus,
      requestDate: null == requestDate
          ? _value.requestDate
          : requestDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      approvalDate: freezed == approvalDate
          ? _value.approvalDate
          : approvalDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      handoverDate: freezed == handoverDate
          ? _value.handoverDate
          : handoverDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      returnDate: freezed == returnDate
          ? _value.returnDate
          : returnDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expectedReturnDate: freezed == expectedReturnDate
          ? _value.expectedReturnDate
          : expectedReturnDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      handoverMileage: freezed == handoverMileage
          ? _value.handoverMileage
          : handoverMileage // ignore: cast_nullable_to_non_nullable
              as int?,
      returnMileage: freezed == returnMileage
          ? _value.returnMileage
          : returnMileage // ignore: cast_nullable_to_non_nullable
              as int?,
      handoverNotes: freezed == handoverNotes
          ? _value.handoverNotes
          : handoverNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      returnNotes: freezed == returnNotes
          ? _value.returnNotes
          : returnNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      history: null == history
          ? _value.history
          : history // ignore: cast_nullable_to_non_nullable
              as List<AllocationHistory>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AllocationModelImplCopyWith<$Res>
    implements $AllocationModelCopyWith<$Res> {
  factory _$$AllocationModelImplCopyWith(_$AllocationModelImpl value,
          $Res Function(_$AllocationModelImpl) then) =
      __$$AllocationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String vehicleId,
      String allocatedTo,
      String requestedBy,
      String? approvedBy,
      AllocationStatus status,
      DateTime requestDate,
      DateTime? approvalDate,
      DateTime? handoverDate,
      DateTime? returnDate,
      DateTime? expectedReturnDate,
      int? handoverMileage,
      int? returnMileage,
      String? handoverNotes,
      String? returnNotes,
      DateTime createdAt,
      DateTime updatedAt,
      List<AllocationHistory> history});
}

/// @nodoc
class __$$AllocationModelImplCopyWithImpl<$Res>
    extends _$AllocationModelCopyWithImpl<$Res, _$AllocationModelImpl>
    implements _$$AllocationModelImplCopyWith<$Res> {
  __$$AllocationModelImplCopyWithImpl(
      _$AllocationModelImpl _value, $Res Function(_$AllocationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AllocationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vehicleId = null,
    Object? allocatedTo = null,
    Object? requestedBy = null,
    Object? approvedBy = freezed,
    Object? status = null,
    Object? requestDate = null,
    Object? approvalDate = freezed,
    Object? handoverDate = freezed,
    Object? returnDate = freezed,
    Object? expectedReturnDate = freezed,
    Object? handoverMileage = freezed,
    Object? returnMileage = freezed,
    Object? handoverNotes = freezed,
    Object? returnNotes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? history = null,
  }) {
    return _then(_$AllocationModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleId: null == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String,
      allocatedTo: null == allocatedTo
          ? _value.allocatedTo
          : allocatedTo // ignore: cast_nullable_to_non_nullable
              as String,
      requestedBy: null == requestedBy
          ? _value.requestedBy
          : requestedBy // ignore: cast_nullable_to_non_nullable
              as String,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AllocationStatus,
      requestDate: null == requestDate
          ? _value.requestDate
          : requestDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      approvalDate: freezed == approvalDate
          ? _value.approvalDate
          : approvalDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      handoverDate: freezed == handoverDate
          ? _value.handoverDate
          : handoverDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      returnDate: freezed == returnDate
          ? _value.returnDate
          : returnDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expectedReturnDate: freezed == expectedReturnDate
          ? _value.expectedReturnDate
          : expectedReturnDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      handoverMileage: freezed == handoverMileage
          ? _value.handoverMileage
          : handoverMileage // ignore: cast_nullable_to_non_nullable
              as int?,
      returnMileage: freezed == returnMileage
          ? _value.returnMileage
          : returnMileage // ignore: cast_nullable_to_non_nullable
              as int?,
      handoverNotes: freezed == handoverNotes
          ? _value.handoverNotes
          : handoverNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      returnNotes: freezed == returnNotes
          ? _value.returnNotes
          : returnNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      history: null == history
          ? _value._history
          : history // ignore: cast_nullable_to_non_nullable
              as List<AllocationHistory>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AllocationModelImpl implements _AllocationModel {
  const _$AllocationModelImpl(
      {required this.id,
      required this.vehicleId,
      required this.allocatedTo,
      required this.requestedBy,
      this.approvedBy,
      this.status = AllocationStatus.pending,
      required this.requestDate,
      this.approvalDate,
      this.handoverDate,
      this.returnDate,
      this.expectedReturnDate,
      this.handoverMileage,
      this.returnMileage,
      this.handoverNotes,
      this.returnNotes,
      required this.createdAt,
      required this.updatedAt,
      final List<AllocationHistory> history = const []})
      : _history = history;

  factory _$AllocationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AllocationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String vehicleId;
  @override
  final String allocatedTo;
  @override
  final String requestedBy;
  @override
  final String? approvedBy;
  @override
  @JsonKey()
  final AllocationStatus status;
  @override
  final DateTime requestDate;
  @override
  final DateTime? approvalDate;
  @override
  final DateTime? handoverDate;
  @override
  final DateTime? returnDate;
  @override
  final DateTime? expectedReturnDate;
  @override
  final int? handoverMileage;
  @override
  final int? returnMileage;
  @override
  final String? handoverNotes;
  @override
  final String? returnNotes;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final List<AllocationHistory> _history;
  @override
  @JsonKey()
  List<AllocationHistory> get history {
    if (_history is EqualUnmodifiableListView) return _history;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_history);
  }

  @override
  String toString() {
    return 'AllocationModel(id: $id, vehicleId: $vehicleId, allocatedTo: $allocatedTo, requestedBy: $requestedBy, approvedBy: $approvedBy, status: $status, requestDate: $requestDate, approvalDate: $approvalDate, handoverDate: $handoverDate, returnDate: $returnDate, expectedReturnDate: $expectedReturnDate, handoverMileage: $handoverMileage, returnMileage: $returnMileage, handoverNotes: $handoverNotes, returnNotes: $returnNotes, createdAt: $createdAt, updatedAt: $updatedAt, history: $history)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AllocationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId) &&
            (identical(other.allocatedTo, allocatedTo) ||
                other.allocatedTo == allocatedTo) &&
            (identical(other.requestedBy, requestedBy) ||
                other.requestedBy == requestedBy) &&
            (identical(other.approvedBy, approvedBy) ||
                other.approvedBy == approvedBy) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.requestDate, requestDate) ||
                other.requestDate == requestDate) &&
            (identical(other.approvalDate, approvalDate) ||
                other.approvalDate == approvalDate) &&
            (identical(other.handoverDate, handoverDate) ||
                other.handoverDate == handoverDate) &&
            (identical(other.returnDate, returnDate) ||
                other.returnDate == returnDate) &&
            (identical(other.expectedReturnDate, expectedReturnDate) ||
                other.expectedReturnDate == expectedReturnDate) &&
            (identical(other.handoverMileage, handoverMileage) ||
                other.handoverMileage == handoverMileage) &&
            (identical(other.returnMileage, returnMileage) ||
                other.returnMileage == returnMileage) &&
            (identical(other.handoverNotes, handoverNotes) ||
                other.handoverNotes == handoverNotes) &&
            (identical(other.returnNotes, returnNotes) ||
                other.returnNotes == returnNotes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._history, _history));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      vehicleId,
      allocatedTo,
      requestedBy,
      approvedBy,
      status,
      requestDate,
      approvalDate,
      handoverDate,
      returnDate,
      expectedReturnDate,
      handoverMileage,
      returnMileage,
      handoverNotes,
      returnNotes,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_history));

  /// Create a copy of AllocationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AllocationModelImplCopyWith<_$AllocationModelImpl> get copyWith =>
      __$$AllocationModelImplCopyWithImpl<_$AllocationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AllocationModelImplToJson(
      this,
    );
  }
}

abstract class _AllocationModel implements AllocationModel {
  const factory _AllocationModel(
      {required final String id,
      required final String vehicleId,
      required final String allocatedTo,
      required final String requestedBy,
      final String? approvedBy,
      final AllocationStatus status,
      required final DateTime requestDate,
      final DateTime? approvalDate,
      final DateTime? handoverDate,
      final DateTime? returnDate,
      final DateTime? expectedReturnDate,
      final int? handoverMileage,
      final int? returnMileage,
      final String? handoverNotes,
      final String? returnNotes,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final List<AllocationHistory> history}) = _$AllocationModelImpl;

  factory _AllocationModel.fromJson(Map<String, dynamic> json) =
      _$AllocationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get vehicleId;
  @override
  String get allocatedTo;
  @override
  String get requestedBy;
  @override
  String? get approvedBy;
  @override
  AllocationStatus get status;
  @override
  DateTime get requestDate;
  @override
  DateTime? get approvalDate;
  @override
  DateTime? get handoverDate;
  @override
  DateTime? get returnDate;
  @override
  DateTime? get expectedReturnDate;
  @override
  int? get handoverMileage;
  @override
  int? get returnMileage;
  @override
  String? get handoverNotes;
  @override
  String? get returnNotes;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  List<AllocationHistory> get history;

  /// Create a copy of AllocationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AllocationModelImplCopyWith<_$AllocationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
