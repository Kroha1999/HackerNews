import 'package:flutter/material.dart';

import 'comments_bloc.dart';

export 'comments_bloc.dart';

class CommentsProvider extends InheritedWidget {
  CommentsProvider({Key key, Widget child})
      : bloc = CommentsBloc(),
        super(key: key, child: child);

  final CommentsBloc bloc;

  static CommentsBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CommentsProvider>().bloc;
  }

  @override
  bool updateShouldNotify(CommentsProvider oldWidget) {
    return true;
  }
}
