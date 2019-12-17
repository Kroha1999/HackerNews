import 'dart:io';
import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import "unofficial_api/hacker_news_client.dart";
import '../models/item_model.dart';
import 'data_provider.dart';

class NewsDbProvider implements Source, Cache {
  Database db;

  NewsDbProvider() {
    init();
  }

  void init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "items.db");
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) async {
        // bool are represented as INTEGER
        // list<int> is represented as BLOB -> decode must be done
        newDb.execute("""
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
        """);
        newDb.execute("""
          CREATE TABLE Client
            (
              id INTEGER PRIMARY KEY,
              username TEXT,
              client TEXT
            )
        """);
      },
    );
  }

  Future<bool> isDbLoaded()async{
    int i = 0;
    while(i < 20){
      if(db!=null) return true;
      await Future.delayed(Duration(milliseconds:200));
    }
    return false;
  }

  // by default user will be written to id = 0
  Future<NewsApiClient> fetchClient({int id = 0}) async {
    final maps = await db.query(
      "Client",
      columns: null,
      where: "id = ?",
      whereArgs: [id],
    );
    if (maps.length > 0) {
      if (maps[0]['client'] != '') {
        return NewsApiClient.fromCookieString(
            maps[0]['username'], maps[0]['client']);
      }
    }
    return null;
  }

  Future<int> setClient(NewsApiClient client) {
    return db.insert(
      "Client",
      client.toMapDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> clearClient() {
    return db.delete("Client");
  }

  // TODO: store TopIds
  Future<List<int>> fetchListIds(type) {
    return null;
  }

  Future<ItemModel> fetchItem(int id) async {
    final maps = await db.query(
      "Items",
      columns: null,
      where: "id = ?",
      whereArgs: [id],
    );

    if (maps.length > 0) {
      return ItemModel.fromDb(maps[0]);
    }

    return null;
  }

  Future<int> addItem(ItemModel item) {
    return db.insert(
      "Items",
      item.toMapDb(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<int> clear() {
    return db.delete("Items");
  }
}

// The only instance of news Db in order not to create multiple instances of NewsDbProvider
final newsDbProvider = NewsDbProvider();
