import 'package:flutter/material.dart';

import '../../blocs/user_provider.dart';
import '../../mixins/notification_mixin.dart';

class SubmitForm extends StatefulWidget {
  const SubmitForm();

  @override
  _SubmitFormState createState() => _SubmitFormState();
}

class _SubmitFormState extends State<SubmitForm> with NotificationMixin {
  final _formKey = GlobalKey<FormState>();
  UserBloc bloc;

  String title;
  String url;
  String text;

  String errorText;

  bool loading = false;

  final style = const TextStyle(
    fontSize: 24,
  );
  @override
  Widget build(BuildContext context) {
    bloc = UserProvider.of(context);
    return GestureDetector(
      // Removes keyboard ontap outside
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  maxLength: 80,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: style,
                    hintText: 'Look what happened!',
                  ),
                  validator: (val) {
                    if (val == '') {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (val) => title = val,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Url',
                    labelStyle: style,
                    hintText: 'https://news.ycombinator.com',
                    errorText: errorText,
                  ),
                  validator: (val) {
                    if (val.isNotEmpty) {
                      // http://a.io - 11 symbols
                      if (val.length < 11) {
                        return 'Wrong url';
                      } else if (val.substring(0, 4) != 'http') {
                        return 'Url must start with "http" or "https"';
                      }
                    }
                    return null;
                  },
                  onSaved: (val) => url = val,
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                const Text(
                  'OR',
                  style: TextStyle(color: Colors.grey),
                ),
                TextFormField(
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: 'Text',
                    labelStyle: style,
                    hintText: 'Let me ask you about something',
                    errorText: errorText,
                  ),
                  onSaved: (val) => text = val,
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                const Text(
                  'Leave url blank to submit a question for discussion. '
                  'If there is no url, the text (if any) will appear at the '
                  'top of the thread.',
                  style: TextStyle(color: Colors.grey),
                ),
                const Padding(padding: EdgeInsets.only(top: 30)),
                Center(
                  child: Container(
                    height: 50,
                    width: 150,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.teal[400],
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(10),
                      disabledColor: Colors.grey,
                      child: loading
                          ? Container(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              ),
                            )
                          : const Text(
                              'Submit',
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
      ),
    );
  }

  submit() async {
    // Makes common mistake for url and text field null in case it was fixed
    // for 1 of the fields.
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      errorText = null;
    });

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      // In case both url and text were entered.
      if (url != '' && text != '') {
        setState(() {
          errorText = 'url or text must be empty';
        });
        return;
        // In case neither url nor text were entered.
      } else if (url == '' && text == '') {
        setState(() {
          errorText = 'url or text must be entered';
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
      final success = await bloc.submitStory(title, url, text);

      setState(() {
        loading = false;
      });

      if (success == null) {
        // Session may expire some times when user logged out from other device or web
        // in this case we will log out
        Navigator.pop(context);
        showFlushBar(
          context,
          'Your session may expired or service may be temporarily unavailable, \nplease login again.',
          status: Status.error,
          seconds: 5,
        );
        bloc.logout();
      } else if (success) {
        Navigator.pop(context);
        showFlushBar(
          context,
          'Success',
        );
      } else {
        showFlushBar(
          context,
          'Something went wrong, you may post too often.',
          status: Status.warning,
        );
      }
    }
  }
}
