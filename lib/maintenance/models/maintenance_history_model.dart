import 'package:freezed_annotation/freezed_annotation.dart';

part 'maintenance_history_model.freezed.dart';

enum MaintenanceType {
  oilChange,
  brakePads,
  sparkPlugs,
  tyres,
  ac,
  lights,
  tyreStacking,
  other;

  static MaintenanceType? fromString(String? value) {
    if (value == null) return null;
    try {
      // Database stores: 'oilChange', 'brakePads', 'sparkPlugs', 'tyres', 'ac', 'lights', 'tyreStacking', 'other'
      switch (value) {
        case 'oilChange':
          return MaintenanceType.oilChange;
        case 'brakePads':
          return MaintenanceType.brakePads;
        case 'sparkPlugs':
          return MaintenanceType.sparkPlugs;
        case 'tyres':
          return MaintenanceType.tyres;
        case 'ac':
          return MaintenanceType.ac;
        case 'lights':
          return MaintenanceType.lights;
        case 'tyreStacking':
          return MaintenanceType.tyreStacking;
        case 'other':
          return MaintenanceType.other;
        default:
          return null;
      }
    } catch (e) {
      return null;
    }
  }

  String get displayName {
    switch (this) {
      case MaintenanceType.oilChange:
        return 'Oil Change';
      case MaintenanceType.brakePads:
        return 'Brake Pads';
      case MaintenanceType.sparkPlugs:
        return 'Spark Plugs';
      case MaintenanceType.tyres:
        return 'Tyres';
      case MaintenanceType.ac:
        return 'AC';
      case MaintenanceType.lights:
        return 'Lights';
      case MaintenanceType.tyreStacking:
        return 'Tyre Stacking';
      case MaintenanceType.other:
        return 'Other';
    }
  }

  String toDbValue() {
    switch (this) {
      case MaintenanceType.oilChange:
        return 'oilChange';
      case MaintenanceType.brakePads:
        return 'brakePads';
      case MaintenanceType.sparkPlugs:
        return 'sparkPlugs';
      case MaintenanceType.tyres:
        return 'tyres';
      case MaintenanceType.ac:
        return 'ac';
      case MaintenanceType.lights:
        return 'lights';
      case MaintenanceType.tyreStacking:
        return 'tyreStacking';
      case MaintenanceType.other:
        return 'other';
    }
  }
}

enum ServiceCenterType {
  authorizedWorkshop,
  unauthorizedWorkshop,
  dealership;

  static ServiceCenterType? fromString(String? value) {
    if (value == null) return null;
    try {
      switch (value.toLowerCase()) {
        case 'authorized_workshop':
          return ServiceCenterType.authorizedWorkshop;
        case 'unauthorized_workshop':
          return ServiceCenterType.unauthorizedWorkshop;
        case 'dealership':
          return ServiceCenterType.dealership;
        default:
          return null;
      }
    } catch (e) {
      return null;
    }
  }

  String get displayName {
    switch (this) {
      case ServiceCenterType.authorizedWorkshop:
        return 'Authorized Workshop';
      case ServiceCenterType.unauthorizedWorkshop:
        return 'Unauthorized Workshop';
      case ServiceCenterType.dealership:
        return 'Dealership';
    }
  }

  String toDbValue() {
    switch (this) {
      case ServiceCenterType.authorizedWorkshop:
        return 'authorized_workshop';
      case ServiceCenterType.unauthorizedWorkshop:
        return 'unauthorized_workshop';
      case ServiceCenterType.dealership:
        return 'dealership';
    }
  }
}

@freezed
class MaintenanceHistoryModel with _$MaintenanceHistoryModel {
  const factory MaintenanceHistoryModel({
    required String id,
    required String carId,
    required MaintenanceType maintenanceType,
    required DateTime performedAt,
    required String performedBy,
    String? notes,
    int? kilometers,
    double? cost,
    DateTime? nextDueDate,
    int? nextDueKilometers,
    String? requestId,
    ServiceCenterType? serviceCenterType,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MaintenanceHistoryModel;

  factory MaintenanceHistoryModel.fromJson(Map<String, dynamic> json) {
    // Handle enum conversions - database stores exact enum values
    final maintenanceTypeValue = json['maintenance_type'] as String?;
    final maintenanceType = maintenanceTypeValue != null
        ? MaintenanceType.fromString(maintenanceTypeValue)
        : MaintenanceType.other;
    
    final serviceCenterTypeValue = json['service_center_type'] as String?;
    final serviceCenterType = serviceCenterTypeValue != null
        ? ServiceCenterType.fromString(serviceCenterTypeValue)
        : null;
    
    return MaintenanceHistoryModel(
      id: json['id'] as String,
      carId: json['car_id'] as String,
      maintenanceType: maintenanceType ?? MaintenanceType.other,
      performedAt: DateTime.parse(json['performed_at'] as String),
      performedBy: json['performed_by'] as String,
      notes: json['notes'] as String?,
      kilometers: json['kilometers'] as int?,
      cost: json['cost'] != null ? (json['cost'] as num).toDouble() : null,
      nextDueDate: json['next_due_date'] != null
          ? DateTime.parse(json['next_due_date'] as String)
          : null,
      nextDueKilometers: json['next_due_kilometers'] as int?,
      requestId: json['request_id'] as String?,
      serviceCenterType: serviceCenterType,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

extension MaintenanceHistoryModelX on MaintenanceHistoryModel {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'car_id': carId,
      'maintenance_type': maintenanceType.toDbValue(),
      'performed_at': performedAt.toIso8601String(),
      'performed_by': performedBy,
      'notes': notes,
      'kilometers': kilometers,
      'cost': cost,
      'next_due_date': nextDueDate?.toIso8601String(),
      'next_due_kilometers': nextDueKilometers,
      'request_id': requestId,
      'service_center_type': serviceCenterType?.toDbValue(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

