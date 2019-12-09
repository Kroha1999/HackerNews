import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

import '../../mixins/date_mixin.dart';
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
            return Card(
              margin: EdgeInsets.only(
                left: 5,
                right: 5,
                bottom: 5,
              ),
              elevation: 2.5,
              child: ListTile(
                title: Container(
                  child: Text(
                    item.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                // Likes and Comments count
                trailing: Container(
                  width: 65,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("${item.score}"),
                          item.score < 100
                              ? Icon(
                                  Icons.ac_unit,
                                  color: Colors.blue,
                                  size: 22,
                                )
                              : Icon(
                                  OMIcons.whatshot,
                                  color: item.score < 200
                                    ? Colors.orange
                                    : Colors.red,
                                  size: 22,
                                ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("${item.descendants}"),
                          Icon(
                            OMIcons.forum,
                            color: Colors.teal,
                            size: 22,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Author and time
                subtitle: Row(
                  children: <Widget>[
                    Text(
                      "by: ${item.by}",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      " ~ ${timeAgo(item.time)}",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/news/$itemId');
                },
              ),
            );
          },
        );
      },
    );
  }
}
