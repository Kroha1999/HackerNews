import 'package:flutter/material.dart';

import '../../blocs/stories_provider.dart';
import '../../resources/list_type.dart';

class Refresh extends StatelessWidget {
  final Widget child;
  final TypeOfList type;
  Refresh(this.child, {@required this.type});

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    return RefreshIndicator(
      child: child,
      onRefresh: () async {
        await bloc.clearCache();
        bloc.fetchListIds(type);
        
        // Delayed just for better UX as fetching data takes too little time and
        // user may not understand that data was updated
        await Future.delayed(Duration(milliseconds: 400));
      },
    );
  }
}
