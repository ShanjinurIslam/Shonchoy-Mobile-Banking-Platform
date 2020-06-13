import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shonchoy/controller/AuthController.dart';
import 'package:shonchoy/model/personal.dart';
import 'package:shonchoy/scoped_model/my_model.dart';

class LogInScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LogInScreenState();
  }
}

class LogInScreenState extends State<LogInScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  bool disabled = true;
  bool isLoading = false;
  TextEditingController mobileNo = new TextEditingController();
  TextEditingController pinCode = new TextEditingController();

  FocusNode mobileNode = new FocusNode();
  FocusNode pinNode = new FocusNode();

  void isEmpty() {
    setState(() {
      if (mobileNo.text.trim() != "" && pinCode.text.trim() != "") {
        disabled = false;
      } else {
        disabled = true;
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Flexible(
            child: Container(
              margin: EdgeInsets.all(24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Welcome',
                  style: TextStyle(color: Colors.green, fontSize: 32),
                ),
              ),
            ),
            flex: 2,
          ),
          Container(
              margin: EdgeInsets.all(24),
              child: Column(
                children: <Widget>[
                  TextField(
                    focusNode: mobileNode,
                    keyboardType: TextInputType.number,
                    onChanged: (val) => isEmpty(),
                    controller: mobileNo,
                    decoration: InputDecoration(
                        labelText: 'Mobile Number',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    focusNode: pinNode,
                    keyboardType: TextInputType.number,
                    onChanged: (val) => isEmpty(),
                    controller: pinCode,
                    decoration: InputDecoration(
                        labelText: 'Pin Number',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                ],
              )),
          Flexible(
            child: Container(
                child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  isLoading
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
                                  FocusScopeNode currentFocus =
                                      FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus &&
                                      currentFocus.focusedChild != null) {
                                    currentFocus.focusedChild.unfocus();
                                  }
                                  setState(() {
                                    isLoading = true;
                                  });
                                  try {
                                    Personal personal =
                                        await AuthController.logIn(
                                            mobileNo.text, pinCode.text);
                                    ScopedModel.of<MyModel>(context)
                                        .setPersonal(personal);
                                    Navigator.pushReplacementNamed(
                                        context, '/home');
                                  } catch (e) {
                                    _scaffoldkey.currentState.showSnackBar(
                                        SnackBar(
                                            duration: Duration(seconds: 1),
                                            content: Text(e.message)));
                                  }

                                  setState(() {
                                    isLoading = false;
                                  });
                                  /**/
                                },
                          child: Container(
                            height: 50,
                            child: Center(
                              child: Text(
                                'Log In',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Forgot Pin Number?',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Align(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Don\'t have an account? ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, '/signup');
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                    ),
                  )
                ],
              ),
            )),
            flex: 4,
          ),
        ],
      )),
    );
  }
}
