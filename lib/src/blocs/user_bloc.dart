import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../models/vote.dart';
import '../models/user.dart';
import '../resources/repository.dart';
import '../resources/unofficial_api/hacker_news_client.dart';

class UserBloc {
  Repository _repository = Repository();
  NewsApiClient _client;

  UserBloc() {
    _getClientFromDb();
  }

  // [true] if registred [false] if not
  final _clientState = BehaviorSubject<bool>();
  final _votes = BehaviorSubject<Vote>();
  final _users = BehaviorSubject<String>();

  // getters Streams
  Observable<bool> get clientState => _clientState.stream;
  Observable<Vote> get voteState => _votes.stream;
  Observable<User> get currentUser => _users.stream.transform(usernameToUser);

  // values
  String get currentUserName => _client.username;

  // Sinks
  get userSink => _users.sink;

  /// Returns [null] not successful login else [NewsApiClient] instance
  setClientWithCredentials(String username, String password) async {
    var client = await NewsApiClient.logIn(username, password);
    if (client != null) {
      _client = client;
      // saving user to DB
      _repository.setClient(client);
      // notifying system about registered user
      _setClientState(true);
      return client;
    }
    return null;
  }

  _setClientState(bool v) {
    _clientState.sink.add(v);
  }

  _getClientFromDb() async {
    await _repository.isDbLoaded();
    // _repository.clearClient();
    _client = await _repository.fetchClient();

    if (_client == null) {
      _setClientState(false);
    } else {
      _setClientState(true);
    }
  }

  /// fetch vote with [id]
  fetchVote(int id) {
    clientState.listen((logged) async {
      if (logged && _client != null) {
        _votes.sink.add(null);
        var vote = await _client.getVote(id);
        _votes.sink.add(vote);
      }
    });
  }

  toogleVote(Vote vote) async {
    // putting vote button to inactive state
    _votes.sink.add(null);
    // wait half a secod is much more efficient then to make another http request 
    await Future.delayed(Duration(milliseconds: 500));
    // add to a sink updated vote
    _votes.sink.add(_client.toogleVote(vote));
  }

  logout() {
    // notifying system about logout
    _setClientState(false);
    _repository.clearClient();
  }

  // Transformers
  var usernameToUser = StreamTransformer<String, User>.fromHandlers(
      handleData: (String username, EventSink<User> sink) async {
    User user = await NewsApiClient.getUserWithUsername(username);
    sink.add(user);
  });

  void dispose() {
    _clientState.close();
    _votes.close();
    _users.close();
  }
}
