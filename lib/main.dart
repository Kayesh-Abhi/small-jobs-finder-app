import 'package:flutter/material.dart';
import 'package:flutter_blop_app/Authentication.dart';
import 'package:flutter_blop_app/HomePage.dart';
import 'package:flutter_blop_app/LoginRegisterPage.dart';
import 'Mapping.dart';
import 'Authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(BlogApp());
}

class BlogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "blog app",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MappingPage(
        auth: Auth(),
      ),
    );
  }
}
