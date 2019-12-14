import 'package:flutter/material.dart';

import '../../blocs/user_provider.dart';

class LogInDialog extends StatefulWidget {
  @override
  _LogInDialogState createState() => _LogInDialogState();
}

class _LogInDialogState extends State<LogInDialog> {
  UserBloc bloc;
  final _formKey = GlobalKey<FormState>();

  String _username = "";
  String _password = "";

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
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Text("Log in",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              // _username field
              TextFormField(
                decoration: InputDecoration(
                  errorText: _errorText,
                  labelText: "Username",
                  hintText: "Username",
                ),
                onSaved: (value){
                  _username = value;
                },
              ),
              // _password field
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  errorText: _errorText,
                  labelText: "Password",
                  hintText: "Password",
                ),
                onSaved: (value){
                  _password = value;
                },
              ),
              Padding(padding: EdgeInsets.only(top:20),),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  RaisedButton(
                    child: _loading
                      ? Container(width: 10, height: 10, child: CircularProgressIndicator(),)
                      : Text("Submit"),
                    color: Colors.teal,
                    textColor: Colors.white,
                    onPressed: _loading
                              ? null
                              : logIn,
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
    var res = await bloc.setClientWithCredentials(_username, _password);
    if( res != null ){
      // if login was successful
      // returning to home page
      Navigator.of(context, rootNavigator: true).pop();
    }
    // if login was not successful
    setState(() {
      _loading = false;
      _offset = 40;
      _errorText = "Wrong credentials";
    });
  }
}
