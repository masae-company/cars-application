import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../../core/config/supabase_config.dart';
import '../../core/config/database_schema.dart';
import '../../core/utils/supabase_error_handler.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>(
  (ref) => AuthNotifier(),
);

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  AuthNotifier() : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    final session = SupabaseConfig.client.auth.currentSession;
    if (session != null) {
      await _loadUser(session.user.id);
    } else {
      state = const AsyncValue.data(null);
    }

    // Listen to auth state changes
    SupabaseConfig.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        _loadUser(data.session?.user.id ?? '');
      } else if (event == AuthChangeEvent.signedOut) {
        state = const AsyncValue.data(null);
      }
    });
  }

  Future<void> _loadUser(String userId) async {
    try {
      final response = await SupabaseConfig.client
          .from(DatabaseSchema.profiles)
          .select()
          .eq(DatabaseSchema.id, userId)
          .maybeSingle();

      if (response == null) {
        state = AsyncValue.error(
          Exception(
            'User profile not found in database.\n\n'
            'Possible causes:\n'
            '1. The profiles table does not exist\n'
            '2. Your user ID is not in the profiles table\n'
            '3. Row Level Security (RLS) policies are blocking access\n\n'
            'Please ensure:\n'
            '- The profiles table exists with columns: id, email, full_name, role, created_at\n'
            '- Your user ID exists in the profiles table\n'
            '- RLS policies allow SELECT for authenticated users'
          ),
          StackTrace.current,
        );
        return;
      }

      final user = UserModel.fromJson(response);
      state = AsyncValue.data(user);
    } catch (e) {
      final errorMessage = SupabaseErrorHandler.getErrorMessage(e);
      
      if (SupabaseErrorHandler.isNotFoundError(e)) {
        state = AsyncValue.error(
          Exception(
            'Database table not found (404).\n\n'
            'Please verify:\n'
            '1. The "profiles" table exists in your Supabase database\n'
            '2. The table name matches exactly: ${DatabaseSchema.profiles}\n'
            '3. Row Level Security (RLS) is properly configured\n\n'
            'Error details: $errorMessage'
          ),
          StackTrace.current,
        );
      } else {
        state = AsyncValue.error(
          Exception(errorMessage),
          StackTrace.current,
        );
      }
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      state = const AsyncValue.loading();
      final response = await SupabaseConfig.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await _loadUser(response.user!.id);
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await SupabaseConfig.client.auth.signOut();
    state = const AsyncValue.data(null);
  }

  UserModel? get currentUser => state.valueOrNull;
}

