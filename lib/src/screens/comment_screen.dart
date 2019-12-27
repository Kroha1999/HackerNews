import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../blocs/comments_provider.dart';
import '../models/item_model.dart';
import '../widgets/user_widgets/comment_form.dart';

/// replyItem - [ItemModel] that must be replied,
/// parent - The very top parent in the hierarchy [ItemModel]
class CommentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = CommentsProvider.of(context);
    final ItemModel replyItem = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Comment'),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: ListView(
          children: <Widget>[
            Text(
              bloc.getParent.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Html(data: replyItem.text),
            Divider(),
            CommentForm(replyItem),
          ],
        ),
      ),
    );
  }
}
