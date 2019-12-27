import 'package:flutter/material.dart';

import 'login_dialog.dart';
import '../../blocs/user_provider.dart';

class LogInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserBloc bloc = UserProvider.of(context);

    return Container(
      width: 50,
      height: 50,
      child: StreamBuilder(
        stream: bloc.clientState,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: null,
            );
          }

          if (snapshot.data) {
            return IconButton(
              icon: Icon(Icons.verified_user),
              tooltip: "current user",
              onPressed: () => showAuthorPage(context, bloc),
            );
          }

          return IconButton(
            icon: Icon(Icons.account_circle),
            tooltip: "log in",
            onPressed: () => showLoginDialog(context),
          );
        },
      ),
    );
  }

  showAuthorPage(BuildContext context, UserBloc bloc) {
    Navigator.pushNamed(context, "/user/${bloc.currentUserName}");
  }

  showLoginDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return LogInDialog();
        });
  }
}
