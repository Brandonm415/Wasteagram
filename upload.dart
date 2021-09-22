import 'dart:convert';
import 'package:wasteagram/models/posts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

//Upload screen
class Upload extends StatefulWidget {
  final String imageURL;

  const Upload({Key key, this.imageURL}) : super(key: key);

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final formKey = GlobalKey<FormState>();

  //Create posts DTO object
  final posts = Posts();

  //Create new fire store instance
  CollectionReference postsDB = FirebaseFirestore.instance.collection('posts');

  //Location storage
  LocationData location;

  @override
  void initState() {
    super.initState();
    retrieveLocation();
  }

  //Get current location
  void retrieveLocation() async {
    var locationService = Location();
    location = await locationService.getLocation();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
        centerTitle: true,
      ),
      body: uploadScreen(),
    );
  }

  //Main upload screen widget
  Widget uploadScreen() {
    return Center(
        child: Form(
      key: formKey,
      child: Column(
        children: [
          imageToUpload(),
          titleField(),
          itemsField(),
          uploadButton(),
        ],
      ),
    ));
  }

  //Display the image for uploading
  Widget imageToUpload() {
    return Flexible(
        flex: 2,
        child: Container(
          //Source used: https://api.flutter.dev/flutter/widgets/Image-class.html
          child: Image.network(
            widget.imageURL,
            loadingBuilder: (context, child, progress) {
              return progress == null ? child : LinearProgressIndicator();
            },
          ),
          padding: EdgeInsets.all(10),
        ));
  }

  //For the upload button
  Widget uploadButton() {
    return Flexible(
        flex: 1,
        child: Container(
            padding: EdgeInsets.all(10),
            child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    //Validate and save on pressed
                    if (formKey.currentState.validate()) {
                      formKey.currentState.save();

                      //Set the posts location
                      posts.location =
                          '${location.latitude}, ${location.longitude}';

                      //Set the posts dateTime
                      posts.dateTime = getDate();

                      //Set the posts image url
                      posts.url = widget.imageURL;

                      //Add the postsDTO data to firestore
                      postsDB.add({
                        'items': posts.items,
                        'location': posts.location,
                        'date': posts.dateTime,
                        'url': posts.url,
                        'title': posts.title
                      });

                      Navigator.of(context).pushReplacementNamed('/');
                    }
                  },
                  child: Text(
                    'Upload',
                    style: TextStyle(fontSize: 20),
                  ),
                ))));
  }

  //For the number of items entry field
  Widget itemsField() {
    return Flexible(
        flex: 2,
        child: Container(
            padding: EdgeInsets.all(10),
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: '# of Items', border: OutlineInputBorder()),
              onSaved: (value) {
                //Update the DTO with entered value
                posts.items = int.parse(value);
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a number';
                } else {
                  return null;
                }
              },
            )));
  }

  //For the number of items entry field
  Widget titleField() {
    return Flexible(
        flex: 2,
        child: Container(
            padding: EdgeInsets.all(10),
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: 'Title of Post', border: OutlineInputBorder()),
              onSaved: (value) {
                //Update the DTO with entered value
                posts.title = value;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a title';
                } else {
                  return null;
                }
              },
            )));
  }

  //Helper function to get date time and turn it into string
  //Source: https://stackoverflow.com/questions/16126579/how-do-i-format-a-date-with-dart
  String getDate() {
    DateTime today = new DateTime.now();
    String weekday = getWeekday(today);
    String month = getMonth(today);
    String date =
        "$weekday-$month-${today.day.toString().padLeft(2, '0')}-${today.year.toString()}";
    return date;
  }

  //Helper function to get weekday as string
  //Source: https://stackoverflow.com/questions/54371874/how-get-the-name-of-the-days-of-the-week-in-dart
  String getWeekday(DateTime day) {
    dynamic dayData =
        '{ "1" : "Mon", "2" : "Tue", "3" : "Wed", "4" : "Thur", "5" : "Fri", "6" : "Sat", "7" : "Sun" }';
    return jsonDecode(dayData)['${day.weekday}'];
  }

  //Helper function to get month as string
  //Source: https://stackoverflow.com/questions/54371874/how-get-the-name-of-the-days-of-the-week-in-dart
  String getMonth(DateTime date) {
    dynamic monthData =
        '{ "1" : "Jan", "2" : "Feb", "3" : "Mar", "4" : "Apr", "5" : "May", "6" : "June", "7" : "Jul", "8" : "Aug", "9" : "Sep", "10" : "Oct", "11" : "Nov", "12" : "Dec" }';
    return jsonDecode(monthData)['${date.month}'];
  }
}
