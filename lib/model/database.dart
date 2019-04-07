import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

final String tableTodo = 'todoTable';
final String colId = 'id';
final String colTitle = 'title';
final String colDone = 'done';

class Node {
  int _id;
  String _title;
  int _done;

  Node.fromMap(Map<String, dynamic> map) {
    print("map['done'].runtimeType");
    print(map['done'].runtimeType);
    this._id = map['id'];
    this._title = map['title'];
    this._done = map['done'] == false ? 0 : 1;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {colTitle: _title, colDone: _done};
    if (_id != null) {
      map[colId] = _id;
    }
    return map;
  }

  Node.getValue(title) {
    this._title = title;
    this._done = 0;
  }

  Node.map(dynamic obj) {
    this._id = obj['id'];
    this._title = obj['title'];
    this._done = obj['done'];
  }

  int get id => _id;
  String get title => _title;
  int get done => _done;

  Node();
}

class NodeDatabase {
  static final NodeDatabase _instance = new NodeDatabase.internal();
  factory NodeDatabase() => _instance;
  static Database _db;
  NodeDatabase.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'Node.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableTodo($colId INTEGER PRIMARY KEY, $colTitle TEXT, $colDone TEXT)');
  }

  Future<int> createNewNode(Node Node) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableTodo, Node.toMap());
    return result;
  }

  Future<List> getAllNode() async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tableTodo,
        columns: [colId, colTitle, colDone],
        where: '$colDone = ?',
        whereArgs: [0]);
    return result;
  }

  Future<List> getAllComplete() async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tableTodo,
        columns: [colId, colTitle, colDone],
        where: '$colDone = ?',
        whereArgs: [1]);
    return result;
  }

  Future<int> deleteAllDone() async {
    var dbClient = await db;
    return await dbClient
        .delete(tableTodo, where: '$colDone = ?', whereArgs: [1]);
  }

  Future<int> updateNode(Node Node) async {
    var dbClient = await db;
    return await dbClient.update(tableTodo, Node.toMap(),
        where: "$colId = ?", whereArgs: [Node.id]);
  }

}
