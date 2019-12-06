import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';

class StoriesBloc {
  final _repository = Repository();
  // PublishSubject in RxDart == StreamController (+ couple of additional functions)
  // Observable in RxDart == Stream (+ couple of additional functions)
  final _topIds = PublishSubject<List<int>>();

  // Getters to get Streams
  Observable<List<int>> get topIds => _topIds.stream;

  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  dispose() {
    _topIds.close();
  }
}
