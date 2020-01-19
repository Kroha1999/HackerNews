import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../blocs/user_provider.dart';
import '../../mixins/date_mixin.dart';
import '../../mixins/url_mixin.dart';
import '../../models/item_model.dart';
import '../../widgets/user_widgets/reply_button.dart';
import '../news_list/loading_list_tile.dart';
import '../user_widgets/author_button.dart';

List<MaterialColor> cols = [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.teal,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
];

class Comment extends StatelessWidget with UrlMixin, DateMixin {
  const Comment({
    @required this.map,
    @required this.commentId,
    @required this.indent,
  });

  final Map<int, Future<ItemModel>> map;
  final int commentId;
  // Moves child comments depending on it's indent (0 - parent comment)
  final int indent;

  @override
  Widget build(BuildContext context) {
    final bloc = UserProvider.of(context);
    return FutureBuilder(
      future: map[commentId],
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (!snapshot.hasData) {
          return const LoadingListTile();
        }
        final item = snapshot.data;

        // Comment represantation children.
        final stackChildren = <Widget>[];
        int i = 0;
        // Add comment indents.
        while (i < indent) {
          stackChildren.add(Positioned(
            left: (i + 1) * 8.0,
            top: 0,
            bottom: 0,
            child: VerticalDivider(
              width: 8,
              thickness: 1,
              color: i >= cols.length ? cols[i % cols.length] : cols[i],
            ),
          ));
          i++;
        }
        // Building comment representation.
        stackChildren.add(
          Card(
            elevation: 0,
            color: Colors.grey[200],
            margin:
                EdgeInsets.only(left: (indent + 1) * 8.0, bottom: 8, right: 8),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListTile(
                title: Html(
                  data: item.text,
                  onLinkTap: (link) => launchURL(link),
                ),
                subtitle: item.deleted
                    ? const Text('Deleted')
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            runAlignment: WrapAlignment.end,
                            children: <Widget>[
                              AuthorButton(
                                item.by,
                                color: Colors.grey[700],
                              ),
                              Text(' ~ ${timeAgo(item.time)}'),
                            ],
                          ),
                          StreamBuilder(
                            stream: bloc.clientState,
                            builder: (context, AsyncSnapshot<bool> snapshot) {
                              if (!snapshot.hasData) {
                                return Container();
                              }
                              if (snapshot.data && !item.deleted) {
                                return Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  height: 20,
                                  width: 70,
                                  child: ReplyButton(item: item),
                                );
                              }
                              return Container();
                            },
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );

        // Builing subcomments
        final subcomments = <Widget>[];
        for (int comId in snapshot.data.kids) {
          subcomments.add(
            Comment(
              indent: indent + 1,
              commentId: comId,
              map: map,
            ),
          );
        }

        return Column(
          children: <Widget>[
            // comment represantation
            Container(
              child: Stack(
                children: stackChildren,
              ),
            ),

            // subcomments
            Column(
              children: subcomments,
            ),
          ],
        );
      },
    );
  }
}
