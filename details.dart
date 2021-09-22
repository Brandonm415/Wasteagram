import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Details screen
class Details extends StatelessWidget {
  //Constructor storage
  final String date;
  final int items;
  final String location;
  final String url;
  final String title;

  //Constructor to pass data from the list screen for the details screen
  const Details({Key key, this.date, this.items, this.location, this.url, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        children: [showTitle(), showImage(), showItems(), showDate(), showLocation()],
      )),
    );
  }

  //Helper function to show the date
  Widget showTitle() {
    return Flexible(
        flex: 2,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Text(
            '$title',
            style: TextStyle(fontSize: 20),
          ),
        ));
  }

  //Helper function to show the image
  Widget showImage() {
    return Flexible(
        flex: 2,
        child: Container(
          padding: EdgeInsets.all(10),
          //Source used: https://api.flutter.dev/flutter/widgets/Image-class.html
          child: Image.network(
            url,
            loadingBuilder: (context, child, progress) {
              return progress == null ? child : LinearProgressIndicator();
            },
          ),
        ));
  }

  //Helper function to show number of items
  Widget showItems() {
    return Flexible(
        flex: 2,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Text(
            'Number of items: $items',
            style: TextStyle(fontSize: 20),
          ),
        ));
  }

  //Helper function to show number of items
  Widget showDate() {
    return Flexible(
        flex: 2,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Text(
            'Date Posted: $date',
            style: TextStyle(fontSize: 20),
          ),
        ));
  }

  //Helper function to show location
  Widget showLocation() {
    return Flexible(
      flex: 2,
      child: Container(
          padding: EdgeInsets.all(10),
          child: Text(
            'Location: $location',
            style: TextStyle(fontSize: 20),
          )),
    );
  }
}
