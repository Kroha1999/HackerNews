class User {
  User(
    this.userId,
    this.created,
    this.karma,
    this.about,
  );

  // UserId = UserName
  String userId;
  // Days ago
  String created;
  int karma;
  String about;
}
