import 'package:flutter/material.dart';
import 'package:hacker_news/src/blocs/stories_provider.dart';

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    //DON'T DO SO -> TODO: CHANGE LATER
    bloc.fetchTopIds();

    return StreamBuilder(
      stream: bloc.topIds,
      builder: (context, AsyncSnapshot<List<int>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Container(
              child: CircularProgressIndicator(),
              height: 100,
              width: 100,
            ),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, int index) {
            return Text("${snapshot.data[index]}");
          },
        );
      },
    );
  }
}
