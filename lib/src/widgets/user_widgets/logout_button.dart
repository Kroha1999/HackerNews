import 'package:flutter/material.dart';

import '../../blocs/user_provider.dart';

class LogOutButton extends StatelessWidget {
  final style = TextStyle(fontSize: 30, fontFamily: "OpenSans");
  @override
  Widget build(BuildContext context) {
    UserBloc bloc = UserProvider.of(context);
    return StreamBuilder(
      stream: bloc.clientState,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        if (snapshot.data) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width/2,
              child: RaisedButton(
                padding: EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(22.0),
                  side: BorderSide(color: Colors.red)
                ),
                color: Colors.redAccent,
                textColor: Colors.white,
                child: Text(
                  "LogOut",
                  style: style,
                  textAlign: TextAlign.center,
                ),
                onPressed: () => logout(context, bloc)),
            ),
          );
        }
        return Container();
      },
    );
  }

  logout(BuildContext context, UserBloc bloc) {
    bloc.logout();
    Navigator.pop(context);
  }

}

