import 'package:flutter/material.dart';

class NewsDetails extends StatelessWidget {
  
  final int itemId;
  NewsDetails({@required this.itemId});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details: $itemId"),
      ),
    );
  }
}