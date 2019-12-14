import 'package:flutter/material.dart';
import 'package:hacker_news/src/blocs/user_provider.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

import '../../models/vote.dart';

class VoteButton extends StatelessWidget {
  final double size;
  VoteButton(this.size);
  @override
  Widget build(BuildContext context) {
    var bloc = UserProvider.of(context);
    return StreamBuilder<Object>(
      stream: bloc.clientState,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        // if user logged in
        if (snapshot.data) {
          return Container(
            margin: EdgeInsets.all(size/6),
            width: size,
            height: size,
            child: StreamBuilder(
              stream: bloc.voteState,
              builder: (context, AsyncSnapshot<Vote> snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                if (snapshot.data.voted) {
                  return IconButton(
                    icon: Icon(
                      Icons.thumb_up,
                      size: size,
                    ),
                    onPressed: () => bloc.toogleVote(snapshot.data),
                  );
                }
                return IconButton(
                  icon: Icon(
                    OMIcons.thumbUp,
                    size: size,
                  ),
                  onPressed: () => bloc.toogleVote(snapshot.data),
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
