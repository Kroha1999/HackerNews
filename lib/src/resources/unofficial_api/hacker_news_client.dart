import 'dart:io';

import 'package:http/http.dart' show Client, Response, Request;
import 'package:html/parser.dart' show parse;

// TODO: UNOFFICIAL API
class NewsApiClient {
  Cookie _cookie;

  Client _client = Client();
  String _baseUrl = "https://news.ycombinator.com/";

  // Constructors
  NewsApiClient.fromCookie(this._cookie);
  
  NewsApiClient.fromCookieString(cookieString) {
    this._cookie = Cookie.fromSetCookieValue(cookieString);
  }

  Map<String, dynamic> toMapDb(){
    return <String, dynamic>{
      "id":0,
      "client":_cookie.toString()
    };
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
            apiClient = NewsApiClient.fromCookie(Cookie.fromSetCookieValue(resp.headers['set-cookie']));
            print("Cookie: $apiClient");
          }
        }
        return apiClient;
      },
    );
    return apiClient;
  }

  /// Returns [Vote] object
  Future<Vote> _getVoteAuth(int itemId) async {
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
  toogleVote(int itemId, {Vote vote}) async {
    if (vote == null) vote = await _getVoteAuth(itemId);
    String href = vote.hrefUp;
    if (vote.voted == true) {
      href = vote.hrefUn;
    }

    // toogle the button
    _client
        .get("$_baseUrl$href", headers: {"Cookie": _cookie.toString()});
  }

  postComment(String commentText, int storyId) {}

  replyComment(String replyText, int storyId, int commentId) {}

  submit(String title, String url, String text) {}
}

class Vote {
  /// href link to voteup
  final String hrefUp;

  /// href link to unvote
  get hrefUn => hrefUp.replaceFirst("how=up", "how=un");

  /// [true] if voted up [false] if no
  final bool voted;
  Vote(this.hrefUp, this.voted);
}

class User{
  // UserId = UserName
  String userId;
  // Days ago
  int created; 
  int karma;
  String about;

  //Not public information
  String email;
  User(this.userId,this.created,this.karma,this.about,{this.email});

}