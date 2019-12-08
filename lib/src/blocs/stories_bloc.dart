import 'package:rxdart/rxdart.dart';

import '../models/item_model.dart';
import '../resources/repository.dart';

class StoriesBloc {
  final _repository = Repository();
  // Subjects (PublishSubject, PublishSubject, ...) in RxDart ==
  // StreamController (+ couple of additional functions)
  // Observable in RxDart == Stream (+ couple of additional functions)

  // TopIds stream
  final _topIds = PublishSubject<List<int>>();
  // items Streams => divided in input and output stream in order not to
  // duplicate events by transformer as output is listened by many widgets
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _itemsFetcher = PublishSubject<int>();

  // Getters to get Streams
  Observable<List<int>> get topIds => _topIds.stream;
  Observable<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream;

  // Getters to Sinks
  get fetchItem => _itemsFetcher.sink.add;

  fetchListIds(TypeOfList type) async {
    final ids = await _repository.fetchListIds(type);
    _topIds.sink.add(ids);
  }

  clearCache() async {
    _repository.clearCache();
  }

  StoriesBloc() {
    // This constructor is needed for transforming stream and
    // to have the only one "cahce" instance from the transformer
    // func. for each StreamBuilder in UI classes. In case we will
    // apply this transformer to the topIds items we will create
    // "cache" instance for each of streambuilder using the getter
    _itemsFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
  }

  _itemsTransformer() {
    // cahce - previous map, id - id of event,
    // index - number of ScanStreamTransformer was called
    return ScanStreamTransformer(
      (Map<int, Future<ItemModel>> cache, int id, index) {
        cache[id] = _repository.fetchItem(id);
        return cache;
      },
      <int, Future<ItemModel>>{},
    );
  }

  dispose() {
    _topIds.close();
    _itemsFetcher.close();
    _itemsOutput.close();
  }
}
