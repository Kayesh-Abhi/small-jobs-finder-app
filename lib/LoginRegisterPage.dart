import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blop_app/Authentication.dart';
import 'package:flutter_blop_app/DialogBox.dart';
import 'Authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;

class LoginRegisterPage extends StatefulWidget {
  LoginRegisterPage({
    required this.auth, //added required keywords
    required this.onSignedIn, //added required keywords
  });

  final AuthImplementation auth;
  final VoidCallback onSignedIn;

  State<StatefulWidget> createState() {
    return _LoginRegisterState();
  }
}

enum FormType { login, register }

class _LoginRegisterState extends State<LoginRegisterPage> {
  DialogBox dialogBox = DialogBox();

  final formKey = GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = "";
  String _password = "";

  //methods

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          String userId = await widget.auth.SignIn(_email, _password);
          //dialogBox.information(context, "Congratulations", "You are logged in successfully.");
          print("login userId = " + userId);
        } else {
          String userId = await widget.auth.SignUp(_email, _password);
          dialogBox.information(context, "Congratulations!",
              "Your account has been created successfully.");
          print("Register userId = " + userId);

          //Registration Email
          final serviceId = 'service_9a7r71d';
          final templateId = 'template_l69vj1j';
          final userrId = '13rBjaYSOBb5X-sTe';

          final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
          final response = await http.post(
            url,
            headers: {
              'origin': 'http://localhost',
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'service_id': serviceId,
              'template_id': templateId,
              'user_id': userrId,
              'template_params': {
                'to_name': _email,
                'to_email': _email,
              },
            }),
          );
          print("email status: " + response.body);
        }
        widget.onSignedIn();
      } catch (e) {
        dialogBox.information(context, "Error", e.toString());
        print("Error = " + e.toString());
      }
    }
  }

  void moveToRegister() {
    formKey.currentState?.reset();

    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState?.reset();

    setState(() {
      _formType = FormType.login;
    });
  }

  //Design

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Small Job Finder App"),
      ),
      body: Container(
        margin: EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: createInputs() + createButtons(),
          ),
        ),
      ),
    );
  }

  List<Widget> createInputs() {
    return [
      SizedBox(
        height: 10.0,
      ),
      logo(),
      SizedBox(
        height: 20.0,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Email'),
        validator: (value) {
          return value!.isEmpty ? 'Email is required.' : null;
        },
        onSaved: (value) {
          _email = value!;
        },
      ),
      SizedBox(
        height: 10.0,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value) {
          return value!.isEmpty ? 'Password is Required.' : null;
        },
        onSaved: (value) {
          _password = value!;
        },
      ),
      SizedBox(
        height: 20.0,
      ),
    ];
  }

  Widget logo() {
    return Hero(
      tag: 'hero', //i added this
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 110.0,
        child: Image.asset('images/logo.png'),
      ),
    );
  }

  List<Widget> createButtons() {
    if (_formType == FormType.login) {
      return [
        RaisedButton(
          child: Text("Login", style: TextStyle(fontSize: 20)),
          textColor: Colors.white,
          color: Colors.blue,
          onPressed: validateAndSubmit,
        ),
        FlatButton(
          child: Text("Don't have an account? Create now.",
              style: TextStyle(fontSize: 14)),
          textColor: Colors.blue,
          onPressed: moveToRegister,
        ),
      ];
    } else {
      return [
        RaisedButton(
          child: Text("Create Account", style: TextStyle(fontSize: 20)),
          textColor: Colors.white,
          color: Colors.blue,
          onPressed: validateAndSubmit,
        ),
        FlatButton(
          child: Text("Already have an account? Login",
              style: TextStyle(fontSize: 14)),
          textColor: Colors.blue,
          onPressed: moveToLogin,
        ),
      ];
    }
    ;
  }
}
