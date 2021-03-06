import 'dart:convert';

import 'package:hacker_news/src/models/item_model.dart';
import 'package:hacker_news/src/resources/list_type.dart';
import 'package:hacker_news/src/resources/news_api_provider.dart';
import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  test('fetchTopIds() returns a list of ids', () async {
    final List<int> testArray = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0];

    final client = MockClient((request) async {
      return Response(
        json.encode(testArray),
        200,
      );
    });

    final newsApi = NewsApiProvider(client);

    final ids = await newsApi.fetchListIds(TypeOfList.BestStories);

    expect(ids, testArray);
  });

  test('fetchItem(id) returns an ItemModel ', () async {
    final jsonMap = {
      'by': 'dhouston',
      'descendants': 71,
      'id': 8863,
      'kids': [8952, 9224],
      'score': 111,
      'time': 1175714200,
      'title': 'My YC app: Dropbox - Throw away your USB drive',
      'type': 'story',
      'url': 'http://www.getdropbox.com/u/2/screencast.html'
    };
    final client = MockClient((request) async {
      return Response(json.encode(jsonMap), 200);
    });

    final newsApi = NewsApiProvider(client);

    final item = await newsApi.fetchItem(8863);
    expect(item.id, 8863);
    expect(item.runtimeType, ItemModel);
  });
}
