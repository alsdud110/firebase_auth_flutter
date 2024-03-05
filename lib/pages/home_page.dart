import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_post/components/drawer.dart';
import 'package:firebase_post/components/text_field.dart';
import 'package:firebase_post/pages/post.dart';
import 'package:firebase_post/pages/profile_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser!.email;
  final textController = TextEditingController();
  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void postMessage() {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Posts").add({
        "UserEmail": currentUser,
        "Message": textController.text,
        "Timestamp": Timestamp.now(),
        "Likes": [],
      });
    }

    textController.clear();
  }

  void goToProfilePage() {
    Navigator.pop(context);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ProfilePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onLogoutTap: signOut,
      ),
      appBar: AppBar(
        title: const Text(
          "P O S T",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .orderBy("Timestamp", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data!.docs[index];
                        return Post(
                          currentUser: post["UserEmail"],
                          text: post["Message"],
                          date: post["Timestamp"],
                          postId: post.id,
                          likes: List<String>.from(
                            post["Likes"] ?? [],
                          ),
                        );
                      },
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
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                        controller: textController,
                        hintText: "Write a post..",
                        obsecureText: false),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  IconButton(
                      onPressed: postMessage,
                      icon: const Icon(Icons.arrow_circle_right_outlined)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Logged in as : $currentUser"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
