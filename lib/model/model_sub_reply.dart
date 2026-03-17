class ForumSubReply {
  final String id;
  final String description;
  final String postedOn;
  final String userName;
  final String userPic;
  final int likes;
  final int dislikes;

  ForumSubReply({required this.id, required this.description, required this.postedOn, required this.userName, required this.userPic, required this.likes, required this.dislikes});

  factory ForumSubReply.fromJson(Map<String, dynamic> json) {
    return ForumSubReply(id: json["ReplyID"], description: json["ReplyDescription"], postedOn: json["ReplyPostedOn"], userName: json["ReplyPostedUserName"], userPic: json["ReplyPostedUserPic"], likes: json["ReplyLikes"], dislikes: json["ReplyDislikes"]);
  }
}
