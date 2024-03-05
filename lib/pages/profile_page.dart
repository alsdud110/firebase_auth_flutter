import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_post/components/my_text_box.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  Future<void> editField(String field) async {
    String newValue = "";

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          "Edit $field",
        ),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Enter New $field",
          ),
          // TextField 에 글이 채워질 때마다 newValue에 값을 넣어둔다.
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          GestureDetector(
            onTap: () {
              newValue = "";
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );

    if (newValue.trim().isNotEmpty) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser.email)
          .update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          "P R O F I L E",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Icon(
                  Icons.person,
                  size: 72,
                ),
                Text(
                  currentUser.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    "My Details",
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                MyTextBox(
                  text: userData["username"],
                  sectionName: "username",
                  onPressed: () {
                    editField("username");
                  },
                ),
                MyTextBox(
                  text: userData["bio"],
                  sectionName: "bio",
                  onPressed: () {
                    editField("bio");
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    "My Posts",
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error : ${snapshot.error}"),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
