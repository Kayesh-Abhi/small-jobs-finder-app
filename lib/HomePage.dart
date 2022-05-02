import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'PhotoUpload.dart';
import 'Posts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'PaymentPage.dart';

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
        Posts posts = Posts(
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Available Jobs"),
      ),
      floatingActionButton: FloatingActionButton(
        //chat bot button
        child: Icon(Icons.message),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => PaymentPage()));
        },
      ),
      body: Container(
        child: postsList.length == 0
            ? Text("No Job Postings available")
            : ListView.builder(
                itemCount: postsList.length,
                itemBuilder: (_, index) {
                  return PostsUI(
                      postsList[index].image,
                      postsList[index].description,
                      postsList[index].date,
                      postsList[index].time);
                }),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Container(
          margin: const EdgeInsets.only(left: 70.0, right: 70.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                visualDensity: VisualDensity(horizontal: -4.0),
                padding: EdgeInsets.zero,
                icon: Icon(Icons.logout),
                iconSize: 30,
                color: Colors.white,
                onPressed: _logoutUser,
              ),
              IconButton(
                visualDensity: VisualDensity(horizontal: -4.0),
                padding: EdgeInsets.zero,
                icon: Icon(Icons.search_rounded),
                iconSize: 30,
                color: Colors.white,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PaymentPage()));
                },
              ),
              IconButton(
                icon: Icon(Icons.add_circle_rounded),
                iconSize: 50,
                color: Colors.white,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return UploadPhotoPage();
                  }));
                },
              ),
              IconButton(
                visualDensity: VisualDensity(horizontal: -4.0),
                padding: EdgeInsets.zero,
                icon: Icon(Icons.location_on_rounded),
                iconSize: 30,
                color: Colors.white,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PaymentPage()));
                },
              ),
              IconButton(
                visualDensity: VisualDensity(horizontal: -4.0),
                padding: EdgeInsets.zero,
                icon: Icon(Icons.payment),
                iconSize: 30,
                color: Colors.white,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PaymentPage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget PostsUI(String image, String description, String date, String time) {
    return Card(
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),
      child: Container(
        padding: new EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  date,
                  style: Theme.of(context).textTheme.subtitle2,
                  textAlign: TextAlign.center,
                ),
                Text(
                  time,
                  style: Theme.of(context).textTheme.subtitle2,
                  textAlign: TextAlign.center,
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Image.network(image, fit: BoxFit.cover),
            SizedBox(
              height: 10.0,
            ),
            Text(
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
