import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shonchoy/controller/AuthController.dart';
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
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  bool disabled = true;
  bool isLoading = true;
  bool sendOTPStatus = false;
  bool isVerificationLoading = false;

  Timer _timer;
  int _start = 300;
  int minute = 5;
  int second = 0;
  bool expired = false;
  String secondString = "00";
  String mobileNo = "";
  String requestID;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
            setState(() {
              expired = true;
            });
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

  void sendOTP(String mobileNo) async {
    try {
      requestID = await AuthController.otpSend(mobileNo);
      print(requestID);
      setState(() {
        sendOTPStatus = true;
        isLoading = false;
        startTimer();
      });
    } catch (e) {
      setState(() {
        sendOTPStatus = false;
        isLoading = false;
        disabled = false;
      });
    }
  }

  void verifyOTP(String requestID, String code) async {
    try {
      String response = await AuthController.otpVerify(requestID, code);
      print(response);
      setState(() {
        isVerificationLoading = false;
        Navigator.pushReplacementNamed(context, '/fillupform');
      });
    } catch (e) {
      print(e.message);
      errorController.add(ErrorAnimationType.shake);
      setState(() {
        isVerificationLoading = false;
        disabled = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    mobileNo = ScopedModel.of<MyModel>(context).mobileNo.text;
    sendOTP(mobileNo);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(
              child: CupertinoActivityIndicator(),
            )
          : SafeArea(
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
                    sendOTPStatus
                        ? 'Verification Code Sent to\n'
                        : 'Verification Code couldn\'t be sent',
                  ),
                  Text(
                    sendOTPStatus ? '+88$mobileNo' : '',
                    style: TextStyle(fontSize: 24),
                  ),
                  !sendOTPStatus
                      ? Container()
                      : Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: PinCodeTextField(
                              autoDisposeControllers: false,
                              autoDismissKeyboard: true,
                              length: 4,
                              obsecureText: false,
                              animationType: AnimationType.fade,
                              pinTheme: PinTheme(
                                inactiveColor: Colors.black,
                                shape: PinCodeFieldShape.underline,
                                borderRadius: BorderRadius.circular(5),
                                fieldHeight: 100,
                                fieldWidth: 80,
                                activeFillColor: Colors.white,
                              ),
                              controller: textEditingController,
                              errorAnimationController: errorController,
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
                  !sendOTPStatus
                      ? Container()
                      : Text(expired
                          ? 'OTP Expired'
                          : 'OTP Expires in $minute:$secondString'),
                  Flexible(
                    child: Container(
                        child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: isVerificationLoading
                            ? RaisedButton(
                                elevation: 0,
                                color: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: null,
                                child: Container(
                                  height: 50,
                                  child: Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                                ),
                              )
                            : RaisedButton(
                                elevation: 0,
                                color: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: disabled
                                    ? null
                                    : () async {
                                        if (sendOTPStatus & !expired) {
                                          // send code to server
                                          setState(() {
                                            verifyOTP(requestID, currentText);
                                            isVerificationLoading = true;
                                          });
                                        } else {
                                          setState(() {
                                            isLoading = true;
                                            sendOTP(mobileNo);
                                          });
                                        }
                                      },
                                child: Container(
                                  height: 50,
                                  child: Center(
                                    child: Text(
                                      sendOTPStatus & !expired
                                          ? 'Verify'
                                          : 'Retry',
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
