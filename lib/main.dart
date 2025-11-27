import 'package:flutter/material.dart';
import 'package:flutter_news_app/homepage.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyNewsApp());
}

class MyNewsApp extends StatelessWidget {
  const MyNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,    
        scaffoldBackgroundColor: Colors.black, 
        textTheme: GoogleFonts.interTextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        ),
      
      home: Homepage()
      );
  }
}
