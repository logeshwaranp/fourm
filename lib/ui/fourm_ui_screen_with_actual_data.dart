import 'package:flutter/material.dart';
import 'package:fourm/response.dart';
import 'package:fourm/ui/chat_input_box.dart';

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

class FourmUiScreenActual extends StatefulWidget {
  const FourmUiScreenActual({super.key});

  @override
  State<FourmUiScreenActual> createState() => _FourmUiScreenActualState();
}

class _FourmUiScreenActualState extends State<FourmUiScreenActual> {
  late ForumTopic topic;

  @override
  void initState() {
    super.initState();
    topic = ForumTopic.fromJson(response["TopicInfo"] as Map<String, dynamic>);
  }

  bool isExpanded = false;

  Widget taggedUsersWidget(ForumTopic users) {
    final userList = users.taggedUsers['UserInfoList'] as List;
    final String header = users.taggedUsers['Header'] ?? "TAGGED TEAM";

    return GestureDetector(
      onTap: () => setState(() => isExpanded = !isExpanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutQuart,
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isExpanded ? Colors.blue.shade50.withOpacity(0.5) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isExpanded ? Colors.blue.shade100 : Colors.transparent),
        ),
        child: Column(
          children: [
            /// THE TOP BAR (Always Visible)
            Row(
              children: [
                Text(
                  header.toUpperCase(),
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.2, color: Colors.blueGrey.shade400),
                ),
                const Spacer(),
                // Animated Arrow
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(Icons.keyboard_arrow_down_rounded, color: isExpanded ? Colors.blue : Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// THE SWITCHING CONTENT
            AnimatedCrossFade(firstChild: _buildCollapsedPile(userList), secondChild: _buildExpandedList(userList), crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst, duration: const Duration(milliseconds: 300)),
          ],
        ),
      ),
    );
  }

