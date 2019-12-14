import 'package:hacker_news/src/resources/repository.dart';

import 'package:rxdart/rxdart.dart';

import '../resources/unofficial_api/hacker_news_client.dart';
import '../resources/repository.dart';

class UserBloc {
  Repository _repository;
  NewsApiClient _client;

  UserBloc() {
    _repository = Repository();
    setClient();
  }

  setClient() async {
    _client = await _repository.fetchClient();

    if (_client == null) {
      setClientState(false);
    } else {
      setClientState(true);
    }
  }

  // [true] if registred [false] if not
  final _clientState = BehaviorSubject<bool>();

  // getters
  Observable<bool> get clientState => _clientState.stream;

  // setters
  setClientState(bool v) {
    _clientState.sink.add(v);
  }

  void dispose() {
    _clientState.close();
  }
}
