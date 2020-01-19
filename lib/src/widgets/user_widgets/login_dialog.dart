import 'package:flutter/material.dart';

import '../../blocs/user_provider.dart';
import '../../mixins/notification_mixin.dart';

class LogInDialog extends StatefulWidget {
  const LogInDialog();

  @override
  _LogInDialogState createState() => _LogInDialogState();
}

class _LogInDialogState extends State<LogInDialog> with NotificationMixin {
  UserBloc bloc;
  final _formKey = GlobalKey<FormState>();

  String _username = '';
  String _password = '';

  String _errorText;
  double _offset = 0;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bloc = UserProvider.of(context);
    return Dialog(
      child: Container(
        height: 260 + _offset,
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Text('Log In',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              // _username field
              TextFormField(
                decoration: InputDecoration(
                  errorText: _errorText,
                  labelText: 'Username',
                  hintText: 'Username',
                ),
                onSaved: (value) {
                  _username = value;
                },
              ),
              // _password field
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  errorText: _errorText,
                  labelText: 'Password',
                  hintText: 'Password',
                ),
                onSaved: (value) {
                  _password = value;
                },
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  RaisedButton(
                    child: _loading
                        ? Container(
                            width: 10,
                            height: 10,
                            child: const CircularProgressIndicator(),
                          )
                        : const Text('Submit'),
                    color: Colors.teal,
                    textColor: Colors.white,
                    onPressed: _loading ? null : logIn,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // loggin in function
  logIn() async {
    _formKey.currentState.save();
    setState(() {
      _loading = true;
    });
    final res = await bloc.setClientWithCredentials(_username, _password);
    if (res != null) {
      // if login was successful
      // returning to home page
      Navigator.of(context, rootNavigator: true).pop();
      showFlushBar(context, 'Logged in as $_username');
      return;
    }
    // if login was not successful
    setState(() {
      _loading = false;
      _offset = 50;
      _errorText = 'Wrong credentials';
      showFlushBar(context, 'Wrong credentials', status: Status.warning);
    });
  }
}
