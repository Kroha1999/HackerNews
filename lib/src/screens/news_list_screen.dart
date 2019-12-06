import 'package:flutter/material.dart';

import '../widgets/news_list.dart';
import '../blocs/stories_provider.dart';

class NewsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'The hackerNews',
        ),
      ),
      body: NewsList(),
    );
  }
}
