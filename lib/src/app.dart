import 'package:flutter/material.dart';

import 'screens/news_list_screen.dart';
import 'screens/news_details_screen.dart';
import 'blocs/stories_provider.dart';
import 'blocs/comments_provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoriesProvider(
      child: CommentsProvider(
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.teal,
            fontFamily: "Merriweather",
          ),
          title: "Hacker News",
          onGenerateRoute: routes,
        ),
      ),
    );
  }

  Route routes(RouteSettings settings) {
    if (settings.name.length > 6) {
      //NewsDetails route with specific [id]
      if (settings.name.substring(0, 6) == '/news/') {
        return MaterialPageRoute(
          builder: (context) {
            final id = int.parse(settings.name.substring(6));
            final commentsBloc = CommentsProvider.of(context);
            // Fetches data for specific item
            commentsBloc.fetchItemWithComments(id);
            return NewsDetailsScreen(itemId: id);
          },
        );
      }
    }
    //default route '/'
    return MaterialPageRoute(builder: (context) {
      final storiesBloc = StoriesProvider.of(context);
      return NewsListScreen(storiesBloc);
    });
  }
}
