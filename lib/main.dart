import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:breakfreealgo/src/welcomepage.dart';
import 'package:breakfreealgo/src/loadingpage.dart';
import 'package:breakfreealgo/src/errorpage.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: 'Breakfreealgo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme:GoogleFonts.latoTextTheme(textTheme).copyWith(
          bodyText1: GoogleFonts.montserrat(textStyle: textTheme.bodyText1),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
      // home: LoadingPage(),
      // home: ErrorPage(),
    );
  }
}
