import 'package:flutter/material.dart';

import 'screens/news_list_screen.dart';
import 'screens/news_details.dart';
import 'blocs/stories_provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoriesProvider(
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.teal,
          fontFamily: "OpenSans",
        ),
        title: "Hacker News",
        onGenerateRoute: routes,
      ),
    );
  }

  Route routes(RouteSettings settings) {
    if (settings.name.length > 6) {
      //NewsDetails route
      if (settings.name.substring(0, 6) == '/news/') {
        final id = int.parse(settings.name.substring(6));
        return MaterialPageRoute(
          builder: (context) {
            return NewsDetails(itemId: id);
          },
        );
      }
    }
    //default route '/'
    return MaterialPageRoute(builder: (context) {
      return NewsListScreen();
    });
  }
}
