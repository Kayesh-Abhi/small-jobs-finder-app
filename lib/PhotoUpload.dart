import 'package:flutter/material.dart';
import 'package:flutter_blop_app/Authentication.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'HomePage.dart';

class UploadPhotoPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _UploadPhotoPageState();
  }
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  late String _myValue; //added late key word
  final formKey = GlobalKey<FormState>();
  late String url;

  File? sampleImage; //edited this
  Future getImage() async {
    var tempImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = File(tempImage!.path);
    });
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void uploadStatusImage() async {
    if (validateAndSave()) {
      final Reference postImageRef = FirebaseStorage.instance
          .ref()
          .child("Post Images"); //change Storagereference to reference
      var timeKey = DateTime.now();
      final UploadTask uploadTask =
          postImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImage!);
      var ImageUrl = await (await uploadTask)
          .ref
          .getDownloadURL(); //uploadTask.onComplete removed onComplete
      url = ImageUrl.toString();
      print("Image URL = " + url);

      goToHomePage();
      saveToDatabase(url);
    }
  }

  void saveToDatabase(url) {
    var dbTimeKey = DateTime.now();
    var formatDate = DateFormat('MMM d, yyyy');
    var formatTime = DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data = {
      "image": url,
      "description": _myValue,
      "date": date,
      "time": time,
    };

    ref.child("Posts").push().set(data);
  }

  void goToHomePage() {
    /*Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new HomePage(
        auth: null,
        onSignedOut: () {},
      );
    }));*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload a New Job"),
        centerTitle: true,
      ),
      body: Center(
        child: sampleImage == null ? Text("Select an Image") : enableUpload(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage, //getImage
        tooltip: 'Add Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget enableUpload() {
    return Container(
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Image.file(
              sampleImage!, //sampleImage,
              height: 330.0,
              width: 660.0,
            ),
            SizedBox(
              height: 15.0,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              validator: (value) {
                return value!.isEmpty ? 'Job description is required' : null;
              },
              onSaved: (value) {
                _myValue =
                    value!; //return _myValue = value was the original code
              },
            ),
            SizedBox(
              height: 15.0,
            ),
            RaisedButton(
              elevation: 10.0,
              child: Text("Add a New Job"),
              textColor: Colors.white,
              color: Colors.blue,
              onPressed: uploadStatusImage,
            )
          ],
        ),
      ),
    );
  }
}
