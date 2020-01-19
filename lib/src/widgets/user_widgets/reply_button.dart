import 'package:flutter/material.dart';

import '../../models/item_model.dart';
import '../../screens/comment_screen.dart';

class ReplyButton extends StatelessWidget {
  const ReplyButton({
    Key key,
    @required this.item,
  }) : super(key: key);

  final ItemModel item;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: Colors.grey[400],
      child: Text(
        'Reply',
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) {
                return const CommentScreen();
              },
              settings: RouteSettings(
                arguments: item,
              )),
        );
      },
    );
  }
}
