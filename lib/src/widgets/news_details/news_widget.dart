import 'package:flutter/material.dart';

import 'story_container.dart';
import 'story_comments.dart';
import '../../blocs/comments_provider.dart';
import '../../models/item_model.dart';

class NewsWidget extends StatelessWidget {
  final ItemModel item;
  final Map<int, Future<ItemModel>> cache;

  NewsWidget({@required this.item, @required this.cache});

  @override
  Widget build(BuildContext context) {
    // Setting main parent in order to get it fro decendants later
    CommentsProvider.of(context).setParent = item;
    final children = <Widget>[];
    // Head of the view
    children.add(NewsContainer(item: item));
    children.add(
      Divider(
        height: 20,
        indent: 10,
        endIndent: 10,
        color: Colors.teal,
        thickness: 2,
      ),
    );
    //Fetching Comments widget list
    final commentsList = item.kids.map((commentId) {
      return Comment(
        indent: 0,
        map: cache,
        commentId: commentId,
      );
    }).toList();

    children.addAll(commentsList);

    // With ListView scrolling works rather strange as all of the elements are
    // not kept in the memory so each time they have default size of preview
    // element, which is rather small. but it lags
    // TODO: think about scrolling
    return ListView(
      children: children,
    );
  }
}
