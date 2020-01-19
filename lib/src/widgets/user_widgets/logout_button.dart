import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../blocs/user_provider.dart';
import '../../mixins/notification_mixin.dart';

class LogOutButton extends StatelessWidget with NotificationMixin {
  const LogOutButton();

  @override
  Widget build(BuildContext context) {
    final bloc = UserProvider.of(context);
    return StreamBuilder(
      stream: bloc.clientState,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        if (snapshot.data) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              child: RaisedButton(
                  padding: const EdgeInsets.all(5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.0),
                    // side: BorderSide(color: Colors.tealAccent)
                  ),
                  color: Colors.teal,
                  textColor: Colors.white,
                  child: Text(
                    'LogOut',
                    style: GoogleFonts.openSans(fontSize: 20),
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
    showFlushBar(context, 'Logged Out');
  }
}
