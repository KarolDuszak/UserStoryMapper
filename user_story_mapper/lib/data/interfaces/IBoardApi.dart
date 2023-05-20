import '../../models/board.dart';

abstract class IBoardApi {
  Future<List<Board>> getBoards();
  Future<List<String>> getAllBoardsId();
  Stream<Board> getBoard(String boardId);
  Future<void> createBoard(Board board);
  Future<void> updateBoard(Board board);
  Future<void> deleteBoard(String boardId);
}
