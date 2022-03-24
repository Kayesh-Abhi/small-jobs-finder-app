import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'PhotoUpload.dart';
import 'Posts.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  HomePage({
    required this.auth, //added required keywords
    required this.onSignedOut, //added required keywords
  });
  final AuthImplementation auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List<Posts> postsList = [];

  @override
  void initState() {
    super.initState();
    DatabaseReference postsRef =
        FirebaseDatabase.instance.reference().child("Posts");
    postsRef.once().then((snap) {
      //postsRef.once().then((DataSnapshot snap) { original above line
      dynamic keys = snap.snapshot.value;
      dynamic KEYS = keys.keys; //snap.value.keys;
      dynamic DATA = snap.snapshot.value;

      postsList.clear();

      for (var individualKey in KEYS) {
        Posts posts = new Posts(
          DATA[individualKey]['image'],
          DATA[individualKey]['description'],
          DATA[individualKey]['date'],
          DATA[individualKey]['time'],
        );
        postsList.add(posts);
      }
      setState(() {
        print('Length : $postsList.length');
      });
    });
  }

  void _logoutUser() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Available Jobs"),
      ),
      body: new Container(
        child: postsList.length == 0
            ? new Text("No Job Postings available")
            : new ListView.builder(
                itemCount: postsList.length,
                itemBuilder: (_, index) {
                  return PostsUI(
                      postsList[index].image,
                      postsList[index].description,
                      postsList[index].date,
                      postsList[index].time);
                }),
      ),
      bottomNavigationBar: new BottomAppBar(
        color: Colors.blue,
        child: new Container(
          margin: const EdgeInsets.only(left: 70.0, right: 70.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new IconButton(
                icon: new Icon(Icons.logout),
                iconSize: 35,
                color: Colors.white,
                onPressed: _logoutUser,
              ),
              new IconButton(
                icon: new Icon(Icons.add_circle_rounded),
                iconSize: 50,
                color: Colors.white,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return new UploadPhotoPage();
                  }));
                },
              ),
              new IconButton(
                icon: new Icon(Icons.payment),
                iconSize: 35,
                color: Colors.white,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget PostsUI(String image, String description, String date, String time) {
    return new Card(
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),
      child: new Container(
        padding: new EdgeInsets.all(14.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  date,
                  style: Theme.of(context).textTheme.subtitle2,
                  textAlign: TextAlign.center,
                ),
                new Text(
                  time,
                  style: Theme.of(context).textTheme.subtitle2,
                  textAlign: TextAlign.center,
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            new Image.network(image, fit: BoxFit.cover),
            SizedBox(
              height: 10.0,
            ),
            new Text(
              description,
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
