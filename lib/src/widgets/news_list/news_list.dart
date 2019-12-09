import 'package:flutter/material.dart';

import '../../resources/list_type.dart';
import '../../blocs/stories_provider.dart';
import 'news_list_tile.dart';
import 'refresh_indicator.dart';

class NewsList extends StatelessWidget {
  final TypeOfList type;
  NewsList(this.type);
  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    return StreamBuilder(
      stream: bloc.topIds,
      builder: (context, AsyncSnapshot<List<int>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Container(
              child: CircularProgressIndicator(),
              height: 50,
              width: 50,
            ),
          );
        }

        return Refresh(
          ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, int index) {
              // Fetches data for each separate item
              bloc.fetchItem(snapshot.data[index]);
              // Returns a NewsListItem
              return NewsListTile(itemId: snapshot.data[index]);
            },
          ),
          type: type,
        );
      },
    );
  }
}
