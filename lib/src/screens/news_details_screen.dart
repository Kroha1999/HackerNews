import 'package:flutter/material.dart';
import '../widgets/news_details/news_details_body.dart';

class NewsDetailsScreen extends StatelessWidget {
  const NewsDetailsScreen({@required this.itemId});

  final int itemId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event details'),
      ),
      body: NewsDetailsBody(itemId: itemId),
    );
  }
}
