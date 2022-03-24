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
  runApp(new BlogApp());
}

class BlogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "blog app",
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MappingPage(
        auth: Auth(),
      ),
    );
  }
}
