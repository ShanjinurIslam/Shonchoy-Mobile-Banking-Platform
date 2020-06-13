import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SignUpState();
  }
}

class SignUpState extends State<SignUp> {
  final TextEditingController mobileNo = new TextEditingController();
  FocusNode mobileNode = new FocusNode();

  bool disabled = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void isEmpty() {
    setState(() {
      if (mobileNo.text.trim() != "") {
        disabled = false;
      } else {
        disabled = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  controller: mobileNo,
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

                              setState(() {
                                isLoading = true;
                              });

                              // api call

                              setState(() {
                                isLoading = false;
                              });
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
