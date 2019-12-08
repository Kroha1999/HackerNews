import 'package:flutter/material.dart';

import '../resources/list_type.dart';
import '../blocs/stories_provider.dart';
import '../widgets/news_list/news_list.dart';

class NewsListScreen extends StatefulWidget {
  final StoriesBloc _bloc;
  // Bloc is passed as a parameter for 2 reasons:
  // 1. On passing bloc through provider we can use 
  //    it only at build function which leads to longer
  //    initial loading time
  // 2. On returning from a NewsDetails screen it will 
  //    show proper page results (previoselly showed top
  //    stories results, as bloc was predefined onPageRouteGen
  //    calling fetchListIds for top stories)
  NewsListScreen(this._bloc);
  
  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  ScrollController _scrollController;
  @override
  void initState() {
    widget._bloc.fetchListIds(TypeOfList.TopStories);
    _scrollController = ScrollController();
    _controller = TabController(length: 6, vsync: this);
    _controller.addListener(_tabSwitch);
    super.initState();
  }

  _tabSwitch() {
    widget._bloc.fetchListIds(TypeOfList.values[_controller.index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, bool isScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text("The hackerNews"),
              pinned: true,
              floating: true,
              forceElevated: isScrolled,
              bottom: TabBar(
                isScrollable: true,
                controller: _controller,
                tabs: <Widget>[
                  Tab(child: Text("top")),
                  Tab(child: Text("new")),
                  Tab(child: Text("best")),
                  Tab(child: Text("ask")),
                  Tab(child: Text("show")),
                  Tab(child: Text("job")),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _controller,
          children: <Widget>[
            NewsList(TypeOfList.TopStories),
            NewsList(TypeOfList.NewStories),
            NewsList(TypeOfList.BestStories),
            NewsList(TypeOfList.AskStories),
            NewsList(TypeOfList.ShowStories),
            NewsList(TypeOfList.JobStories),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _controller.dispose();
  }
}
