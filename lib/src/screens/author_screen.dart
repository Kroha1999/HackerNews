import 'package:flutter/material.dart';

import '../blocs/user_provider.dart';
import '../models/user.dart';

class AuthorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserBloc bloc = UserProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Author details"),
      ),
      body: StreamBuilder(
        stream: bloc.currentUser,
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Container(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            );
          }
          User user = snapshot.data;
          // User details screen
          return buildUserDetailsUi(user, bloc);
        },
      ),
    );
  }

  Widget buildUserDetailsUi(User user, UserBloc bloc) {
    TextStyle style = TextStyle(fontSize: 30);
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "User: ${user.userId}",
            style: style,
          ),
          Text(
            "Created: ${user.created}",
            style: style,
          ),
          Text(
            "Karma: ${user.karma}",
            style: style,
          ),
          Text(
            "About: ${user.about}",
            style: style,
          ),
          Expanded(
            child: Container(),
          ),
          // logout button
          StreamBuilder(
            stream: bloc.clientState,
            builder: (context, AsyncSnapshot<bool> snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              if (snapshot.data) {
                return Center(
                  child: RaisedButton(
                      color: Colors.redAccent,
                      textColor: Colors.white,
                      child: Text(
                        "LogOut",
                        style: style,
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () => logout(context, bloc)),
                );
              }
              return Container();
            },
          )
        ],
      ),
    );
  }

  logout(BuildContext context, UserBloc bloc) {
    bloc.logout();
    Navigator.pop(context);
  }
}
