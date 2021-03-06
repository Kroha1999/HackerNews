class Vote {
  Vote(this.hrefUp, this.voted);

  /// href link to voteup
  final String hrefUp;

  /// href link to unvote
  get hrefUn => hrefUp.replaceFirst('how=up', 'how=un');

  /// [true] if voted up [false] if no
  bool voted;
}
