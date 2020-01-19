import 'package:flutter/material.dart';

import '../widgets/user_widgets/submit_form.dart';

class SubmitScreen extends StatelessWidget {
  const SubmitScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit'),
      ),
      body: const SubmitForm(),
    );
  }
}
