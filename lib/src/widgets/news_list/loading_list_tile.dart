import 'package:flutter/material.dart';

class LoadingListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[50],
      margin: EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: 10,
      ),
      elevation: 2.5,
      child: Column(
        children: <Widget>[
          Container(
            height: 75,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                greyField(320),
                greyField(150),
              ],
            ),
          ),
          Divider(
            height: 4,
            thickness: 0.6,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
            height: 30,
            child: Row(
              children: <Widget>[
                greyField(110, height: 14),
                Expanded(child: Container()),
                greyField(80, height: 14),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container greyField(double width, {double height = 20}) {
    return Container(
      color: Colors.black12,
      height: height,
      width: width,
      margin: EdgeInsets.only(
        top: 5.0,
        bottom: 5.0,
      ),
    );
  }
}
