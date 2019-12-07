import 'package:flutter/material.dart';
import 'package:hacker_news/src/widgets/news_details/news_widget.dart';
import 'package:hacker_news/src/widgets/news_list/loading_list_tile.dart';

import '../../blocs/comments_provider.dart';
import '../../models/item_model.dart';

class NewsDetailsBody extends StatelessWidget {
  final int itemId;
  NewsDetailsBody({@required this.itemId});
  @override
  Widget build(BuildContext context) {
    final bloc = CommentsProvider.of(context);
    return StreamBuilder(
      stream: bloc.itemWithComments,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Container(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            ),
          );
        }
        final itemFuture = snapshot.data[itemId];
        return FutureBuilder(
          future: itemFuture,
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return Center(
                child: LoadingListTile(),
              );
            }
            final item = itemSnapshot.data;
            // Ui represantation of story and comments
            return NewsWidget(
              item: item,
              cache: snapshot.data,
            );
          },
        );
      },
    );
  }
}
