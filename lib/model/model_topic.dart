import 'package:fourm/model/model_reply.dart';

class ForumTopic {
  final String subject;
  final String description;
  final String postedOn;
  final String userName;
  final String userPic;
  final int likes;
  final int dislikes;
  final List<ForumReply> replies;
  bool isExpanded;
  final String call4ActionLabel;
  final String call4ActionUrl;
  final Map taggedUsers;

  ForumTopic({required this.subject, required this.description, required this.postedOn, required this.isExpanded, required this.userName, required this.userPic, required this.likes, required this.dislikes, required this.replies, required this.call4ActionLabel, required this.call4ActionUrl, required this.taggedUsers});

  factory ForumTopic.fromJson(Map<String, dynamic> json) {
    return ForumTopic(subject: json["TopicSubject"], description: json["TopicDescription"], postedOn: json["PostedOn"], userName: json["TopicPostedUserName"], userPic: json["TopicPostedUserPic"], likes: json["TopicLikes"], dislikes: json["TopicDislikes"], replies: (json["TopicReplyList"] as List).map((e) => ForumReply.fromJson(e)).toList(), isExpanded: false, call4ActionLabel: json["Call4ActionLabel"], call4ActionUrl: json["Call4ActionUrl"], taggedUsers: json['TaggedUser']);
  }
}
