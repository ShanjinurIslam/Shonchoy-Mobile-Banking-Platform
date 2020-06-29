import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shonchoy_agent/view/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(new Duration(seconds: 1), (timer) {
      Navigator.pushReplacement(
          context,
          new PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
            return new LogInScreen();
          }, transitionsBuilder:
              (_, Animation<double> animation, __, Widget child) {
            return new FadeTransition(opacity: animation, child: child);
          }));
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'images/icon.png',
                scale: 2,
              ),
              Text(
                'Shonchoy',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ));
  }
}
