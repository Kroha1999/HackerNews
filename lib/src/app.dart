import 'package:flutter/material.dart';

import 'screens/news_list_screen.dart';
import 'blocs/stories_provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoriesProvider(
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.brown,
          fontFamily: "OpenSans"
        ),
        title: "Hacker News",
        home: NewsListScreen(),
      ),
    );
  }
}
