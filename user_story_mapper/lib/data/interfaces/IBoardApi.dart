import '../../models/board.dart';

abstract class IBoardApi {
  Stream<Board> getBoard(String boardId);
  Future<void> createBoard(Board board);
  Future<void> updateBoard(Board board);
  Future<void> deleteBoard(String boardId);
}

class BoardNotFoundException implements Exception {}
