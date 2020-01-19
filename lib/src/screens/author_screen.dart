import 'package:flutter/material.dart';

import '../blocs/user_provider.dart';
import '../models/user.dart';
import '../widgets/user_widgets/user_details.dart';

class AuthorScreen extends StatelessWidget {
  const AuthorScreen();

  @override
  Widget build(BuildContext context) {
    final bloc = UserProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Author details'),
      ),
      body: StreamBuilder(
        stream: bloc.currentUser,
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Container(
                width: 50,
                height: 50,
                child: const CircularProgressIndicator(),
              ),
            );
          }
          final user = snapshot.data;
          // User details Widget
          return UserDetails(user);
        },
      ),
    );
  }
}
