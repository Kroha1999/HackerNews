import 'package:flutter/material.dart';
import 'package:hacker_news/src/blocs/user_provider.dart';

class SubmitForm extends StatefulWidget {
  @override
  _SubmitFormState createState() => _SubmitFormState();
}

class _SubmitFormState extends State<SubmitForm> {
  final _formKey = GlobalKey<FormState>();
  UserBloc bloc;

  String title;
  String url;
  String text;

  String errorText;

  bool loading = false;

  final style = TextStyle(
    fontSize: 24,
  );
  @override
  Widget build(BuildContext context) {
    bloc = UserProvider.of(context);
    return Container(
      padding: EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                maxLength: 80,
                decoration: InputDecoration(
                  labelText: "Title",
                  labelStyle: style,
                  hintText: "Look what happened!",
                ),
                validator: (val) {
                  if (val == '') {
                    return "Please enter a title";
                  }
                  return null;
                },
                onSaved: (val) => title = val,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Url",
                  labelStyle: style,
                  hintText: "https://news.ycombinator.com",
                  errorText: errorText,
                ),
                validator: (val) {
                  if (val.length > 0) {
                    // http://a.io - 11 symbols
                    if (val.length < 11) {
                      return "Wrong url";
                    } else if (val.substring(0, 4) != "http") {
                      return 'Url must start with "http" or "https"';
                    }
                  }
                  return null;
                },
                onSaved: (val) => url = val,
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Text(
                "OR",
                style: TextStyle(color: Colors.grey),
              ),
              // Padding(padding: EdgeInsets.only(top: 10)),
              TextFormField(
                maxLines: null,
                decoration: InputDecoration(
                  labelText: "Text",
                  labelStyle: style,
                  hintText: "Let me ask you about something",
                  errorText: errorText,
                ),
                onSaved: (val) => text = val,
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Text(
                "Leave url blank to submit a question for discussion. " +
                    "If there is no url, the text (if any) will appear at the " +
                    "top of the thread.",
                style: TextStyle(color: Colors.grey),
              ),
              Padding(padding: EdgeInsets.only(top: 30)),
              Center(
                child: Container(
                  height: 50,
                  width: 150,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.teal[400],
                    textColor: Colors.white,
                    padding: EdgeInsets.all(10),
                    disabledColor: Colors.grey,
                    child: loading
                        ? Container(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            ),
                          )
                        : Text(
                            "Submit",
                            style: TextStyle(fontSize: 20),
                          ),
                    onPressed: loading ? null : () => submit(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  submit() async {
    // Makes common mistake for url and text field null in case it was fixed
    // for 1 of the fields.
    setState(() {
      errorText = null;
    });

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print("TITLE: $title, \nURL: $url, \nTEXT: $text");
      // In case both url and text were entered.
      if (url != '' && text != '') {
        setState(() {
          errorText = "url or text must be empty";
        });
        return;
        // In case neither url nor text were entered.
      } else if (url == '' && text == '') {
        setState(() {
          errorText = "url or text must be entered";
        });
        return;
      } else {
        setState(() {
          errorText = null;
          loading = true;
        });
      }
      // Submits values to bloc: in case responce is true - success snackbar
      // and move to the main screen, else failure snackbar.
      bool success = await bloc.submitStory(title, url, text);

      setState(() {
        loading = false;
      });

      // TODO: Make a notification class which will settle snackbar for showing
      // wornings, errors and success messages and calling apropriate actions
      if (success == null) {
        Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.teal,
          content: Text(
              "Your session may expired or service may be temporarily unavailable, \nplease try to relogin. "),
        ));
      }
      if (success) {
        Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text("Submited!"),
        ));
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.orange,
          content: Text("Something went wrong, you may post too often."),
        ));
      }
    }
  }
}
