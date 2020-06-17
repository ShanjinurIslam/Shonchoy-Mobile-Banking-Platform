import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shonchoy/controller/AuthController.dart';
import 'package:shonchoy/scoped_model/my_model.dart';

class PinCode extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new PinCodeState();
  }
}

class PinCodeState extends State<PinCode> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  FocusNode pinCode = new FocusNode();
  FocusNode confirmPinCode = new FocusNode();

  bool disabled = true;

  @override
  void initState() {
    super.initState();
  }

  void isEmpty() {
    setState(() {
      if (ScopedModel.of<MyModel>(context).pinCode.text.trim() != "" &&
          ScopedModel.of<MyModel>(context).confirmPinCode.text.trim() != "") {
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
                    'Set Pin Code',
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
                      obscureText: true,
                      focusNode: pinCode,
                      maxLength: 5,
                      keyboardType: TextInputType.number,
                      onChanged: (val) => isEmpty(),
                      controller: ScopedModel.of<MyModel>(context).pinCode,
                      decoration: InputDecoration(
                          labelText: 'Pin Code',
                          labelStyle: TextStyle(color: Colors.grey)),
                    ),
                    TextField(
                      obscureText: true,
                      maxLength: 5,
                      focusNode: confirmPinCode,
                      keyboardType: TextInputType.number,
                      onChanged: (val) => isEmpty(),
                      controller: ScopedModel.of<MyModel>(context).confirmPinCode,
                      decoration: InputDecoration(
                          labelText: 'Confirm Pin Code',
                          labelStyle: TextStyle(color: Colors.grey)),
                    ),
                  ],
                )),
            Flexible(
              child: Container(
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
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus &&
                                currentFocus.focusedChild != null) {
                              currentFocus.focusedChild.unfocus();
                            }

                            RegExp regExp = new RegExp(
                              r"^[0-9]{5}",
                              caseSensitive: false,
                              multiLine: false,
                            );

                            bool flag = regExp.hasMatch(
                                ScopedModel.of<MyModel>(context)
                                    .pinCode
                                    .text
                                    .trim());

                            if (flag) {
                              if (ScopedModel.of<MyModel>(context)
                                      .pinCode
                                      .text ==
                                  ScopedModel.of<MyModel>(context)
                                      .confirmPinCode
                                      .text) {
                                Navigator.pushNamed(
                                    context, '/photoinstruction');
                              } else {
                                _scaffoldkey.currentState
                                    .showSnackBar(new SnackBar(
                                  content: Text('Invalid Pin Code'),
                                  duration: Duration(seconds: 1),
                                ));
                              }
                            } else {
                              _scaffoldkey.currentState
                                  .showSnackBar(new SnackBar(
                                content: Text('Invalid Pin Code'),
                                duration: Duration(seconds: 1),
                              ));
                            }

                            /**/
                          },
                    child: Container(
                      height: 50,
                      child: Center(
                        child: Text(
                          'Next',
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
