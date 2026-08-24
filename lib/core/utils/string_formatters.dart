/// String formatting utilities
class StringFormatters {
  /// Converts a string to title case (capitalize first letter of each word)
  /// Examples:
  /// - "TOYOTA" -> "Toyota"
  /// - "toyota" -> "Toyota"
  /// - "Toyota" -> "Toyota"
  /// - "DOUBLE-CABINE" -> "Double-Cabine"
  /// - "mini-bus" -> "Mini-Bus"
  static String toTitleCase(String text) {
    if (text.isEmpty) return text;
    
    // Split by spaces and hyphens, but keep the separators
    final words = text.split(RegExp(r'(\s+|-)')).where((s) => s.isNotEmpty).toList();
    
    final result = words.map((word) {
      // If it's a separator (space or hyphen), keep it as is
      if (word == ' ' || word == '-') {
        return word;
      }
      
      // Convert word to title case
      if (word.length == 1) {
        return word.toUpperCase();
      }
      
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join('');
    
    return result;
  }

  /// Capitalizes only the first letter of the entire string
  /// Examples:
  /// - "TOYOTA CAMRY" -> "Toyota camry"
  /// - "toyota camry" -> "Toyota camry"
  static String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    if (text.length == 1) return text.toUpperCase();
    
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Formats vehicle make/model for display
  /// Uses title case for better readability
  static String formatVehicleName(String? text) {
    if (text == null || text.isEmpty) return '';
    return toTitleCase(text);
  }
}
