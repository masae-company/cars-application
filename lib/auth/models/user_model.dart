import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';

enum UserRole {
  employee,
  carsAdmin,
  accountant,
  warehouseKeeper,
  superAdmin;

  static UserRole? fromString(String? value) {
    if (value == null) return null;
    try {
      switch (value.toLowerCase()) {
        case 'employee':
          return UserRole.employee;
        case 'cars_admin':
          return UserRole.carsAdmin;
        case 'accountant':
          return UserRole.accountant;
        case 'warehouse_keeper':
          return UserRole.warehouseKeeper;
        case 'super_admin':
          return UserRole.superAdmin;
        default:
          return null;
      }
    } catch (e) {
      return null;
    }
  }

  String get displayName {
    switch (this) {
      case UserRole.employee:
        return 'Employee';
      case UserRole.carsAdmin:
        return 'Cars Admin';
      case UserRole.accountant:
        return 'Accountant';
      case UserRole.warehouseKeeper:
        return 'Warehouse Keeper';
      case UserRole.superAdmin:
        return 'Super Admin';
    }
  }

  String toDbValue() {
    switch (this) {
      case UserRole.employee:
        return 'employee';
      case UserRole.carsAdmin:
        return 'cars_admin';
      case UserRole.accountant:
        return 'accountant';
      case UserRole.warehouseKeeper:
        return 'warehouse_keeper';
      case UserRole.superAdmin:
        return 'super_admin';
    }
  }

  bool get canManageVehicles => 
      this == UserRole.superAdmin || 
      this == UserRole.carsAdmin;
  bool get canViewAllocations => 
      this == UserRole.superAdmin || 
      this == UserRole.accountant;
  bool get canApproveAllocations => 
      this == UserRole.superAdmin || 
      this == UserRole.carsAdmin;
  bool get canManageMaintenanceRequests => 
      this == UserRole.superAdmin || 
      this == UserRole.carsAdmin;
  bool get canViewReports => 
      this == UserRole.superAdmin || 
      this == UserRole.accountant || 
      this == UserRole.carsAdmin;
  bool get canManageExpenses => 
      this == UserRole.superAdmin || 
      this == UserRole.accountant;
  bool get canViewAllData => 
      this == UserRole.superAdmin;
}

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    String? name,
    String? avatar,
    @Default(UserRole.employee) UserRole role,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle role parsing manually to support database format
    final roleString = json['role'] as String?;
    final role = UserRole.fromString(roleString) ?? UserRole.employee;
    
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      role: role,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }
}

extension UserModelX on UserModel {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'role': role.toDbValue(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

