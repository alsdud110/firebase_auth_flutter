import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_post/components/comment.dart';
import 'package:firebase_post/components/comment_button.dart';
import 'package:firebase_post/components/like_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class Post extends StatefulWidget {
  final String currentUser;
  final String text;
  final Timestamp date;
  final String postId;
  final List<String> likes;
  const Post(
      {super.key,
      required this.currentUser,
      required this.text,
      required this.date,
      required this.postId,
      required this.likes});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  final _editingTextController = TextEditingController();

  @override
  void initState() {
    if (widget.likes.contains(currentUser.email)) {
      isLiked = true;
    }
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection("User Posts").doc(widget.postId);

    if (isLiked) {
      postRef.update({
        "Likes": FieldValue.arrayUnion([currentUser.email]),
      });
    } else {
      postRef.update({
        "Likes": FieldValue.arrayRemove([currentUser.email]),
      });
    }
  }

  void addComment(String comment) async {
    await FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add(
      {
        "CommentText": comment,
        "CommentedBy": currentUser.email,
        "CommentTime": DateTime.now(),
      },
    );
  }

  void showCommentDialog() {
    _editingTextController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text(
          "Add Comment",
        ),
        content: TextField(
          autofocus: true,
          controller: _editingTextController,
          decoration: const InputDecoration(
            hintText: "Add a Comment",
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              addComment(_editingTextController.text);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  void deletePostDialog(String postId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: const Text("Delete Post"),
          content: const Text("정말로 삭제하시겠습니까?"),
          actions: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                deletePost(postId);
                Navigator.pop(context);
              },
              child: const Text("Delete"),
            )
          ],
        );
      },
    );
  }

  void deletePost(String postId) {
    FirebaseFirestore.instance.collection("User Posts").doc(postId).delete();
  }

  @override
  Widget build(BuildContext context) {
    final dateTime = widget.date.toDate();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.text),
              currentUser.email == widget.currentUser
                  ? GestureDetector(
                      onTap: () {
                        deletePostDialog(widget.postId);
                      },
                      child: const Icon(
                        Icons.delete_forever_rounded,
                      ),
                    )
                  : const SizedBox()
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.currentUser,
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
              Text(
                DateFormat("MM/dd HH:MM").format(dateTime),
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  LikeButton(isLiked: isLiked, onTap: toggleLike),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.likes.length.toString(),
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  CommentButton(onTap: showCommentDialog),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "0",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("User Posts")
                .doc(widget.postId)
                .collection("Comments")
                .orderBy("CommentTime", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs
                    .map(
                      (e) => Comment(
                        commentText: e["CommentText"],
                        commentTime: e["CommentTime"],
                        commentUser: e["CommentedBy"],
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
