import 'package:flutter/material.dart';

class AuthorButton extends StatelessWidget {
  final String author;
  final Color color;
  AuthorButton(this.author, {this.color = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, "/user/$author"),
      child: Text(
        "by: $author",
        style: TextStyle(color: color),
      ),
    );
  }
}
