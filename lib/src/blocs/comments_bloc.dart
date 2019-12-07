import 'package:rxdart/rxdart.dart';

import '../models/item_model.dart';
import '../resources/repository.dart';

class CommentsBloc {
  final _repository = Repository();
  final _commentsFetcher = PublishSubject<int>();
  final _commentsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();

  // Stream getters
  Observable<Map<int, Future<ItemModel>>> get itemWithComments =>
      _commentsOutput.stream;

  // Stream adders
  Function(int) get fetchItemWithComments => _commentsFetcher.sink.add;

  CommentsBloc() {
    _commentsFetcher.stream
        .transform(_commentsTransformer())
        .pipe(_commentsOutput);
  }

  // Recursive transformer that fetches kids (comments)
  // waits for comments to load, then looks for 
  _commentsTransformer() {
    return ScanStreamTransformer<int, Map<int, Future<ItemModel>>>(
      (Map<int, Future<ItemModel>> cache, int id, int index) {
        cache[id] = _repository.fetchItem(id);
        // as cahce[id] is the Future instance
        // so as soon as data will be loaded
        // we are passing each kid to to fetch
        // information about comment and for it's
        // subcomments, until we reach empty list 
        cache[id].then((ItemModel item){
          for(var kidId in item.kids){
            fetchItemWithComments(kidId);
          }
        });
        return cache;
      },
      <int, Future<ItemModel>>{},
    );
  }

  dispose() {
    _commentsFetcher.close();
    _commentsOutput.close();
  }
}
