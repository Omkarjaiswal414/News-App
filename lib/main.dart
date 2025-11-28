import 'package:flutter/material.dart';
import 'package:flutter_news_app/ArticlesProvider.dart';
import 'package:flutter_news_app/data.dart';
import 'package:flutter_news_app/homepage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) {
        final provider = ArticlesProvider();
        // Initialize with existing data
        provider.initializeWithData(likedArticles, savedArticles);
        return provider;
      },
      child: MyNewsApp(),
    ),
  );
}

class MyNewsApp extends StatelessWidget {
  const MyNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadePageTransitionsBuilder(),
          },
        ),
        useMaterial3: true,
        brightness: Brightness.dark,    
        scaffoldBackgroundColor: Colors.black, 
        textTheme: GoogleFonts.interTextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      home: Homepage(),
    );
  }
}

class FadePageTransitionsBuilder extends PageTransitionsBuilder {
  const FadePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}