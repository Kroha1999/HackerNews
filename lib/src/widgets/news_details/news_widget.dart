import 'package:flutter/material.dart';
import 'package:hacker_news/src/models/item_model.dart';

import 'story_container.dart';
import 'story_comments.dart';

class NewsWidget extends StatelessWidget {
  final ItemModel item;
  final Map<int, Future<ItemModel>> cache;

  NewsWidget({@required this.item, @required this.cache});

  @override
  Widget build(BuildContext context) {
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
    return ListView(
      children: children,
    );
  }
}
