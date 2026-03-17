import 'package:fourm/model/model_sub_reply.dart';

class ForumReply {
  final String id;
  final String description;
  final String postedOn;
  final String userName;
  final String userPic;
  final int likes;
  final int dislikes;
  final List<ForumSubReply> subReplies;
  bool isExpanded;

  ForumReply({required this.id, required this.description, required this.postedOn, required this.isExpanded, required this.userName, required this.userPic, required this.likes, required this.dislikes, required this.subReplies});

  factory ForumReply.fromJson(Map<String, dynamic> json) {
    return ForumReply(id: json["ReplyID"], description: json["ReplyDescription"], postedOn: json["ReplyPostedOn"], userName: json["ReplyPostedUserName"], userPic: json["ReplyPostedUserPic"], likes: json["ReplyLikes"], dislikes: json["ReplyDislikes"], subReplies: (json["Reply4ReplyList"] as List).map((e) => ForumSubReply.fromJson(e)).toList(), isExpanded: false);
  }
}
