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
  List<Widget> _tabs = [];
  @override
  void initState() {
    widget._bloc.fetchListIds(TypeOfList.values[0]);
    _scrollController = ScrollController();
    _controller = TabController(length: TypeOfList.values.length, vsync: this);
    _controller.animation.addListener(_tabSwitch);
    // Creating tabs from categories (Types of our news)
    TypeOfList.values.forEach(
      (category) => _tabs.add(
        Tab(
          child: Text(
            category
                .toString()
                .replaceFirst("TypeOfList.", "")
                .replaceFirst("Stories", "")
                .toLowerCase(),
          ),
        ),
      ),
    );
    super.initState();
  }

  int _lastCalled = 0;
  bool _triggered = false;
  _tabSwitch() {
    // On jump through more than 1 tabs
    if (_triggered && _controller.indexIsChanging) {
      _triggered = false;
      if (_lastCalled != _controller.index) {
        _lastCalled = _controller.index;
        widget._bloc.fetchListIds(TypeOfList.values[_controller.index]);
      }
      return;
    }
    // Data preloading starts when user moves to 0.2 of the next/previouse page
    if (_controller.offset > 0.2 && !_triggered) {
      _triggered = true;
      _lastCalled = _controller.index + 1;
      widget._bloc.fetchListIds(TypeOfList.values[_controller.index + 1]);
    } else if (_controller.offset < -0.2 && !_triggered) {
      _triggered = true;
      _lastCalled = _controller.index - 1;
      widget._bloc.fetchListIds(TypeOfList.values[_controller.index - 1]);
    }
    // On user decided not to move to the next page
    if (_triggered &&
        (_controller.offset < 0.1) &&
        (_controller.offset > -0.1)) {
      widget._bloc.fetchListIds(TypeOfList.values[_controller.index]);
      _triggered = false;
      _lastCalled = _controller.index;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, bool isScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text(
                "The hackerNews",
                style: TextStyle(fontSize: 25),
              ),
              pinned: true,
              floating: true,
              forceElevated: isScrolled,
              bottom: TabBar(
                  labelStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Merriweather",
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 14,
                    fontFamily: "Merriweather",
                  ),
                  isScrollable: true,
                  controller: _controller,
                  tabs: _tabs),
            ),
          ];
        },
        body: Container(
          color: Colors.grey[50],
          child: TabBarView(
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
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _controller.animation.removeListener(_tabSwitch());
    _controller.dispose();
  }
}
