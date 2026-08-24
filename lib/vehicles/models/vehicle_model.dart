import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle_model.freezed.dart';

enum CarLocation {
  ahsaa,
  dammam,
  riyadh;

  static CarLocation? fromString(String? value) {
    if (value == null) return null;
    try {
      final normalizedValue = value.toLowerCase().trim();
      if (normalizedValue == 'ahsaa' || normalizedValue == 'الأحساء') {
        return CarLocation.ahsaa;
      } else if (normalizedValue == 'dammam' || normalizedValue == 'الدمام') {
        return CarLocation.dammam;
      } else if (normalizedValue == 'riyadh' || normalizedValue == 'الرياض') {
        return CarLocation.riyadh;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  String get displayName {
    switch (this) {
      case CarLocation.ahsaa:
        return 'Ahsaa';
      case CarLocation.dammam:
        return 'Dammam';
      case CarLocation.riyadh:
        return 'Riyadh';
    }
  }

  String toDbValue() {
    switch (this) {
      case CarLocation.ahsaa:
        return 'Ahsaa';
      case CarLocation.dammam:
        return 'Dammam';
      case CarLocation.riyadh:
        return 'Riyadh';
    }
  }
}

enum VehicleStatus {
  active,
  workshop,
  insurance;

  static VehicleStatus fromString(String? value) {
    if (value == null) return VehicleStatus.active;
    switch (value.toLowerCase().trim()) {
      case 'workshop':
      case 'في الورشة':
        return VehicleStatus.workshop;
      case 'insurance':
      case 'في الضمان':
        return VehicleStatus.insurance;
      case 'active':
      default:
        return VehicleStatus.active;
    }
  }

  String toDbValue() {
    switch (this) {
      case VehicleStatus.active:
        return 'active';
      case VehicleStatus.workshop:
        return 'workshop';
      case VehicleStatus.insurance:
        return 'insurance';
    }
  }
}

@freezed
class VehicleModel with _$VehicleModel {
  const VehicleModel._();
  
  const factory VehicleModel({
    required String id,
    required String model,
    required String number, // Registration number
    required String ownerId,
    Map<String, dynamic>? image,
    String? description,
    CarLocation? location,
    @Default(false) bool isNew,
    @Default(VehicleStatus.active) VehicleStatus status,
    @Default(false) bool isAccident,
    String? accidentReportUrl,
    int? accidentDeductibleRate,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? make,
    String? color,
    int? year,
  }) = _VehicleModel;

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    // print('📄 [VehicleModel] fromJson called');
    
    try {
      // Handle location enum conversion - database stores 'Ahsaa' or 'Dammam'
      final locationValue = json['location'] as String?;
      final location = CarLocation.fromString(locationValue);
      
      // Handle status enum conversion
      final statusValue = json['status'] as String?;
      final status = VehicleStatus.fromString(statusValue);
      
      // Handle image JSONB field - can be null, Map, or already parsed
      Map<String, dynamic>? image;
      final imageValue = json['image'];
      if (imageValue != null) {
        if (imageValue is Map) {
          image = Map<String, dynamic>.from(imageValue);
        } else if (imageValue is String) {
          // If it's a string, it might be JSON that needs parsing
          // For now, we'll treat it as null if it's not a Map
          image = null;
        }
      }
      
      // Handle timestamp parsing - Supabase returns ISO 8601 strings
      DateTime parseTimestamp(dynamic value) {
        if (value == null) {
          return DateTime.now();
        }
        if (value is DateTime) {
          return value;
        }
        if (value is String) {
          try {
            return DateTime.parse(value);
          } catch (e) {
            return DateTime.now();
          }
        }
        return DateTime.now();
      }
      
      return VehicleModel(
        id: json['id'] as String,
        model: json['model'] as String,
        number: json['number'] as String,
        ownerId: json['owner_id'] as String,
        image: image,
        description: json['description'] as String?,
        location: location,
        isNew: json['is_new'] as bool? ?? false,
        status: status,
        isAccident: json['is_accident'] as bool? ?? false,
        accidentReportUrl: json['accident_report_url'] as String?,
        accidentDeductibleRate: json['accident_deductible_rate'] as int?,
        createdAt: parseTimestamp(json['created_at']),
        updatedAt: parseTimestamp(json['updated_at']),
        make: json['make'] as String?,
        color: json['color'] as String?,
        year: json['year'] as int?,
      );
    } catch (e, stack) {
      print('📄 [VehicleModel] ERROR in fromJson: $e');
      print('📄 [VehicleModel] Stack trace: $stack');
      rethrow;
    }
  }

  /// Returns formatted make with proper capitalization (title case)
  /// Examples: "TOYOTA" -> "Toyota", "toyota" -> "Toyota"
  String? get formattedMake {
    if (make == null || make!.isEmpty) return null;
    return _toTitleCase(make!);
  }

  /// Returns formatted model with proper capitalization (title case)
  /// Examples: "CAMRY" -> "Camry", "double-cabine" -> "Double-Cabine"
  String get formattedModel {
    return _toTitleCase(model);
  }

  /// Returns formatted color with proper capitalization (title case)
  /// Examples: "WHITE" -> "White", "red" -> "Red"
  String? get formattedColor {
    if (color == null || color!.isEmpty) return null;
    return _toTitleCase(color!);
  }

  /// Converts a string to title case (capitalize first letter of each word)
  static String _toTitleCase(String text) {
    if (text.isEmpty) return text;
    
    // Split by spaces and hyphens, but keep the separators
    final parts = <String>[];
    final buffer = StringBuffer();
    
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      if (char == ' ' || char == '-') {
        if (buffer.isNotEmpty) {
          parts.add(buffer.toString());
          buffer.clear();
        }
        parts.add(char);
      } else {
        buffer.write(char);
      }
    }
    
    if (buffer.isNotEmpty) {
      parts.add(buffer.toString());
    }
    
    final result = parts.map((part) {
      // If it's a separator, keep it as is
      if (part == ' ' || part == '-') {
        return part;
      }
      
      // Convert word to title case
      if (part.length == 1) {
        return part.toUpperCase();
      }
      
      return part[0].toUpperCase() + part.substring(1).toLowerCase();
    }).join();
    
    return result;
  }
}

extension VehicleModelX on VehicleModel {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model': model,
      'number': number,
      'owner_id': ownerId,
      'image': image,
      'description': description,
      'location': location?.toDbValue(),
      'is_new': isNew,
      'status': status.toDbValue(),
      'is_accident': isAccident,
      'accident_report_url': accidentReportUrl,
      'accident_deductible_rate': accidentDeductibleRate,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'make': make,
      'color': color,
      'year': year,
    };
  }
}



