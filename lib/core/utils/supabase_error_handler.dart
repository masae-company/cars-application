class SupabaseErrorHandler {
  static String getErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('404') || errorString.contains('not found')) {
      return 'Resource not found. Please check if the table exists in your database.';
    }
    
    if (errorString.contains('401') || errorString.contains('unauthorized')) {
      return 'Unauthorized. Please check your authentication credentials.';
    }
    
    if (errorString.contains('403') || errorString.contains('forbidden')) {
      return 'Access forbidden. You may not have permission to access this resource.';
    }
    
    if (errorString.contains('network') || errorString.contains('connection')) {
      return 'Network error. Please check your internet connection.';
    }
    
    if (errorString.contains('invalid') || errorString.contains('malformed')) {
      return 'Invalid request. Please check your input data.';
    }
    
    // Return original error message if no specific match
    return error.toString().replaceAll('Exception: ', '').replaceAll('Error: ', '');
  }
  
  static bool isNotFoundError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    return errorString.contains('404') || 
           errorString.contains('not found') ||
           errorString.contains('does not exist');
  }
  
  static bool isAuthError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    return errorString.contains('401') || 
           errorString.contains('unauthorized') ||
           errorString.contains('403') ||
           errorString.contains('forbidden');
  }
}


