import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shonchoy/controller/AuthController.dart';
import 'package:shonchoy/scoped_model/my_model.dart';

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SignUpState();
  }
}

class SignUpState extends State<SignUp> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  FocusNode mobileNode = new FocusNode();

  bool disabled = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void isEmpty() {
    setState(() {
      if (ScopedModel.of<MyModel>(context).mobileNo.text.trim() != "") {
        disabled = false;
      } else {
        disabled = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        body: SafeArea(
            child: Column(
          children: <Widget>[
            Flexible(
              child: Container(
                margin: EdgeInsets.all(24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Let\'s begin',
                    style: TextStyle(color: Colors.green, fontSize: 32),
                  ),
                ),
              ),
              flex: 1,
            ),
            Container(
                margin: EdgeInsets.all(24),
                child: Column(
                  children: <Widget>[
                    TextField(
                      focusNode: mobileNode,
                      keyboardType: TextInputType.number,
                      onChanged: (val) => isEmpty(),
                      controller: ScopedModel.of<MyModel>(context).mobileNo,
                      decoration: InputDecoration(
                          labelText: 'Mobile Number',
                          labelStyle: TextStyle(color: Colors.grey)),
                    ),
                  ],
                )),
            Flexible(
              child: Container(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: isLoading
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

                                  RegExp regExp = new RegExp(
                                    r"^01[3-9][0-9]{8}",
                                    caseSensitive: false,
                                    multiLine: false,
                                  );

                                  bool flag = regExp.hasMatch(
                                      ScopedModel.of<MyModel>(context)
                                          .mobileNo
                                          .text
                                          .trim());

                                  if (flag) {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    // api call
                                    int statusCode =
                                        await AuthController.checkNumber(
                                            ScopedModel.of<MyModel>(context)
                                                .mobileNo
                                                .text
                                                .trim());

                                    if (statusCode == 200) {
                                      ScopedModel.of<MyModel>(context)
                                          .clearTEC();
                                      Navigator.pushNamed(
                                          context, '/fillupform');

                                      setState(() {
                                        isLoading = false;
                                      });
                                    } else {
                                      _scaffoldkey.currentState
                                          .showSnackBar(new SnackBar(
                                        content: Text(
                                            'This number is already linked to an account'),
                                        duration: Duration(seconds: 1),
                                      ));
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  } else {
                                    _scaffoldkey.currentState
                                        .showSnackBar(new SnackBar(
                                      content: Text('Invalid Phone Number'),
                                      duration: Duration(seconds: 1),
                                    ));
                                  }

                                  /**/
                                },
                          child: Container(
                            height: 50,
                            child: Center(
                              child: Text(
                                'Start',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              flex: 2,
            )
          ],
        )));
  }
}
