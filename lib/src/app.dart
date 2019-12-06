import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.brown,
      ),
      title: "Hacker News",
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'The hackerNews',
          ),
        ),
      ),
    );
  }
}
