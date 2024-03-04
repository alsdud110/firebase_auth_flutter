import 'package:firebase_post/components/my_list_tile.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final Function()? onProfileTap;
  final Function()? onLogoutTap;
  const MyDrawer(
      {super.key, required this.onProfileTap, required this.onLogoutTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Icon(
                  Icons.person,
                  size: 64,
                  color: Colors.grey[200],
                ),
              ),
              MyListTile(
                title: "H O M E",
                icon: const Icon(Icons.home),
                onTap: () => Navigator.pop(context),
              ),
              MyListTile(
                title: "P R O F I L E",
                icon: const Icon(Icons.person),
                onTap: onProfileTap,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: MyListTile(
              title: "L O G O U T",
              icon: const Icon(Icons.logout_outlined),
              onTap: onLogoutTap,
            ),
          ),
        ],
      ),
    );
  }
}