  /// 1. COLLAPSED VIEW (Face-pile)
  Widget _buildCollapsedPile(List userList) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          height: 35,
          child: Stack(
            children: List.generate(userList.length > 3 ? 3 : userList.length, (index) => Positioned(left: index * 24.0, child: _circularAvatar(userList[index]["ProfilePicture"], 16))),
          ),
        ),
        Text("+${userList.length} members tagged", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }

  /// 2. EXPANDED VIEW (Modern Tiles)
  Widget _buildExpandedList(List userList) {
    return Column(
      children: [
        const SizedBox(height: 10),
        ...userList
            .map(
              (user) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    _circularAvatar(user["ProfilePicture"], 18),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${user["FirstName"]} ${user["LastName"]}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text(user["Position"] ?? "", style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                      ],
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  /// Helper for Avatar
  Widget _circularAvatar(String? url, double radius) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: CircleAvatar(radius: radius, backgroundImage: url != null ? NetworkImage(url) : null, child: url == null ? const Icon(Icons.person, size: 16) : null),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forum")),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      /// MAIN CARD
                      Container(
                        margin: const EdgeInsets.only(top: 25, left: 8, right: 8, bottom: 10),
                        padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(40), bottomLeft: Radius.circular(4), bottomRight: Radius.circular(40)),
                          boxShadow: [BoxShadow(color: const Color(0xFF6366F1).withOpacity(0.08), blurRadius: 30, offset: const Offset(0, 15))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// DATE CHIP (Floating look)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: Colors.blue.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                topic.postedOn.toUpperCase(),
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2, color: Colors.blue.shade700),
                              ),
                            ),

                            const SizedBox(height: 12),

                            /// SUBJECT
                            Text(
                              topic.subject,
                              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, fontFamily: 'Outfit', color: Color(0xFF0F172A), height: 1.1),
                            ),

                            const SizedBox(height: 14),

                            /// DESCRIPTION
                            Text(topic.description, style: TextStyle(fontSize: 15, color: Colors.blueGrey.shade600, height: 1.5, letterSpacing: 0.2)),

                            const SizedBox(height: 20),

                            /// TAGS SECTION (Minimalist)
                            taggedUsersWidget(topic),

                            const SizedBox(height: 25),

                            /// MINIMALIST ACTION BAR
                            Row(
                              children: [
                                // Like & Dislike Group
                                Container(
                                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(30)),
                                  child: Row(
                                    children: [
                                      _minimalAction(Icons.thumb_up_alt_outlined, "${topic.likes}", Colors.blue, false),
                                      Container(width: 1, height: 15, color: Colors.grey.shade300),
                                      _minimalAction(Icons.thumb_down_alt_outlined, "", Colors.redAccent, false),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                // Comments
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showComments = !showComments;
                                    });
                                  },
                                  child: _minimalAction(Icons.messenger_outline_rounded, "${topic.replies.length} Comments", Colors.black87, true),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      /// FLOATING AVATAR & NAME
                      Positioned(
                        top: 0,
                        left: 36,
                        child: Row(
                          children: [
                            Hero(
                              tag: topic.userName,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                child: CircleAvatar(radius: 28, backgroundColor: Colors.blue.shade100, backgroundImage: NetworkImage(topic.userPic)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 25),
                                Text(
                                  topic.userName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    shadows: [Shadow(color: Colors.white, blurRadius: 10)],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(children: [if (showComments) CommentsSection(replies: topic.replies)]),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: CommentInputBox(
              onSubmit: (comment, file) {
                if (file != null) {}
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Helper for the super clean action buttons
  Widget _minimalAction(IconData icon, String label, Color color, bool isCommtes) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          if (label.isNotEmpty) ...[const SizedBox(width: 6), Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13))],
          if (showComments && isCommtes) Icon(Icons.keyboard_arrow_up_outlined, size: 18, color: color),
          if (!showComments && isCommtes) Icon(Icons.keyboard_arrow_down_outlined, size: 18, color: color),
        ],
      ),
    );
  }

  bool showComments = false;
}

class CommentsSection extends StatefulWidget {
  final List<ForumReply> replies;

  const CommentsSection({super.key, required this.replies});

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.replies.map((reply) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// PRIMARY COMMENT
              _buildCommentItem(userPic: reply.userPic, userName: reply.userName, postedOn: reply.postedOn, description: reply.description, likes: reply.likes, dislikes: reply.dislikes, isSubReply: false),

              /// VIEW REPLIES BUTTON
              if (reply.subReplies.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 42, top: 4),
                  child: InkWell(
                    onTap: () => setState(() => reply.isExpanded = !reply.isExpanded),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 12, height: 2, color: Colors.blue.withOpacity(0.3)),
                          const SizedBox(width: 8),
                          Text(
                            reply.isExpanded ? "Hide replies" : "View ${reply.subReplies.length} replies",
                            style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w800, fontSize: 12),
                          ),
                          Icon(reply.isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 16, color: Colors.blue),
                        ],
                      ),
                    ),
                  ),
                ),

              /// SUB REPLIES
              if (reply.subReplies.isNotEmpty && reply.isExpanded)
                Padding(
                  padding: const EdgeInsets.only(left: 28),
                  child: Column(
                    children: reply.subReplies.map((sub) {
                      return _buildCommentItem(userPic: sub.userPic, userName: sub.userName, postedOn: sub.postedOn, description: sub.description, likes: sub.likes, dislikes: sub.dislikes, isSubReply: true);
                    }).toList(),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCommentItem({required String userPic, required String userName, required String postedOn, required String description, required int likes, required int dislikes, required bool isSubReply}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TIMELINE LINE
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(top: 14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSubReply ? Colors.grey.shade300 : Colors.blue.shade200,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
              Expanded(child: Container(width: 2, color: Colors.grey.shade200)),
            ],
          ),
          const SizedBox(width: 12),

          /// CONTENT CARD
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSubReply ? Colors.grey.shade50 : Colors.white,
                borderRadius: BorderRadius.only(topRight: const Radius.circular(16), bottomLeft: const Radius.circular(16), bottomRight: const Radius.circular(16), topLeft: isSubReply ? const Radius.circular(16) : Radius.zero),
                border: isSubReply ? null : Border.all(color: Colors.grey.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(radius: 12, backgroundImage: NetworkImage(userPic)),
                      const SizedBox(width: 8),
                      Text(userName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                      const Spacer(),
                      Text(postedOn, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                      const Icon(Icons.more_horiz, size: 16, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(description, style: TextStyle(fontSize: 14, color: Colors.blueGrey.shade800, height: 1.4)),
                  const SizedBox(height: 12),

                  /// ACTION ROW (Like, Dislike, Reply)
                  Row(
                    children: [
                      /// REACTION CAPSULE
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(color: isSubReply ? Colors.white : Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            _reactionButton(Icons.thumb_up_alt_outlined, "$likes", Colors.blue, false, () {}),
                            Container(width: 1, height: 12, color: Colors.grey.shade300, margin: const EdgeInsets.symmetric(horizontal: 2)),
                            _reactionButton(Icons.thumb_down_alt_outlined, "$dislikes", Colors.redAccent, false, () {}),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),

                      /// REPLY BUTTON
                      InkWell(
                        onTap: () {},
                        child: Row(
                          children: [
                            Icon(Icons.reply_rounded, size: 16, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            const Text(
                              "Reply",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// HELPER FOR REACTION BUTTONS
  Widget _reactionButton(IconData icon, String label, Color color, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 14, color: isActive ? color : Colors.blueGrey.shade400),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: isActive ? color : Colors.blueGrey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
