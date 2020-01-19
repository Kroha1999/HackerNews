import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import '../models/item_model.dart';
import 'data_provider.dart';
import 'unofficial_api/hacker_news_client.dart';

class NewsDbProvider implements Source, Cache {
  NewsDbProvider() {
    init();
  }

  Database _db;

  Future<Database> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'items.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) async {
        // bool are represented as INTEGER
        // list<int> is represented as BLOB -> decode must be done
        newDb.execute('''
          CREATE TABLE Items
            (
              id INTEGER PRIMARY KEY,
              deleted INTEGER,
              type TEXT,
              by TEXT,
              time INTEGER,
              text TEXT,
              dead INTEGER, 
              parent INTEGER,
              kids BLOB,
              url TEXT,
              score INTEGER,
              title TEXT,
              descendants INTEGER
            )
        ''');
        newDb.execute('''
          CREATE TABLE Client
            (
              id INTEGER PRIMARY KEY,
              username TEXT,
              client TEXT
            )
        ''');
      },
    );
    return _db;
  }

  Future<bool> isDbLoaded() async {
    int i = 0;
    while (i < 20) {
      if (_db != null) return true;
      await Future.delayed(const Duration(milliseconds: 200));
      i++;
    }
    return false;
  }

  // by default user will be written to id = 0
  Future<NewsApiClient> fetchClient({int id = 0}) async {
    final maps = await _db.query(
      'Client',
      columns: null,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      if (maps[0]['client'] != '') {
        return NewsApiClient.fromCookieString(
            maps[0]['username'], maps[0]['client']);
      }
    }
    return null;
  }

  Future<int> setClient(NewsApiClient client) {
    return _db.insert(
      'Client',
      client.toMapDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> clearClient() {
    return _db.delete('Client');
  }

  // TODO(Bodka): store TopIds
  @override
  Future<List<int>> fetchListIds(type) {
    return null;
  }

  @override
  Future<ItemModel> fetchItem(int id) async {
    final maps = await _db.query(
      'Items',
      columns: null,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ItemModel.fromDb(maps[0]);
    }

    return null;
  }

  @override
  Future<int> addItem(ItemModel item) {
    return _db.insert(
      'Items',
      item.toMapDb(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  @override
  Future<int> clear() {
    return _db.delete('Items');
  }
}

// The only instance of news Db in order not to create multiple instances of NewsDbProvider
final newsDbProvider = NewsDbProvider();
