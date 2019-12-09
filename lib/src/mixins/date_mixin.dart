class DateMixin {
  String timeAgo(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    Duration diff = DateTime.now().difference(dateTime);
    String ago;

    int days = diff.inDays;
    int years = days ~/ 365;
    int month = days ~/ 30;
    int hours = diff.inHours;
    int minutes = diff.inMinutes;
    int seconds = diff.inSeconds;

    if (years >= 1) {
      ago = "$years year${_many(years)} ago";
    } else if (month >= 1) {
      ago = "$month month${_many(month)} ago";
    } else if (days >= 1) {
      ago = "$days day${_many(days)} ago";
    } else if (hours >= 1) {
      ago = "$hours hour${_many(hours)} ago";
    } else if (minutes >= 1) {
      ago = "$minutes minute${_many(minutes)} ago";
    } else if (seconds >= 1) {
      ago = "$seconds second${_many(seconds)} ago";
    } else {
      ago = "just now";
    }
    return ago;
  }

  String _many(int number) {
    return number > 1 ? 's' : '';
  }
}
