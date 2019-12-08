import 'package:flutter/material.dart';

import '../resources/list_type.dart';
import '../blocs/stories_provider.dart';
import '../widgets/news_list/news_list.dart';

class NewsListScreen extends StatefulWidget {
  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> with SingleTickerProviderStateMixin{

  TabController _controller;
  StoriesBloc _bloc;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3,vsync: this);
    _controller.addListener(_tabSwitch);
  }

  _tabSwitch(){
    if(_controller.index == 0) _bloc.fetchListIds(TypeOfList.TopStories);
    if(_controller.index == 1) _bloc.fetchListIds(TypeOfList.NewStories);
    if(_controller.index == 2) _bloc.fetchListIds(TypeOfList.BestStories);
  }

  @override
  Widget build(BuildContext context) {
    _bloc = StoriesProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'The hackerNews',
        ),
        bottom: TabBar(
          controller: _controller,
          tabs: <Widget>[
            Tab(child: Text("top")),
            Tab(child: Text("new")),
            Tab(child: Text("best")),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: <Widget>[
          NewsList(TypeOfList.TopStories),
          NewsList(TypeOfList.NewStories),
          NewsList(TypeOfList.BestStories),
        ],
      )
    );
  }
}
