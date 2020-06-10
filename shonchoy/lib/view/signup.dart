import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, '/takephoto');
            },
            child: Text('Take Photo')),
      ),
    );
  }
}
