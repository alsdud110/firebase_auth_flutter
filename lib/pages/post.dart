import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Post extends StatelessWidget {
  final String currentUser;
  final String text;
  final Timestamp date;
  const Post(
      {super.key,
      required this.currentUser,
      required this.text,
      required this.date});

  @override
  Widget build(BuildContext context) {
    final dateTime = date.toDate();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[400],
            ),
            padding: const EdgeInsets.all(10),
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentUser,
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(text),
            ],
          ),
          const SizedBox(
            width: 45,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: Text(
              DateFormat("MM/dd HH:MM").format(dateTime),
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
