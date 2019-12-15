import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

import '../../blocs/user_provider.dart';
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
            width: size+10,
            height: size+15,
            child: StreamBuilder(
              stream: bloc.voteState,
              builder: (context, AsyncSnapshot<Vote> snapshot) {
                if (!snapshot.hasData || (snapshot.data==null)) {
                  return IconButton(
                    icon: Icon(
                      OMIcons.thumbUp,
                      size: size,
                      color: Colors.grey,
                    ),
                    tooltip: "loading",
                    onPressed: null,
                  );
                }
                if (snapshot.data.voted) {
                  return IconButton(
                    icon: Icon(
                      Icons.thumb_up,
                      size: size,
                    ),
                    tooltip: "unvote",
                    onPressed: () => bloc.toogleVote(snapshot.data),
                  );
                }
                return IconButton(
                  icon: Icon(
                    OMIcons.thumbUp,
                    size: size,
                  ),
                  tooltip: "upvote",
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
