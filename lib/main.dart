import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'word_clock.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  static const platform = const MethodChannel('com.lqy.word_clock/sp');
  bool _isScore = true;
  bool _isShift = true;
  bool _isCircle = true;
  Color _backgroundColor;
  Color _backTextColor;
  Color _textColor;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) getSpSetting();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: WordClock(
        isScore: _isScore,
        isShift: _isShift,
        isCircle: _isCircle,
        backgroundColor: _backgroundColor,
        backTextColor: _backTextColor,
        textColor: _textColor,
      ),
    );
  }

  void getSpSetting() async {
    try {
      final List<Object> result = await platform.invokeMethod('getSpSetting');
      print(result);
      if (result.length == 6) {
        setState(() {
          _isScore = result[0] as bool;
          _isShift = result[1] as bool;
          _isCircle = result[2] as bool;
          _backgroundColor = Color(result[3] as int);
          _backTextColor = Color(result[4] as int);
          _textColor = Color(result[5] as int);
        });
      }
    } on PlatformException catch (e) {
      print(e.message);
    }
  }
}
