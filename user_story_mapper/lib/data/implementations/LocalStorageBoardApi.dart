import 'package:user_story_mapper/data/interfaces/IBoardApi.dart';
import 'package:user_story_mapper/models/board.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';

class LocalStorageBoardApi extends IBoardApi {
  LocalStorageBoardApi({
    required SharedPreferences plugin,
  }) : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;
  final _boardStreamController = BehaviorSubject<List<Board>>.seeded(const []);

  static _init() {
    // TODO: implement _init
    throw UnimplementedError();
  }

  @override
  Future<void> createBoard(Board board) {
    // TODO: implement createBoard
    throw UnimplementedError();
  }

  @override
  Future<void> deleteBoard(String boardId) {
    // TODO: implement deleteBoard
    throw UnimplementedError();
  }

  @override
  Stream<Board> getBoard(String boardId) {
    // TODO: implement getBoard
    throw UnimplementedError();
  }

  @override
  Future<List<Board>> getBoards() {
    // TODO: implement getBoards
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getBoardsId() {
    // TODO: implement getBoardsId
    throw UnimplementedError();
  }

  @override
  Future<void> updateBoard(Board board) {
    // TODO: implement updateBoard
    throw UnimplementedError();
  }
}
