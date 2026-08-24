import '../../core/config/supabase_config.dart';
import '../../core/config/database_schema.dart';
import '../models/user_model.dart';

class UserService {
  final _client = SupabaseConfig.client;

  /// Fetch a user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      final response = await _client
          .from(DatabaseSchema.profiles)
          .select()
          .eq(DatabaseSchema.id, userId)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return UserModel.fromJson(response);
    } catch (e) {
      print('❌ [UserService] Error fetching user $userId: $e');
      return null;
    }
  }

  /// Fetch multiple users by IDs
  Future<Map<String, UserModel>> getUsersByIds(List<String> userIds) async {
    if (userIds.isEmpty) return {};

    try {
      // Fetch users one by one or use a different approach
      // Supabase PostgREST doesn't have in_ method, so we'll fetch individually
      final users = <String, UserModel>{};
      for (final userId in userIds) {
        final user = await getUserById(userId);
        if (user != null) {
          users[user.id] = user;
        }
      }
      return users;
    } catch (e) {
      print('❌ [UserService] Error fetching users: $e');
      return {};
    }
  }

  /// Get user name or fallback to email or ID
  String getUserDisplayName(UserModel? user, {String? fallbackId}) {
    if (user == null) {
      return fallbackId ?? 'Unknown';
    }
    return user.name ?? user.email;
  }

  /// Fetch all users (employees)
  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await _client
          .from(DatabaseSchema.profiles)
          .select()
          .order(DatabaseSchema.name, ascending: true);

      return (response as List)
          .map((json) => UserModel.fromJson(json))
          .toList();
    } catch (e) {
      print('❌ [UserService] Error fetching all users: $e');
      return [];
    }
  }
}

