class User {
  // UserId = UserName
  String userId;
  // Days ago
  int created;
  int karma;
  String about;

  //Not public information
  String email;
  User(this.userId, this.created, this.karma, this.about, {this.email});
}
