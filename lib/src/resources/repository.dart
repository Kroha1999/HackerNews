import 'dart:async';


import 'data_provider.dart';
import 'list_type.dart';
import 'news_api_provider.dart';
import 'news_db_provider.dart';
import 'unofficial_api/hacker_news_client.dart';
import '../models/item_model.dart';

export 'list_type.dart';

class Repository {
  List<Source> _sources = <Source>[
    newsDbProvider,
    NewsApiProvider(),
  ];

  List<Cache> _caches = <Cache>[
    newsDbProvider,
  ];
  

  Future<NewsApiClient> fetchClient(){
    return newsDbProvider.fetchClient();
  }

  Future<int> setClient(NewsApiClient client){
    return newsDbProvider.setClient(client);
  }

  Future<int> clearClient() async {
    return newsDbProvider.clearClient();
  }

  Future<bool> isDbLoaded(){
    return newsDbProvider.isDbLoaded();
  }

  // TODO: Iterate throught _sources and fetch top Ids
  // Implement Db source
  Future<List<int>> fetchListIds(TypeOfList type) async {
    return _sources[1].fetchListIds(type);
  }

  Future<ItemModel> fetchItem(int id) async {
    ItemModel item;
    var source;

    for (source in _sources) {
      item = await source.fetchItem(id);
      if (item != null) {
        break;
      }
    }

    for (var cache in _caches) {
      if (cache != source) {
        cache.addItem(item);
      }
    }

    return item;
  }

  clearCache() async {
    for(var cache in _caches) {
      await cache.clear();
    }
  }
}
