import 'package:flutter/material.dart';
import 'package:shonchoy/view/home.dart';
import 'package:shonchoy/view/login.dart';
import 'package:shonchoy/view/splash.dart';

final routes = {
  '/': (BuildContext context) => SplashScreen(),
  '/login': (BuildContext context) => LogInScreen(),
  '/home': (BuildContext context) => Home(),
};
