import 'package:app_service/Imagegrid.dart';
import 'package:app_service/fastContack.dart';
import 'package:app_service/login.dart';
import 'package:app_service/main.dart';
import 'package:app_service/pmhistory.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'BaiJamjuree'),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/homepage': (context) => const MyHomePage(),
        '/fastcont': (context) => const FastCont(),
        '/uploadImagePage': (context) => const GridViewImage(),
        '/history': (context) => const PmHistory(),
      },
    );
  }
}
