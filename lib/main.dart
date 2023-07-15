import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:makipos/view/login_page.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TimerState(),
      child: MyApp(),
    ),
  );
}
class TimerState extends ChangeNotifier {
  bool timerActive = true;

  void stopTimer() {
    print("STOPP");
    timerActive = false;
    notifyListeners();
  }
}
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner : false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LogInPage(),
    );
  }
}

