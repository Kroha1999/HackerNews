import 'package:flutter/material.dart';

import '../../blocs/user_provider.dart';
import '../../mixins/notification_mixin.dart';
import '../../models/item_model.dart';

class CommentForm extends StatefulWidget {
  const CommentForm(this.parent);

  final ItemModel parent;

  @override
  _CommentFormState createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> with NotificationMixin {
  final _formKey = GlobalKey<FormState>();
  String text;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final bloc = UserProvider.of(context);
    return Column(
      children: <Widget>[
        Form(
          key: _formKey,
          child: TextFormField(
            decoration: const InputDecoration(
              hintText: 'Comment',
            ),
            maxLines: null,
            onSaved: (str) {
              text = str;
            },
            validator: (str) {
              if (str == '') {
                return "comment can't be empty";
              }
              return null;
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        RaisedButton(
          color: Colors.teal,
          child: loading
              ? Container(
                  width: 10,
                  height: 10,
                  child: const CircularProgressIndicator(),
                )
              : Text(
                  'Post comment',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
          onPressed: loading ? null : () => comment(context, bloc),
        )
      ],
    );
  }

  comment(context, UserBloc bloc) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        loading = true;
      });

      final submited = await bloc.submitComment(text, widget.parent.id);
      if (submited) {
        Navigator.pop(context);
        showFlushBar(context, 'Success!');
      } else {
        showFlushBar(context, 'Something went wrong!', status: Status.warning);
      }
      setState(() {
        loading = false;
      });
    }
  }
}
