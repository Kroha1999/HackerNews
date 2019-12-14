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
              onPressed: null,
            );
          }

          return IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () => showLoginDialog(context),
          );
        },
      ),
    );
  }

  showLoginDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return LogInDialog();
        });
  }
}
