import 'package:firebase_post/auth/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_post/theme/dark_theme.dart';
import 'package:firebase_post/theme/ligth_theme.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const AuthPage(),
    );
  }
}
