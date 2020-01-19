import 'package:flutter/material.dart';

import 'stories_bloc.dart';

export 'stories_bloc.dart';

class StoriesProvider extends InheritedWidget {
  StoriesProvider({Key key, Widget child})
      : bloc = StoriesBloc(),
        super(key: key, child: child);

  final StoriesBloc bloc;

  static StoriesBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StoriesProvider>().bloc;
  }

  @override
  bool updateShouldNotify(StoriesProvider oldWidget) {
    return true;
  }
}
