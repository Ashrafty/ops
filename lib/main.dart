import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VPN App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF242425),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: HomeScreen(),
    );
  }
}