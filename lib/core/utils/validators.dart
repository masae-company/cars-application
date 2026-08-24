class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  static String? minLength(String? value, int length, {String? fieldName}) {
    if (value == null || value.length < length) {
      return '${fieldName ?? 'This field'} must be at least $length characters';
    }
    return null;
  }

  static String? positiveNumber(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    final number = double.tryParse(value);
    if (number == null || number <= 0) {
      return '${fieldName ?? 'This field'} must be a positive number';
    }
    return null;
  }

  static String? nonNegativeInteger(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    final number = int.tryParse(value);
    if (number == null || number < 0) {
      return '${fieldName ?? 'This field'} must be a non-negative integer';
    }
    return null;
  }

  static String? date(DateTime? value, {String? fieldName}) {
    if (value == null) {
      return '${fieldName ?? 'Date'} is required';
    }
    return null;
  }
}


