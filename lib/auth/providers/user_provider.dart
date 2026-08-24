import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';

final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});

final userProvider = FutureProvider.family<UserModel?, String>(
  (ref, userId) async {
    if (userId.isEmpty) return null;
    final service = ref.watch(userServiceProvider);
    return service.getUserById(userId);
  },
);

final usersProvider = FutureProvider.family<Map<String, UserModel>, List<String>>(
  (ref, userIds) async {
    if (userIds.isEmpty) return {};
    final service = ref.watch(userServiceProvider);
    return service.getUsersByIds(userIds);
  },
);

final allUsersProvider = FutureProvider<List<UserModel>>((ref) async {
  final service = ref.watch(userServiceProvider);
  return service.getAllUsers();
});

