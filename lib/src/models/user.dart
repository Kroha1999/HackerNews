class User {
  // UserId = UserName
  String userId;
  // Days ago
  String created;
  int karma;
  String about;

  //Not public information
  String email;
  User(this.userId, this.created, this.karma, this.about, {this.email});
}
