enum ExpenseCategory {
  fuel,
  maintenance,
  repair,
  insurance,
  toll,
  parking,
  other;

  static ExpenseCategory? fromString(String? value) {
    if (value == null) return null;
    try {
      return ExpenseCategory.values.firstWhere(
        (category) => category.name == value.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  String get displayName {
    switch (this) {
      case ExpenseCategory.fuel:
        return 'Fuel';
      case ExpenseCategory.maintenance:
        return 'Maintenance';
      case ExpenseCategory.repair:
        return 'Repair';
      case ExpenseCategory.insurance:
        return 'Insurance';
      case ExpenseCategory.toll:
        return 'Toll';
      case ExpenseCategory.parking:
        return 'Parking';
      case ExpenseCategory.other:
        return 'Other';
    }
  }
}


