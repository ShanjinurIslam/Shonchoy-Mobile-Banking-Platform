import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shonchoy/controller/AuthController.dart';
import 'package:shonchoy/scoped_model/my_model.dart';

class ApplyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ApplyPageState();
  }
}

class ApplyPageState extends State<ApplyPage> {
  bool registrationResult = false;
  bool isLoading = true;

  void register(BuildContext context) async {
    try {
      String name = ScopedModel.of<MyModel>(context).name.text;
      String primaryGuardian =
          ScopedModel.of<MyModel>(context).primaryName.text;
      String motherName = ScopedModel.of<MyModel>(context).motherName.text;
      String idType = ScopedModel.of<MyModel>(context).idType;
      String idNumber = ScopedModel.of<MyModel>(context).idNumber.text;
      String dob = ScopedModel.of<MyModel>(context).dob.text;
      String address = ScopedModel.of<MyModel>(context).address.text;
      String city = ScopedModel.of<MyModel>(context).city.text;
      String subdistrict = ScopedModel.of<MyModel>(context).subDistrict.text;
      String district = ScopedModel.of<MyModel>(context).district.text;
      String postOffice = ScopedModel.of<MyModel>(context).postOffice.text;
      String postCode = ScopedModel.of<MyModel>(context).postCode.text;
      String mobileNo = ScopedModel.of<MyModel>(context).mobileNo.text;

      String clientID = await AuthController.registerClient(
          name,
          primaryGuardian,
          motherName,
          idType,
          idNumber,
          dob,
          address,
          city,
          subdistrict,
          district,
          postOffice,
          postCode);
      String accountID =
          await AuthController.registerAccount(clientID, mobileNo, 'pinCode');
      String statusCode = await AuthController.verifyAccount(
          ScopedModel.of<MyModel>(context).idFront,
          ScopedModel.of<MyModel>(context).idBack,
          ScopedModel.of<MyModel>(context).currentPhoto,
          accountID);
      if (statusCode == '201') {
        registrationResult = true;
        setState(() {
          isLoading = false;
        });
      } else {
        throw Exception('Application Failed');
      }
    } catch (e) {
      registrationResult = false;
      setState(() {
        isLoading = false;
      });
    }
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
