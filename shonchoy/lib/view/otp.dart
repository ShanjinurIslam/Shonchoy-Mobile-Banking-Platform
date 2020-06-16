import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shonchoy/scoped_model/my_model.dart';

class OTPVerification extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new OTPVerificationState();
  }
}

class OTPVerificationState extends State<OTPVerification> {
  String currentText;
  TextEditingController textEditingController = new TextEditingController();
  bool disabled = true;

  Timer _timer;
  int _start = 300;
  int minute = 5;
  int second = 0;
  String secondString = "00";

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
            minute = _start ~/ 60;
            second = _start - minute * 60;
            secondString =
                second < 10 ? '0' + second.toString() : second.toString();
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String mobileNo = ScopedModel.of<MyModel>(context).mobileNo.text;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          top: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                child: Container(
                  margin: EdgeInsets.all(24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'OTP Verification',
                      style: TextStyle(color: Colors.green, fontSize: 32),
                    ),
                  ),
                ),
                height: 200,
              ),
              Text(
                'Verification Code Sent to\n',
              ),
              Text(
                '+88$mobileNo',
                style: TextStyle(fontSize: 24),
              ),
              Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: PinCodeTextField(
                      autoDismissKeyboard: true,
                      length: 4,
                      obsecureText: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.underline,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 100,
                        fieldWidth: 80,
                        activeFillColor: Colors.white,
                      ),
                      //animationDuration: Duration(milliseconds: 300),
                      //backgroundColor: Colors.blue.shade50,
                      //enableActiveFill: true,
                      //errorAnimationController: errorController,
                      controller: textEditingController,
                      onCompleted: (v) {
                        setState(() {
                          disabled = false;
                        });
                      },
                      onChanged: (value) {
                        if (value.length != 4) {
                          setState(() {
                            disabled = true;
                          });
                        }
                        print(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    ),
                  )),
              Text('OTP Expires in $minute:$secondString'),
              Flexible(
                child: Container(
                    child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: RaisedButton(
                      elevation: 0,
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: disabled
                          ? null
                          : () async {
                              /**/
                            },
                      child: Container(
                        height: 50,
                        child: Center(
                          child: Text(
                            'Verify',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
                flex: 1,
              )
            ],
          )),
    );
  }
}
