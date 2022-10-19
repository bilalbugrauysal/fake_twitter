import 'dart:async';
import 'dart:io';

import 'package:fake_twitter/screens/home-page.dart';
import 'package:fake_twitter/twitter-api.dart';
import 'package:flutter/material.dart';

import 'package:twitter_api_v2/twitter_api_v2.dart' as v2;

void main() {
  print("App is running");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: new HomePage(),
    );
  }
}
