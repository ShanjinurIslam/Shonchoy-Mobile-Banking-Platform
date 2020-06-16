import 'package:flutter/cupertino.dart';
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
  String errorMessage;

  void register(BuildContext context) async {
    try {
      String name = ScopedModel.of<MyModel>(context).name.text;
      String primaryGuardian =
          ScopedModel.of<MyModel>(context).primaryName.text;
      String motherName = ScopedModel.of<MyModel>(context).motherName.text;
      String idType = ScopedModel.of<MyModel>(context).idType;
      String idNumber = ScopedModel.of<MyModel>(context).idNumber.text;
      String dob = ScopedModel.of<MyModel>(context).dob.text.trim();
      String address = ScopedModel.of<MyModel>(context).address.text;
      String city = ScopedModel.of<MyModel>(context).city.text;
      String subdistrict = ScopedModel.of<MyModel>(context).subDistrict.text;
      String district = ScopedModel.of<MyModel>(context).district.text;
      String postOffice = ScopedModel.of<MyModel>(context).postOffice.text;
      String postCode = ScopedModel.of<MyModel>(context).postCode.text;
      String mobileNo = ScopedModel.of<MyModel>(context).mobileNo.text;

      // have to switch to 1 single request
      await AuthController.register(
        name: name,
        primaryGuardian: primaryGuardian,
        motherName: motherName,
        idType: idType,
        idNumber: idNumber,
        dob: dob,
        address: address,
        city: city,
        subdistrict: subdistrict,
        district: district,
        postOffice: postOffice,
        postCode: postCode,
        mobileNo: mobileNo,
        pinCode: '1234',
        idFront: ScopedModel.of<MyModel>(context).idFront,
        idBack: ScopedModel.of<MyModel>(context).idBack,
        currentPhoto: ScopedModel.of<MyModel>(context).currentPhoto,
      );

      registrationResult = true;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      errorMessage = e.message;
      print(e.message);
      registrationResult = false;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    register(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: isLoading
              ? Center(
                  child: CupertinoActivityIndicator(),
                )
              : Column(
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.all(24),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            registrationResult ? 'Success!' : 'Failed!',
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
                              child: Text(registrationResult
                                  ? 'Your application is submitted to the authority. You would be notified via SMS with 48 Hours'
                                  : errorMessage),
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
                            ScopedModel.of<MyModel>(context).clearTEC();
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
