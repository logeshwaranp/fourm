import 'package:flutter/material.dart';

class Comment {
  final String name;
  final String message;
  final String time;
  int likes;
  int dislikes;
  bool isLiked;
  bool isDisliked;
  final List<Reply> replies;
  bool isExpanded;

  Comment({required this.name, required this.message, required this.time, required this.likes, this.dislikes = 0, this.isLiked = false, this.isDisliked = false, this.isExpanded = false, required this.replies});
}

class Reply {
  final String name;
  final String message;
  final String time;

  Reply({required this.name, required this.message, required this.time});
}

class FourmUiScreen extends StatefulWidget {
  const FourmUiScreen({super.key});

  @override
  State<FourmUiScreen> createState() => _FourmUiScreenState();
}

class _FourmUiScreenState extends State<FourmUiScreen> {
  List<Comment> comments = [
    Comment(
      name: "Kiran Kumar",
      message: "test user",
      time: "2 months ago",
      likes: 1,
      dislikes: 0,
      replies: [Reply(name: "Jamshed", message: "Hello 👋", time: "2 months ago")],
    ),
    Comment(
      name: "Kiran Kumar",
      message: "test user",
      time: "2 months ago",
      likes: 1,
      dislikes: 2,
      replies: [
        Reply(name: "Jamshed", message: "Hello 👋", time: "2 months ago"),
        Reply(name: "Jamshed", message: "Hi 👋", time: "3 months ago"),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              children: [
                const CircleAvatar(radius: 20, child: Icon(Icons.person)),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Jyoti A", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("QA · Nov 21, 11:06 AM", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),

                const Icon(Icons.more_vert),
              ],
            ),

            const SizedBox(height: 16),

            /// Title
            const Text("Regression Testing", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 8),

            /// Description
            const Text("Regression Testing", style: TextStyle(fontSize: 14)),

            const SizedBox(height: 16),

            /// Actions
            Row(children: const [Icon(Icons.thumb_up_alt_outlined, size: 18), SizedBox(width: 6), Text("1"), SizedBox(width: 24), Icon(Icons.chat_bubble_outline, size: 18), SizedBox(width: 6), Text("0")]),
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  CommentsSection(comments: comments),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReplyCard extends StatelessWidget {
  final Reply reply;

  const ReplyCard({super.key, required this.reply});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(radius: 14, child: Icon(Icons.person, size: 14)),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(reply.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(width: 6),
                    Text(reply.time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),

                const SizedBox(height: 3),

                Text(reply.message, style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CommentCard extends StatelessWidget {
  final Comment comment;
  final VoidCallback onLike;
  final VoidCallback onDislike;

  const CommentCard({super.key, required this.comment, required this.onLike, required this.onDislike});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(radius: 18, child: Icon(Icons.person)),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Name + Time
                Row(
                  children: [
                    Text(comment.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 6),
                    Text(comment.time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),

                const SizedBox(height: 4),

                Text(comment.message),

                const SizedBox(height: 6),

                /// Actions
                Row(
                  children: [
                    /// Like
                    GestureDetector(
                      onTap: onLike,
                      child: Row(
                        children: [
                          Icon(comment.isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined, size: 16, color: comment.isLiked ? Colors.blue : null),
                          const SizedBox(width: 4),
                          Text("${comment.likes}"),
                        ],
                      ),
                    ),

                    const SizedBox(width: 20),

                    /// Dislike
                    GestureDetector(
                      onTap: onDislike,
                      child: Row(
                        children: [
                          Icon(comment.isDisliked ? Icons.thumb_down : Icons.thumb_down_alt_outlined, size: 16, color: comment.isDisliked ? Colors.red : null),
                          const SizedBox(width: 4),
                          Text("${comment.dislikes}"),
                        ],
                      ),
                    ),

                    const SizedBox(width: 20),

                    const Text(
                      "Reply",
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Icon(Icons.more_vert, size: 18),
        ],
      ),
    );
  }
}

class CommentsSection extends StatefulWidget {
  final List<Comment> comments;

  const CommentsSection({super.key, required this.comments});

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.comments.length,
      itemBuilder: (context, index) {
        final comment = widget.comments[index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommentCard(
              comment: comment,

              onLike: () {
                setState(() {
                  if (comment.isLiked) {
                    comment.likes--;
                    comment.isLiked = false;
                  } else {
                    comment.likes++;
                    comment.isLiked = true;

                    if (comment.isDisliked) {
                      comment.dislikes--;
                      comment.isDisliked = false;
                    }
                  }
                });
              },

              onDislike: () {
                setState(() {
                  if (comment.isDisliked) {
                    comment.dislikes--;
                    comment.isDisliked = false;
                  } else {
                    comment.dislikes++;
                    comment.isDisliked = true;

                    if (comment.isLiked) {
                      comment.likes--;
                      comment.isLiked = false;
                    }
                  }
                });
              },
            ),

            /// View replies button
            if (comment.replies.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 50, top: 4),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      comment.isExpanded = !comment.isExpanded;
                    });
                  },
                  child: Text(
                    comment.isExpanded ? "Hide replies" : "View replies (${comment.replies.length})",
                    style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                  ),
                ),
              ),

            /// Replies
            if (comment.isExpanded)
              Padding(
                padding: const EdgeInsets.only(left: 50, top: 6),
                child: Column(children: comment.replies.map((reply) => ReplyCard(reply: reply)).toList()),
              ),

            const SizedBox(height: 10),
          ],
        );
      },
    );
  }
}
