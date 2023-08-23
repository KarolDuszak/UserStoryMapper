import '../../models/userModels/boardInvitation.dart';
import '../../models/userModels/user.dart';

abstract class IUserApi {
  Future<void> createUser(User user);
  Future<User> getUser(String userId);
  Future<void> deleteUser(String userId);
  Future<void> updateUser(User user);
  Future<List<BoardInvitation>> getUsersInvitations(
      String userId, String userEmail);
  Future<void> acceptBoardInvitation(String userId, String boardId);
  Future<void> declineBoardInvitation(String userId, String boardId);
}
