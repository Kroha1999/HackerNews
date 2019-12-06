import 'dart:convert';

import 'package:hacker_news/src/models/item_model.dart';
import 'package:http/http.dart' show Client;

import 'data_provider.dart';

class NewsApiProvider implements Source {
  Client client = Client();

  final _root = 'https://hacker-news.firebaseio.com/v0';

  /// Fetches list of top HackerNews ids
  Future<List<int>> fetchTopIds() async {
    final responce = await client.get("$_root/topstories.json");
    final ids = json.decode(responce.body);

    return ids.cast<int>();
  }

  /// Fetches exect item with specific [id]
  Future<ItemModel> fetchItem(int id) async {
    final responce = await client.get("$_root/item/$id.json");
    final parsedJson = json.decode(responce.body);

    return ItemModel.fromJson(parsedJson);
  }
}
