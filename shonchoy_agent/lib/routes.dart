import 'package:flutter/material.dart';
import 'package:shonchoy_agent/view/cash_in.dart';
import 'package:shonchoy_agent/view/cash_out.dart';
import 'package:shonchoy_agent/view/home.dart';
import 'package:shonchoy_agent/view/login.dart';
import 'package:shonchoy_agent/view/splash.dart';

final routes = {
  '/': (BuildContext context) => SplashScreen(),
  '/login': (BuildContext context) => LogInScreen(),
  '/home': (BuildContext context) => Home(),
  '/cashin': (BuildContext context) => CashIn(),
  '/cashout': (BuildContext context) => CashOut(),
};
