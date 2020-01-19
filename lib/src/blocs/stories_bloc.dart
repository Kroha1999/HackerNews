import 'package:rxdart/rxdart.dart';

import '../models/item_model.dart';
import '../resources/repository.dart';

class StoriesBloc {
  StoriesBloc() {
    // This constructor is needed for transforming stream and
    // to have the only one "cahce" instance from the transformer
    // func. for each StreamBuilder in UI classes. In case we will
    // apply this transformer to the topIds items we will create
    // "cache" instance for each of streambuilder using the getter
    _itemsFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
    _initIdsStreams();
  }

  final _repository = Repository();
  // Subjects (PublishSubject, PublishSubject, ...) in RxDart ==
  // StreamController (+ couple of additional functions)
  // Observable in RxDart == Stream (+ couple of additional functions)

  // List of streams for each of category which provides separate list
  // for each newsList
  final Map<TypeOfList, PublishSubject<List<int>>> listsIds = {};
  // items Streams => divided in input and output stream in order not to
  // duplicate events by transformer as output is listened by many widgets
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _itemsFetcher = PublishSubject<int>();

  // Getters to get Streams
  // Observable<List<int>> get topIds => _topIds.stream;
  Observable<List<int>> listIdsStream(TypeOfList type) => listsIds[type].stream;
  Observable<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream;

  // Getters to Sinks
  get fetchItem => _itemsFetcher.sink.add;

  fetchListIds(TypeOfList type) async {
    final ids = await _repository.fetchListIds(type);
    listsIds[type].sink.add(ids);
  }

  clearCache() async {
    _repository.clearCache();
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

  _initIdsStreams() {
    for (TypeOfList type in TypeOfList.values) {
      listsIds[type] = PublishSubject<List<int>>();
    }
  }

  _closeIdsStreams() {
    listsIds.forEach((type, obs) => obs.close());
  }

  dispose() {
    _closeIdsStreams();
    _itemsFetcher.close();
    _itemsOutput.close();
  }
}
