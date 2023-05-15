import '../../models/board.dart';

abstract class IBoardApi {
  Future<List<Board>> getBoards();
  Future<List<String>> getBoardsId();
  Future<Board> getBoard(String boardId);
  Future<void> createBoard(Board board);
  Future<void> updateBoard(Board board);
  Future<void> deleteBoard(String boardId);
}
