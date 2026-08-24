class OilChangeProgressModel {
  final String id;
  final String carId;
  final int currentKilometers;
  final int lastOilChangeKilometers;
  final int nextOilChangeKilometers;
  final DateTime? lastUpdated;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OilChangeProgressModel({
    required this.id,
    required this.carId,
    required this.currentKilometers,
    required this.lastOilChangeKilometers,
    required this.nextOilChangeKilometers,
    this.lastUpdated,
    this.createdAt,
    this.updatedAt,
  });

  /// Calculate progress percentage (0.0 to 1.0)
  double get progress {
    final totalInterval = nextOilChangeKilometers - lastOilChangeKilometers;
    if (totalInterval <= 0) return 0.0;
    
    final currentProgress = currentKilometers - lastOilChangeKilometers;
    final progressRatio = currentProgress / totalInterval;
    
    return progressRatio.clamp(0.0, 1.5); // Allow up to 150% for overdue
  }

  /// Check if oil change is overdue
  bool get isOverdue => currentKilometers >= nextOilChangeKilometers;

  /// Get remaining kilometers until next oil change
  int get remainingKilometers {
    final remaining = nextOilChangeKilometers - currentKilometers;
    return remaining > 0 ? remaining : 0;
  }

  /// Get kilometers overdue (0 if not overdue)
  int get overdueKilometers {
    final overdue = currentKilometers - nextOilChangeKilometers;
    return overdue > 0 ? overdue : 0;
  }

  factory OilChangeProgressModel.fromJson(Map<String, dynamic> json) {
    return OilChangeProgressModel(
      id: json['id'] as String,
      carId: json['car_id'] as String,
      currentKilometers: json['current_kilometers'] as int? ?? 0,
      lastOilChangeKilometers: json['last_oil_change_kilometers'] as int? ?? 0,
      nextOilChangeKilometers: json['next_oil_change_kilometers'] as int? ?? 5000,
      lastUpdated: json['last_updated'] != null
          ? DateTime.parse(json['last_updated'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'car_id': carId,
      'current_kilometers': currentKilometers,
      'last_oil_change_kilometers': lastOilChangeKilometers,
      'next_oil_change_kilometers': nextOilChangeKilometers,
      'last_updated': lastUpdated?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  OilChangeProgressModel copyWith({
    String? id,
    String? carId,
    int? currentKilometers,
    int? lastOilChangeKilometers,
    int? nextOilChangeKilometers,
    DateTime? lastUpdated,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OilChangeProgressModel(
      id: id ?? this.id,
      carId: carId ?? this.carId,
      currentKilometers: currentKilometers ?? this.currentKilometers,
      lastOilChangeKilometers: lastOilChangeKilometers ?? this.lastOilChangeKilometers,
      nextOilChangeKilometers: nextOilChangeKilometers ?? this.nextOilChangeKilometers,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
