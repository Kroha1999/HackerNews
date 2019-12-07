import 'package:flutter/material.dart';

class LoadingListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: greyField(),
          subtitle: greyField(),
        ),
        Divider(height: 8,)
      ],
    );
  }

  Container greyField() {
    return Container(
      color:  Colors.black12,
      height: 20,
      width: 150,
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
    );
  }
}