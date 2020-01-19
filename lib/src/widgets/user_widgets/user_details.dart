import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../blocs/user_provider.dart';
import '../../mixins/url_mixin.dart';
import '../../models/user.dart';
import '../../widgets/user_widgets/logout_button.dart';

class UserDetails extends StatelessWidget with UrlMixin {
  const UserDetails(this.user);

  final User user;

  @override
  Widget build(BuildContext context) {
    final bloc = UserProvider.of(context);
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'User: ${user.userId}',
                  style: GoogleFonts.openSans(fontSize: 20),
                ),
                Text(
                  'Created: ${user.created}',
                  style: GoogleFonts.openSans(fontSize: 20),
                ),
                Text(
                  'Karma: ${user.karma}',
                  style: GoogleFonts.openSans(fontSize: 20),
                ),
                Text(
                  'About: ',
                  style: GoogleFonts.openSans(fontSize: 20),
                ),
                Html(
                  defaultTextStyle: GoogleFonts.openSans(fontSize: 20),
                  data: user.about,
                  onLinkTap: (link) => launchURL(link),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(),
          ),
          user.userId == bloc.currentUserName
              ? const LogOutButton()
              : Container(),
        ],
      ),
    );
  }
}
