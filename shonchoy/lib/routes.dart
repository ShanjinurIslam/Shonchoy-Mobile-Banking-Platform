import 'package:flutter/material.dart';
import 'package:shonchoy/view/form_fillup.dart';
import 'package:shonchoy/view/home.dart';
import 'package:shonchoy/view/login.dart';
import 'package:shonchoy/view/signup.dart';
import 'package:shonchoy/view/splash.dart';
import 'package:shonchoy/view/take_photo.dart';

final routes = {
  '/': (BuildContext context) => SplashScreen(),
  '/login': (BuildContext context) => LogInScreen(),
  '/home': (BuildContext context) => Home(),
  '/signup': (BuildContext context) => SignUp(),
  '/takephoto': (BuildContext context) => TakePhoto(),
  '/fillupform': (BuildContext context) => FormFillup()
};
