import 'package:flutter/material.dart';

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
            return Center(
              child: Container(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              ),
            );
          }
          return FutureBuilder(
            future: itemsMapSnapshot.data[itemId],
            builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
              if (!itemSnapshot.hasData) {
                return Text("Loading.....");
              }
              return Text(itemSnapshot.data.title.toString());
            },
          );
        },
      ),
    );
  }
}
