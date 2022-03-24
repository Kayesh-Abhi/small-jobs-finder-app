import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blop_app/Authentication.dart';
import 'package:flutter_blop_app/DialogBox.dart';
import 'Authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

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
  DialogBox dialogBox = new DialogBox();

  final formKey = new GlobalKey<FormState>();
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
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new Text("Small Job Finder App"),
      ),
      body: new Container(
        margin: EdgeInsets.all(15.0),
        child: new Form(
          key: formKey,
          child: new Column(
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
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Email'),
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
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Password'),
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
    return new Hero(
      tag: 'hero', //i added this
      child: new CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 110.0,
        child: Image.asset('images/logo.png'),
      ),
    );
  }

  List<Widget> createButtons() {
    if (_formType == FormType.login) {
      return [
        new RaisedButton(
          child: new Text("Login", style: new TextStyle(fontSize: 20)),
          textColor: Colors.white,
          color: Colors.blue,
          onPressed: validateAndSubmit,
        ),
        new FlatButton(
          child: new Text("Not have an account? Create account.",
              style: new TextStyle(fontSize: 14)),
          textColor: Colors.blue,
          onPressed: moveToRegister,
        ),
      ];
    } else {
      return [
        new RaisedButton(
          child: new Text("Create Account", style: new TextStyle(fontSize: 20)),
          textColor: Colors.white,
          color: Colors.blue,
          onPressed: validateAndSubmit,
        ),
        new FlatButton(
          child: new Text("Already have an account? Login",
              style: new TextStyle(fontSize: 14)),
          textColor: Colors.blue,
          onPressed: moveToLogin,
        ),
      ];
    }
    ;
  }
}
