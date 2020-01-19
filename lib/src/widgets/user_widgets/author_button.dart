import 'package:flutter/material.dart';
import 'package:hacker_news/src/blocs/user_provider.dart';

class AuthorButton extends StatelessWidget {
  const AuthorButton(this.author, {this.color = Colors.grey});

  final String author;
  final Color color;

  @override
  Widget build(BuildContext context) {
    Color userColor = color;
    if (author == UserProvider.of(context).currentUserName) {
      userColor = Colors.teal;
    }
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/user/$author'),
      child: Text(
        'by: $author',
        style: TextStyle(color: userColor),
      ),
    );
  }
}
