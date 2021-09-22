import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wasteagram/screens/details.dart';
import 'package:wasteagram/screens/upload.dart';
import 'dart:io';

//List screens
class Lists extends StatefulWidget {
  @override
  _ListsState createState() => _ListsState();
}

class _ListsState extends State<Lists> {
  File image;
  final picker = ImagePicker();

  //For storing URL and passing it to upload screen
  var url;

  //Function to select picture from gallery and upload it to storage
  void getPic() async {
    //Pick image from gallery
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    //Set it to file type for uploading
    image = File(pickedImage.path);

    //Name for image with current date time
    final imageName = getDate();

    //Upload to storage with new name
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(imageName);
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;

    //Set the url
    url = await storageReference.getDownloadURL();

    //Push to upload page and pass the URL to it.
    //Needs to be inside this function or else it will pass a null url
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Upload(
                  imageURL: url,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wasteagram'),
        centerTitle: true,
      ),
      body: PostsList(),
      //Semantics button for uploading
      floatingActionButton: Semantics(
          label: 'Upload post button',
          enabled: true,
          button: true,
          onTapHint: 'Select an image to upload',
          child: FloatingActionButton(
            child: Icon(Icons.camera_alt),
            onPressed: () {
              getPic();
            },
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  //Helper function to get date time and turn it into string. Modified to include hours+mins as well.
  //Source: https://stackoverflow.com/questions/16126579/how-do-i-format-a-date-with-dart
  String getDate() {
    DateTime today = new DateTime.now();
    String date =
        "${today.year.toString()}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')} ${today.hour.toString()}-${today.minute.toString()}";
    return date;
  }
}

//Grab data from firebase and display it as list
//Source used: https://firebase.flutter.dev/docs/firestore/usage
class PostsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');

    return StreamBuilder<QuerySnapshot>(
      stream: posts.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        //If firebase has data display it as a list
        if (snapshot.hasData &&
            snapshot.data.docs != null &&
            snapshot.data.docs.length > 0) {
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                var post = snapshot.data.docs[index];
                //Semantics for the list tiles
                return Semantics(
                    label: 'Tap for details of post',
                    enabled: true,
                    onTapHint: 'Details of the post you selected',
                    child: ListTile(
                      trailing: Text(
                        post['items'].toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                      leading: FlutterLogo(),
                      title: Text(
                        post['title'],
                        style: TextStyle(fontSize: 20),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Details(
                                      date: post['date'],
                                      url: post['url'],
                                      items: post['items'],
                                      location: post['location'],
                                      title: post['title'],
                                    )));
                      },
                    ));
              });
        }
        //If firebase has no data use circular loading picture 
        else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
