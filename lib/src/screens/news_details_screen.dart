import 'package:flutter/material.dart';
import '../widgets/news_details/news_details_body.dart';

class NewsDetailsScreen extends StatelessWidget {  
  final int itemId;
  NewsDetailsScreen({@required this.itemId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event details: $itemId"),
      ),
      body: NewsDetailsBody(itemId:itemId),
    );
  }
}