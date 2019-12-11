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
            return buildWidget(item, context);
          },
        );
      },
    );
  }

  Widget buildWidget(ItemModel item, context) {
    return Card(
      key: Key(item.id.toString()),
      margin: EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: 10,
      ),
      elevation: 2.5,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/news/$itemId'),
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Title
                  Text(
                    item.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 22),
                  ),
                  // Time ago
                  Text(
                    "${timeAgo(item.time)}",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 4,
            thickness: 0.6,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
            height: 30,
            child: Row(
              children: <Widget>[
                // Author
                Text(
                  "By: ${item.by}",
                  style: TextStyle(color: Colors.grey[700]),
                ),
                Expanded(child: Container()),
                // Comments count
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "${item.score}",
                      style: TextStyle(
                        fontFamily: "OpenSans",
                        color: Colors.grey[700],
                      ),
                    ),
                    item.score < 100
                        ? Icon(
                            Icons.ac_unit,
                            color: Colors.blue,
                            size: 20,
                          )
                        : Icon(
                            OMIcons.whatshot,
                            color:
                                item.score < 200 ? Colors.orange : Colors.red,
                            size: 20,
                          ),
                  ],
                ),
                // Comments count
                Container(
                  width: 55,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "${item.descendants}",
                        style: TextStyle(
                          fontFamily: "OpenSans",
                          color: Colors.grey[700],
                        ),
                      ),
                      Icon(
                        OMIcons.forum,
                        color: Colors.teal,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
