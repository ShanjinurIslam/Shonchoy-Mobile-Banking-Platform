import 'package:flutter/material.dart';
import 'package:shonchoy/view/apply.dart';
import 'package:shonchoy/view/form_fillup.dart';
import 'package:shonchoy/view/home.dart';
import 'package:shonchoy/view/login.dart';
import 'package:shonchoy/view/otp.dart';
import 'package:shonchoy/view/photo_instruction.dart';
import 'package:shonchoy/view/pinCode.dart';
import 'package:shonchoy/view/profile.dart';
import 'package:shonchoy/view/selfie_instruction.dart';
import 'package:shonchoy/view/sendMoneyForm.dart';
import 'package:shonchoy/view/sendMoneyInvoice.dart';
import 'package:shonchoy/view/sendmoney.dart';
import 'package:shonchoy/view/signup.dart';
import 'package:shonchoy/view/splash.dart';
import 'package:shonchoy/view/take_photo.dart';
import 'package:shonchoy/view/take_selfie.dart';

final routes = {
  '/': (BuildContext context) => SplashScreen(),
  '/login': (BuildContext context) => LogInScreen(),
  '/home': (BuildContext context) => Home(),
  '/signup': (BuildContext context) => SignUp(),
  '/takephoto': (BuildContext context) => TakePhoto(),
  '/takeselfie': (BuildContext context) => TakeSelfie(),
  '/fillupform': (BuildContext context) => FormFillup(),
  '/pinCode': (BuildContext context) => PinCode(),
  '/photoinstruction': (BuildContext context) => PhotoInstruction(),
  '/selfieinstruction': (BuildContext context) => SelfieInstruction(),
  '/apply': (BuildContext context) => ApplyPage(),
  '/otp': (BuildContext context) => OTPVerification(),
  '/profile': (BuildContext context) => Profile(),
  '/sendmoney': (BuildContext context) => SendMoney(),
  '/sendMoneyForm': (BuildContext context) => SendMoneyForm(),
  '/sendMoneyInvoice': (BuildContext context) => SendMoneyInvoice(),
  
};
