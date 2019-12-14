import 'dart:async';


import 'data_provider.dart';
import 'list_type.dart';
import 'news_api_provider.dart';
import 'news_db_provider.dart';
import 'unofficial_api/hacker_news_client.dart';
import '../models/item_model.dart';

export 'list_type.dart';

class Repository {
  List<Source> sources = <Source>[
    newsDbProvider,
    NewsApiProvider(),
  ];

  List<Cache> caches = <Cache>[
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



  // TODO: Iterate throught sources and fetch top Ids
  // Implement Db source
  Future<List<int>> fetchListIds(TypeOfList type) async {
    return sources[1].fetchListIds(type);
  }

  Future<ItemModel> fetchItem(int id) async {
    ItemModel item;
    var source;

    for (source in sources) {
      item = await source.fetchItem(id);
      if (item != null) {
        break;
      }
    }

    for (var cache in caches) {
      if (cache != source) {
        cache.addItem(item);
      }
    }

    return item;
  }

  clearCache() async {
    for(var cache in caches) {
      await cache.clear();
    }
  }
}
