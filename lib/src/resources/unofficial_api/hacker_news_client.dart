import 'dart:io';

import 'package:http/http.dart' show Client;
import 'package:html/parser.dart' show parse;

import '../../models/vote.dart';
import '../../models/user.dart';

class NewsApiClient {
  Cookie _cookie;
  String _username;
  String get username => _username;

  Client _client = Client();
  String _baseUrl = "https://news.ycombinator.com/";

  // Constructor
  NewsApiClient.fromCookieString(username, cookieString) {
    this._cookie = Cookie.fromSetCookieValue(cookieString);
    this._username = username;
  }

  /// Returns instance of [NewsApiClient] if successful, else [null]
  static Future<NewsApiClient> logIn(String username, String password) async {
    Client _client = Client();
    NewsApiClient apiClient;
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Access-Control-Allow-Origin': '*',
    };

    await _client.post(
      "https://news.ycombinator.com/",
      headers: headers,
      body: {"acct": username, "pw": password, "goto": "news"},
    ).then(
      (resp) {
        if (resp.statusCode == 200) {
          if (resp.headers.containsKey('set-cookie')) {
            apiClient = NewsApiClient.fromCookieString(
                username, resp.headers['set-cookie']);
          }
        }
        return apiClient;
      },
    );
    return apiClient;
  }

  Map<String, dynamic> toMapDb() {
    return <String, dynamic>{
      "id": 0,
      "username": _username,
      "client": _cookie.toString()
    };
  }

  /// Returns [Vote] object
  Future<Vote> getVote(int itemId) async {
    Vote vote;
    Map<String, String> headers = {"Cookie": _cookie.toString()};
    await _client.get("${_baseUrl}item?id=$itemId", headers: headers).then(
      (resp) {
        if (resp.statusCode == 200) {
          var doc = parse(resp.bodyBytes);
          var el = doc.getElementById("up_$itemId");

          // element is 'nosee' class - it is voted
          if (el.attributes.containsKey('class')) {
            if (el.attributes['class'] == 'nosee') {
              vote = Vote(el.attributes['href'], true);
            }
          }
          vote ??= Vote(el.attributes['href'], false);
        }
      },
    );

    return vote;
  }

  /// Toogles vote on for item with [itemId]
  Vote toogleVote(Vote vote) {
    String href = vote.hrefUp;
    if (vote.voted == true) {
      href = vote.hrefUn;
    }

    // toogle the button
    _client.get("$_baseUrl$href", headers: {"Cookie": _cookie.toString()});
    // toogle vote object
    vote.voted = !vote.voted;
    return vote;
  }

  postComment(String commentText, int storyId) {}

  replyComment(String replyText, int storyId, int commentId) {}

  submit(String title, String url, String text) {}

  static Future<User> getUserWithUsername(String username) async {
    Client _client = Client();
    User user;
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Access-Control-Allow-Origin': '*',
    };

    await _client
        .get(
      "https://news.ycombinator.com/user?id=$username",
      headers: headers,
    )
        .then(
      (resp) {
        if (resp.statusCode == 200) {
          var doc = parse(resp.bodyBytes);
          var elements = doc.querySelectorAll("tbody");
          var element;
          // looking for proper tbody
          for (var el in elements) {
            if (el.children.length >= 4) {
              element = el;
              break;
            }
          }
          if (element == null) return null;
          // working with tr elements
          elements = element.children;
          int i = 0;
          List<String> params = [];
          while (i < 4) {
            if (elements[i].children[1].children.isNotEmpty) {
              params.add(elements[i].children[1].children[0].innerHtml);
            } else {
              params.add(elements[i].children[1].innerHtml);
            }
            i++;
          }
          user = User(params[0], params[1], int.parse(params[2]), params[3]);
        }
        return user;
      },
    );
    return user;
  }
}
