import 'package:flutter/material.dart';
import 'package:hacker_news/src/widgets/loading_list_tile.dart';

import '../blocs/stories_provider.dart';
import '../models/item_model.dart';

class NewsListTile extends StatelessWidget {
  final int itemId;
  NewsListTile({this.itemId});

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    return Container(
      child: StreamBuilder(
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
              return Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      item.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Row(
                      children: <Widget>[
                        Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 16,
                        ),
                        Text("${item.score}")
                      ],
                    ),
                    trailing: Column(
                      children: <Widget>[
                        Icon(
                          Icons.comment,
                          color: Colors.teal,
                        ),
                        Text("${item.descendants}"),
                      ],
                    ),
                  ),
                  Divider(
                    height: 8,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
