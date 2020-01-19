import 'package:flutter/material.dart';

import '../../blocs/stories_provider.dart';
import '../../resources/list_type.dart';
import 'news_list_tile.dart';
import 'refresh_indicator.dart';

class NewsList extends StatelessWidget {
  const NewsList(this._type);

  final TypeOfList _type;

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    return StreamBuilder(
      stream: bloc.listIdsStream(_type),
      builder: (context, AsyncSnapshot<List<int>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Container(
              child: const CircularProgressIndicator(),
              height: 25,
              width: 25,
            ),
          );
        }

        return Refresh(
          ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
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
