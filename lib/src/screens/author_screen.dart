import 'package:flutter/material.dart';

import '../widgets/user_widgets/user_details.dart';
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
          // User details Widget
          return UserDetails(user);
        },
      ),
    );
  }

 
}
