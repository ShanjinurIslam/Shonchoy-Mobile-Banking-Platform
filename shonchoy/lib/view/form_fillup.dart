import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shonchoy/scoped_model/my_model.dart';

class FormFillup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new FormFillupState();
  }
}

class FormFillupState extends State<FormFillup> {
  FocusNode name = new FocusNode();
  FocusNode primaryName = new FocusNode();
  FocusNode motherName = new FocusNode();
  FocusNode idNumber = new FocusNode();
  FocusNode dob = new FocusNode();
  FocusNode address = new FocusNode();
  FocusNode city = new FocusNode();
  FocusNode subDistrict = new FocusNode();
  FocusNode district = new FocusNode();
  FocusNode postOffice = new FocusNode();
  FocusNode postCode = new FocusNode();

  bool disabled = true;

  @override
  void initState() {
    super.initState();
  }

  void isEmpty(BuildContext context) {
    if (ScopedModel.of<MyModel>(context).isEmpty()) {
      setState(() {
        disabled = false;
      });
    } else {
      setState(() {
        disabled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: _scaffoldkey,
      body: SafeArea(
          child: Column(
        children: <Widget>[
          SizedBox(
            child: Container(
              margin: EdgeInsets.all(24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'New Client',
                  style: TextStyle(color: Colors.green, fontSize: 32),
                ),
              ),
            ),
            height: 100,
          ),
          Expanded(
            child: SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: <Widget>[
                  TextField(
                    focusNode: name,
                    keyboardType: TextInputType.text,
                    onChanged: (val) => isEmpty(context),
                    controller: ScopedModel.of<MyModel>(context).name,
                    decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                  TextField(
                    focusNode: primaryName,
                    keyboardType: TextInputType.text,
                    onChanged: (val) => isEmpty(context),
                    controller: ScopedModel.of<MyModel>(context).primaryName,
                    decoration: InputDecoration(
                        labelText: 'Father/Husband Name',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                  TextField(
                    focusNode: motherName,
                    keyboardType: TextInputType.text,
                    onChanged: (val) => isEmpty(context),
                    controller: ScopedModel.of<MyModel>(context).motherName,
                    decoration: InputDecoration(
                        labelText: 'Mother Name',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                  Container(
                    height: 60,
                    child: new DropdownButton<String>(
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'ProductSans',
                          color: ScopedModel.of<MyModel>(context).idType ==
                                  'Select ID Type'
                              ? Colors.grey
                              : Colors.black),
                      value: ScopedModel.of<MyModel>(context).idType,
                      isExpanded: true,
                      items: <String>['Select ID Type', 'NID', 'Passport']
                          .map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (_) {
                        setState(() {
                          ScopedModel.of<MyModel>(context).idType = _;
                        });
                      },
                    ),
                    width: MediaQuery.of(context).size.width,
                  ),
                  TextField(
                    focusNode: idNumber,
                    keyboardType: TextInputType.text,
                    onChanged: (val) => isEmpty(context),
                    controller: ScopedModel.of<MyModel>(context).idNumber,
                    decoration: InputDecoration(
                        labelText: 'ID Number',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                  TextField(
                    focusNode: dob,
                    keyboardType: TextInputType.datetime,
                    onChanged: (val) => isEmpty(context),
                    controller: ScopedModel.of<MyModel>(context).dob,
                    decoration: InputDecoration(
                        labelText: 'Date of birth (DD-MM-YYYY)',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                  TextField(
                    focusNode: address,
                    keyboardType: TextInputType.text,
                    onChanged: (val) => isEmpty(context),
                    controller: ScopedModel.of<MyModel>(context).address,
                    decoration: InputDecoration(
                        labelText: 'Address',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                  TextField(
                    focusNode: city,
                    keyboardType: TextInputType.text,
                    onChanged: (val) => isEmpty(context),
                    controller: ScopedModel.of<MyModel>(context).city,
                    decoration: InputDecoration(
                        labelText: 'City',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                  TextField(
                    focusNode: subDistrict,
                    keyboardType: TextInputType.text,
                    onChanged: (val) => isEmpty(context),
                    controller: ScopedModel.of<MyModel>(context).subDistrict,
                    decoration: InputDecoration(
                        labelText: 'Subdistrict',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                  TextField(
                    focusNode: district,
                    keyboardType: TextInputType.text,
                    onChanged: (val) => isEmpty(context),
                    controller: ScopedModel.of<MyModel>(context).district,
                    decoration: InputDecoration(
                        labelText: 'District',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                  TextField(
                    focusNode: postOffice,
                    keyboardType: TextInputType.text,
                    onChanged: (val) => isEmpty(context),
                    controller: ScopedModel.of<MyModel>(context).postOffice,
                    decoration: InputDecoration(
                        labelText: 'Post Office',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                  TextField(
                    focusNode: postCode,
                    keyboardType: TextInputType.number,
                    onChanged: (val) => isEmpty(context),
                    controller: ScopedModel.of<MyModel>(context).postCode,
                    decoration: InputDecoration(
                        labelText: 'Post Code',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            )),
            flex: 7,
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: RaisedButton(
                elevation: 0,
                color: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: disabled
                    ? null
                    : () {
                        try {
                          ScopedModel.of<MyModel>(context).checkValidity();
                        } catch (e) {
                          Widget okButton = FlatButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          );

                          // set up the AlertDialog
                          AlertDialog alert = AlertDialog(
                            title: Text("Error"),
                            content: Text(e.message),
                            actions: [
                              okButton,
                            ],
                          );

                          // show the dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
                        }
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
        ],
      )),
    );
  }
}
