import 'package:flutter/material.dart';

import 'user_bloc.dart';

export 'user_bloc.dart';

class UserProvider extends InheritedWidget {
  UserProvider({Key key, Widget child})
      : bloc = UserBloc(),
        super(key: key, child: child);

  final UserBloc bloc;

  static UserBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserProvider>().bloc;
  }

  @override
  bool updateShouldNotify(UserProvider oldWidget) {
    return true;
  }
}
