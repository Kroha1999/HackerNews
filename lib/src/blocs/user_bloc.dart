import 'dart:async';

import 'package:hacker_news/src/models/vote.dart';
import 'package:hacker_news/src/resources/repository.dart';

import 'package:rxdart/rxdart.dart';

import '../resources/unofficial_api/hacker_news_client.dart';
import '../resources/repository.dart';

class UserBloc {
  Repository _repository = Repository();
  NewsApiClient _client;

  UserBloc() {
    _getClientFromDb();
  }

  _getClientFromDb() async {
    //TODO: call this initializator on datebase loaded
    // not simply wait or it

    await Future.delayed(Duration(seconds: 2));
    _repository.clearClient();
    _client = await _repository.fetchClient();

    if (_client == null) {
      _setClientState(false);
    } else {
      _setClientState(true);
    }
  }

  // [true] if registred [false] if not
  final _clientState = BehaviorSubject<bool>();
  final _votes = BehaviorSubject<Vote>();

  // getters
  Observable<bool> get clientState => _clientState.stream;
  Observable<Vote> get voteState => _votes.stream;

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

  /// fetch vote with [id]
  fetchVote(int id) {
    clientState.listen((logged) async{
      if (logged) {
        _votes.sink.add(null);
        var vote = await _client.getVote(id);
        _votes.sink.add(vote);
      }
    });
  }

  toogleVote(Vote vote) {
    // add to a sink updated vote
    _votes.sink.add(_client.toogleVote(vote));
  }

  _setClientState(bool v) {
    _clientState.sink.add(v);
  }

  void dispose() {
    _clientState.close();
    _votes.close();
  }
}
