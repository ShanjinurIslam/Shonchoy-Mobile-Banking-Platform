import 'package:flutter/material.dart';

class ApplyPage extends StatelessWidget {
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
                  'Success!',
                  style: TextStyle(color: Colors.green, fontSize: 32),
                ),
              ),
            ),
            flex: 1,
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        'Your application is submitted to the authority. You would be notified via SMS with 48 Hours'),
                  ),
                ],
              ),
            ),
            flex: 6,
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: RaisedButton(
                elevation: 0,
                color: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/login", (r) => false);
                },
                child: Container(
                  height: 50,
                  child: Center(
                    child: Text(
                      'Back to home',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            flex: 1,
          ),
        ],
      )),
    );
  }
}
