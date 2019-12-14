import 'package:flutter/material.dart';
import 'package:hacker_news/src/blocs/user_bloc.dart';

class UserProvider extends InheritedWidget {
  final UserBloc bloc;
  UserProvider({Key key, Widget child}) 
    : bloc = UserBloc(),super(key: key, child: child);

  

  static UserBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserProvider>().bloc;
  }

  @override
  bool updateShouldNotify( UserProvider oldWidget) {
    return true;
  }
}