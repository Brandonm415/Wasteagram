import 'package:flutter/material.dart';
import 'package:wasteagram/screens/details.dart';
import 'screens/list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wasteagram/screens/upload.dart';
import 'screens/details.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  //Routes
  static final routes = {
    '/': (context) => Lists(),
    'Upload': (context) => Upload(),
    'Details': (context) => Details()
  };

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wasteagram',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: MyApp.routes,
    );
  }
}
