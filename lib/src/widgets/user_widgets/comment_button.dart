import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

import '../../blocs/user_provider.dart';
import '../../models/item_model.dart';
import '../../screens/comment_screen.dart';

class CommentButton extends StatelessWidget {
  const CommentButton(this.size, this.item);

  final double size;
  final ItemModel item;

  @override
  Widget build(BuildContext context) {
    final bloc = UserProvider.of(context);
    return StreamBuilder<Object>(
      stream: bloc.clientState,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        // if user logged in
        if (snapshot.data) {
          return Container(
            margin: EdgeInsets.all(size / 6),
            width: size + 10,
            height: size + 15,
            child: IconButton(
              icon: Icon(OMIcons.comment),
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
            ),
          );
        }
        return Container();
      },
    );
  }
}
