import 'package:flutter/material.dart';
import 'package:hacker_news/src/mixins/date_mixin.dart';

import '../../blocs/stories_provider.dart';
import '../../models/item_model.dart';
import 'loading_list_tile.dart';

class NewsListTile extends StatelessWidget with DateMixin {
  final int itemId;
  NewsListTile({this.itemId});

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    return StreamBuilder(
      stream: bloc.items,
      builder: (context,
          AsyncSnapshot<Map<int, Future<ItemModel>>> itemsMapSnapshot) {
        if (!itemsMapSnapshot.hasData) {
          return LoadingListTile();
        }
        return FutureBuilder(
          future: itemsMapSnapshot.data[itemId],
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return LoadingListTile();
            }
            ItemModel item = itemSnapshot.data;
            // UI represantation
            return Material(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      item.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      children: <Widget>[
                        Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 16,
                        ),
                        Text("${item.score}"),
                        Expanded(child: Container()),
                        Text(
                          "${timeAgo(item.time)}",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Expanded(child: Container()),
                        Text("${item.descendants}"),
                        Icon(
                          Icons.comment,
                          color: Colors.teal,
                          size: 16,
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/news/$itemId');
                    },
                  ),
                  Divider(
                    height: 8,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
