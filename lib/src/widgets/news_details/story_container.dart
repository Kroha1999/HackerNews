import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

import '../../widgets/user_widgets/author_button.dart';
import '../../widgets/user_widgets/comment_button.dart';
import '../../widgets/user_widgets/vote_button.dart';
import '../../mixins/url_mixin.dart';
import '../../mixins/date_mixin.dart';
import '../../models/item_model.dart';

class NewsContainer extends StatelessWidget with UrlMixin, DateMixin {
  final ItemModel item;
  NewsContainer({@required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 6,
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(15),
                  child: Text(
                    item.title,
                    maxLines: 5,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Link (if present)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  VoteButton(30),
                  SizedBox(
                    width: 30,
                  ),
                  IconButton(
                    iconSize: 50,
                    icon: Icon(Icons.launch),
                    onPressed: item.url == "" || item.url == null
                        ? null
                        : () => launchURL(item.url),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  CommentButton(30, item),
                ],
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 30,
                    right: 30,
                    bottom: 10,
                    top: 0,
                  ),
                  child: Text(
                    "${item.url}",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          //Bottom line
          Row(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(left: 10)),
              AuthorButton(
                item.by,
                color: Colors.black,
              ),
              Text(
                " ~ ${timeAgo(item.time)}",
                style: TextStyle(color: Colors.grey),
              ),
              Expanded(child: Container()),
              item.score < 100
                  ? Icon(
                      Icons.ac_unit,
                      color: Colors.blue,
                      size: 22,
                    )
                  : Icon(
                      OMIcons.whatshot,
                      color: item.score < 200 ? Colors.orange : Colors.red,
                      size: 22,
                    ),
              Text(
                '${item.score}',
                style: GoogleFonts.openSans(),
              ),
              Padding(padding: EdgeInsets.only(right: 5)),
              Icon(
                OMIcons.forum,
                color: Colors.teal,
              ),
              Text(
                '${item.descendants}',
                style: GoogleFonts.openSans(),
              ),
              Padding(padding: EdgeInsets.only(right: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
