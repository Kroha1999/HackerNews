import 'package:flutter/material.dart';

import '../widgets/user_widgets/submit_form.dart';

class SubmitScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Submit"),
      ),
      body: SubmitForm(),
    );
  }
}
