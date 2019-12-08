import 'dart:convert';

import 'package:http/http.dart' show Client;

import '../models/item_model.dart';
import 'list_type.dart';
import 'data_provider.dart';

class NewsApiProvider implements Source {
  Client client = Client();

  final _root = 'https://hacker-news.firebaseio.com/v0';

  /// Fetches list of top HackerNews ids
  Future<List<int>> fetchListIds(TypeOfList type) async {
    String endpoint;
    switch (type) {
      case TypeOfList.TopStories:
        endpoint = "topstories.json";
        break;
      case TypeOfList.NewStories:
        endpoint = "newstories.json";
        break;
      case TypeOfList.BestStories:
        endpoint = "beststories.json";
        break;
      default: 
        endpoint = "topstories.json";
    }
    final responce = await client.get("$_root/$endpoint");
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
