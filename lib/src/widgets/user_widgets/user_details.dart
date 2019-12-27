import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../blocs/user_provider.dart';
import '../../mixins/url_mixin.dart';
import '../../models/user.dart';
import '../../widgets/user_widgets/logout_button.dart';

class UserDetails extends StatelessWidget with UrlMixin{
  final User user;
  UserDetails(this.user);

  final style = GoogleFonts.openSans(fontSize: 20);
  @override
  Widget build(BuildContext context) {
    UserBloc bloc = UserProvider.of(context);
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SingleChildScrollView(
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
                  "About: ",
                  style: style,
                ),
                Html(
                  defaultTextStyle: style,
                  data: user.about,
                  onLinkTap: (link) => launchURL(link),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(),
          ),
          user.userId == bloc.currentUserName ? LogOutButton() : Container(),
        ],
      ),
    );
  }
}
