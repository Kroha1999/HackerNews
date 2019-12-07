import 'package:flutter/material.dart';
import 'package:hacker_news/src/models/item_model.dart';

class NewsContainer extends StatelessWidget {
  final ItemModel item;
  NewsContainer({@required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.all(15),
            child: Text(
              item.title,
              maxLines: 5,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          //Bottom line
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  left: 10,
                ),
              ),
              Text("by: ${item.by}"),
              Expanded(
                child: Container(),
              ),
              Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              Text('${item.score}'),
              Padding(
                padding: EdgeInsets.only(
                  right: 5,
                ),
              ),
              Icon(
                Icons.comment,
                color: Colors.teal,
              ),
              Text('${item.descendants}'),
              Padding(
                padding: EdgeInsets.only(
                  right: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
