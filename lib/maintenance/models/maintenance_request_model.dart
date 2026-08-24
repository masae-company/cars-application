import 'package:freezed_annotation/freezed_annotation.dart';

part 'maintenance_request_model.freezed.dart';

enum MaintenanceRequestStatus {
  pending,
  inProgress,
  completed;

  static MaintenanceRequestStatus? fromString(String? value) {
    if (value == null) return null;
    try {
      switch (value.toLowerCase()) {
        case 'pending':
          return MaintenanceRequestStatus.pending;
        case 'in_progress':
          return MaintenanceRequestStatus.inProgress;
        case 'completed':
          return MaintenanceRequestStatus.completed;
        default:
          return null;
      }
    } catch (e) {
      return null;
    }
  }

  String get displayName {
    switch (this) {
      case MaintenanceRequestStatus.pending:
        return 'Pending';
      case MaintenanceRequestStatus.inProgress:
        return 'In Progress';
      case MaintenanceRequestStatus.completed:
        return 'Completed';
    }
  }

  String toDbValue() {
    switch (this) {
      case MaintenanceRequestStatus.pending:
        return 'pending';
      case MaintenanceRequestStatus.inProgress:
        return 'in_progress';
      case MaintenanceRequestStatus.completed:
        return 'completed';
    }
  }
}

@freezed
class MaintenanceRequestModel with _$MaintenanceRequestModel {
  const factory MaintenanceRequestModel({
    required String id,
    required String carId,
    required DateTime requestedAt,
    DateTime? completedAt,
    String? notes,
    int? oilChangePreviousKm,
    int? oilChangeCurrentKm,
    DateTime? brakePadsLastChanged,
    DateTime? sparkPlugsLastChanged,
    DateTime? tyresLastChanged,
    @Default(false) bool acService,
    @Default(false) bool lightsService,
    @Default(false) bool tyreStackingService,
    @Default([]) List<String> tyresPositions,
    @Default(MaintenanceRequestStatus.pending) MaintenanceRequestStatus status,
    DateTime? inProgressAt,
    String? invoiceUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MaintenanceRequestModel;

  factory MaintenanceRequestModel.fromJson(Map<String, dynamic> json) {
    // Handle status enum conversion
    final statusValue = json['status'] as String?;
    final status = statusValue != null
        ? MaintenanceRequestStatus.fromString(statusValue)
        : MaintenanceRequestStatus.pending;
    
    return MaintenanceRequestModel(
      id: json['id'] as String,
      carId: json['car_id'] as String,
      requestedAt: DateTime.parse(json['requested_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      notes: json['notes'] as String?,
      oilChangePreviousKm: json['oil_change_previous_km'] as int?,
      oilChangeCurrentKm: json['oil_change_current_km'] as int?,
      brakePadsLastChanged: json['brake_pads_last_changed'] != null
          ? DateTime.parse(json['brake_pads_last_changed'] as String)
          : null,
      sparkPlugsLastChanged: json['spark_plugs_last_changed'] != null
          ? DateTime.parse(json['spark_plugs_last_changed'] as String)
          : null,
      tyresLastChanged: json['tyres_last_changed'] != null
          ? DateTime.parse(json['tyres_last_changed'] as String)
          : null,
      acService: json['ac_service'] as bool? ?? false,
      lightsService: json['lights_service'] as bool? ?? false,
      tyreStackingService: json['tyre_stacking_service'] as bool? ?? false,
      tyresPositions: json['tyres_positions'] != null
          ? List<String>.from(json['tyres_positions'] as List)
          : [],
      status: status ?? MaintenanceRequestStatus.pending,
      inProgressAt: json['in_progress_at'] != null
          ? DateTime.parse(json['in_progress_at'] as String)
          : null,
      invoiceUrl: json['invoice_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

extension MaintenanceRequestModelX on MaintenanceRequestModel {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'car_id': carId,
      'requested_at': requestedAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'notes': notes,
      'oil_change_previous_km': oilChangePreviousKm,
      'oil_change_current_km': oilChangeCurrentKm,
      'brake_pads_last_changed': brakePadsLastChanged?.toIso8601String(),
      'spark_plugs_last_changed': sparkPlugsLastChanged?.toIso8601String(),
      'tyres_last_changed': tyresLastChanged?.toIso8601String(),
      'ac_service': acService,
      'lights_service': lightsService,
      'tyre_stacking_service': tyreStackingService,
      'tyres_positions': tyresPositions,
      'status': status.toDbValue(),
      'in_progress_at': inProgressAt?.toIso8601String(),
      'invoice_url': invoiceUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

