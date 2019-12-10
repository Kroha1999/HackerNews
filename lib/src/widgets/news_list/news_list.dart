import 'package:flutter/material.dart';

import '../../resources/list_type.dart';
import '../../blocs/stories_provider.dart';
import 'news_list_tile.dart';
import 'refresh_indicator.dart';

class NewsList extends StatelessWidget {
  final TypeOfList _type;
  NewsList(this._type);
  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    return StreamBuilder(
      stream: bloc.listIdsStream(_type),
      builder: (context, AsyncSnapshot<List<int>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Container(
              child: CircularProgressIndicator(),
              height: 25,
              width: 25,
            ),
          );
        }

        return Refresh(
          ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: snapshot.data.length,
            itemBuilder: (context, int index) {
              // Fetches data for each separate item
              bloc.fetchItem(snapshot.data[index]);
              // Returns a NewsListItem
              return NewsListTile(itemId: snapshot.data[index]);
            },
          ),
          type: _type,
        );
      },
    );
  }
}
