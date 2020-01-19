import 'package:flutter/material.dart';

import '../../blocs/user_provider.dart';

class GoToSubmitButton extends StatelessWidget {
  const GoToSubmitButton();

  @override
  Widget build(BuildContext context) {
    final bloc = UserProvider.of(context);

    return Container(
      width: 50,
      height: 50,
      child: StreamBuilder(
        stream: bloc.clientState,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          if (snapshot.data) {
            return IconButton(
              tooltip: 'submit',
              icon: Icon(Icons.chat_bubble_outline),
              onPressed: () => Navigator.pushNamed(context, '/submit'),
            );
          }

          return Container();
        },
      ),
    );
  }
}
