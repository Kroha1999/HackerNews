import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../mixins/url_mixin.dart';
import '../../models/item_model.dart';
import '../news_list/loading_list_tile.dart';

class Comment extends StatelessWidget with UrlMixin {
  final Map<int, Future<ItemModel>> map;
  final int commentId;
  // Moves child comments depending on it's indent (0 - parent comment)
  final int indent;
  Comment(
      {@required this.map, @required this.commentId, @required this.indent});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: map[commentId],
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (!snapshot.hasData) {
          return LoadingListTile();
        }
        final item = snapshot.data;
        final children = <Widget>[
          ListTile(
            contentPadding: EdgeInsets.only(
              left: 16 + indent * 16.0,
              right: 16,
            ),
            title: Html(
              data: item.text,
              onLinkTap: (link) => launchURL(link),
            ),
            subtitle: item.by == '' ? Text("Deleted") : Text('by: ${item.by}'),
          ),
          Divider(
            height: 4,
            thickness: 1,
          ),
        ];
        // Builing subcomments
        for (int comId in snapshot.data.kids) {
          children.add(
            Comment(
              indent: indent + 1,
              commentId: comId,
              map: map,
            ),
          );
        }
        return Column(children: children);
      },
    );
  }
}
