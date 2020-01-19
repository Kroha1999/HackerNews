import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'blocs/comments_provider.dart';
import 'blocs/stories_provider.dart';
import 'blocs/user_provider.dart';
import 'screens/author_screen.dart';
import 'screens/news_details_screen.dart';
import 'screens/news_list_screen.dart';
import 'screens/submit_screen.dart';

class App extends StatelessWidget {
  const App();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return UserProvider(
      child: StoriesProvider(
        child: CommentsProvider(
          child: MaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.teal,
              textTheme: GoogleFonts.merriweatherTextTheme(theme),
              primaryTextTheme: GoogleFonts.merriweatherTextTheme(theme)
                  .apply(bodyColor: Colors.white),
            ),
            title: 'Hacker News',
            onGenerateRoute: routes,
          ),
        ),
      ),
    );
  }

  Route routes(RouteSettings settings) {
    if (settings.name.length > 6) {
      // Submit news screen
      if (settings.name == '/submit') {
        return MaterialPageRoute(builder: (context) {
          return const SubmitScreen();
        });
      }
      // NewsDetails route with specific [id]
      if (settings.name.substring(0, 6) == '/news/') {
        return MaterialPageRoute(
          builder: (context) {
            final id = int.parse(settings.name.substring(6));
            final userBloc = UserProvider.of(context);
            final commentsBloc = CommentsProvider.of(context);
            // Fetches data for specific item
            userBloc.fetchVote(id);
            commentsBloc.fetchItemWithComments(id);
            return NewsDetailsScreen(itemId: id);
          },
        );
      }
      // AuthorScreen route with specific [username] string
      if (settings.name.substring(0, 6) == '/user/') {
        return MaterialPageRoute(
          builder: (context) {
            final userBloc = UserProvider.of(context);
            final author = settings.name.substring(6);
            userBloc.userSink.add(author);
            return const AuthorScreen();
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
