import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Comment extends StatelessWidget {
  final String commentUser;
  final String commentText;
  final Timestamp commentTime;
  const Comment(
      {super.key,
      required this.commentUser,
      required this.commentText,
      required this.commentTime});

  @override
  Widget build(BuildContext context) {
    final commentDateTime = commentTime.toDate();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(commentText),
          const SizedBox(
            height: 6,
          ),
          Row(
            children: [
              Text(
                commentUser,
                style: TextStyle(color: Colors.grey[400]),
              ),
              Text(
                " • ",
                style: TextStyle(color: Colors.grey[400]),
              ),
              Text(
                DateFormat("MM/dd HH:MM").format(commentDateTime),
                style: TextStyle(color: Colors.grey[400]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
