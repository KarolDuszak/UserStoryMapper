import '../../models/userModels/user.dart';

abstract class IUserApi {
  Future<void> createUser(User user);
  Future<User> getUser(String userId);
  Future<void> deleteUser(String userId);
}
