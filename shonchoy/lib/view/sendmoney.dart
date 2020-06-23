import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io' show Platform;

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shonchoy/controller/APIController.dart';
import 'package:shonchoy/controller/AuthController.dart';
import 'package:shonchoy/scoped_model/my_model.dart';

class SendMoney extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SendMoneyState();
  }
}

class SendMoneyState extends State<SendMoney> {
  TextEditingController controller = new TextEditingController();
  String mobileNumber;
  bool numberScanned;
  bool contactsRead = false;
  bool apiCalled = false;
  int statusCode;
  static final _possibleFormats = BarcodeFormat.qr;
  List<Contact> contacts = new List<Contact>();
  List<Contact> allContacts = new List<Contact>();
  List<BarcodeFormat> selectedFormats = [_possibleFormats];

  @override
  void initState() {
    super.initState();
    numberScanned = false;
    readContacts();
  }

  void readContacts() async {
    Iterable<Contact> _iterableContacts = await ContactsService.getContacts();
    contacts = _iterableContacts.toList();
    contacts = contacts
        .where((element) =>
            element.givenName != "" && element.phones.toList().length != 0)
        .toList();
    setState(() {
      contactsRead = true;
    });
    allContacts = contacts;
  }

  void callAPI() async {
    statusCode = await AuthController.checkNumber(mobileNumber);
    setState(() {
      apiCalled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (numberScanned & !apiCalled) {
      callAPI();
    }

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.purple,
        onPressed: () async {
          try {
            var options = ScanOptions(
              strings: {
                "cancel": "Cancel",
                "flash_on": "Flash On",
                "flash_off": "Flash Off",
              },
              restrictFormat: selectedFormats,
              //useCamera: _selectedCamera,
              autoEnableFlash: false,
            );

            var result = await BarcodeScanner.scan(options: options);

            if (result.rawContent != '') {
              setState(() {
                mobileNumber = result.rawContent.trim().toString();
                numberScanned = true;
              });
            }
          } on PlatformException catch (e) {
            var result = ScanResult(
              type: ResultType.Error,
              format: BarcodeFormat.unknown,
            );

            if (e.code == BarcodeScanner.cameraAccessDenied) {
              setState(() {
                result.rawContent =
                    'The user did not grant the camera permission!';
              });
            } else {
              result.rawContent = 'Unknown error: $e';
            }
          }
        },
        icon: Icon(Icons.code),
        label: Text('Scan QR Code'),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Text(
                    'Send Money',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Spacer(
                    flex: 8,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 2),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: controller,
                  onChanged: (String v) {
                    bool isMatch = RegExp(
                      r"^01[3-9][0-9]{8}",
                      caseSensitive: false,
                      multiLine: false,
                    ).hasMatch(v);

                    if (isMatch) {
                      setState(() {
                        numberScanned = true;
                        mobileNumber = v;
                      });
                    } else {
                      setState(() {
                        numberScanned = false;
                        apiCalled = false;
                        contacts = allContacts
                            .where((element) =>
                                element.givenName
                                    .toUpperCase()
                                    .contains(v.trim().toUpperCase()) |
                                element.phones
                                    .toList()
                                    .elementAt(0)
                                    .value
                                    .replaceAll(new RegExp(r"\+88|\ |\-"), '')
                                    .contains(v))
                            .toList();
                      });
                    }
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: 'Search a person',
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
            ),
            numberScanned
                ? Container()
                : Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Contacts',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                  ),
            numberScanned
                ? Padding(
                    padding: EdgeInsets.all(24),
                    child: Container(
                      child: apiCalled
                          ? statusCode == 200
                              ? Center(
                                  child: Column(
                                  children: <Widget>[
                                    Text(
                                      'This number is not linked to any account',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    RaisedButton(
                                      color: Colors.green,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      onPressed: () {
                                        controller.clear();
                                        contacts = allContacts;
                                        setState(() {
                                          numberScanned = false;
                                          apiCalled = false;
                                        });
                                      },
                                      child: Text('Cancel',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    )
                                  ],
                                ))
                              : Center(
                                  child: Column(
                                  children: <Widget>[
                                    Text(
                                      'Send Money to ' + mobileNumber,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    RaisedButton(
                                      elevation: 0,
                                      color: Colors.green,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      onPressed: () {},
                                      child: Text('Proceed',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    )
                                  ],
                                ))
                          : Container(),
                    ),
                  )
                : !contactsRead
                    ? Container()
                    : Expanded(
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return FlatButton(
                                padding: EdgeInsets.only(bottom: 1),
                                color: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    mobileNumber = contacts[index]
                                        .phones
                                        .toList()
                                        .elementAt(0)
                                        .value
                                        .replaceAll(
                                            new RegExp(r"\+88|\ |\-"), '');
                                    numberScanned = true;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          width: 1.0,
                                          color: Colors.grey.withOpacity(.5)),
                                    ),
                                  ),
                                  height: 96,
                                  child: Padding(
                                    padding: EdgeInsets.all(24),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Icon(
                                          CupertinoIcons.profile_circled,
                                          size: 50,
                                        ),
                                        Spacer(
                                          flex: 1,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              contacts[index].givenName,
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              contacts[index]
                                                  .phones
                                                  .toList()
                                                  .elementAt(0)
                                                  .value
                                                  .replaceAll(
                                                      new RegExp(r"\+88|\ |\-"),
                                                      ''),
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        Spacer(
                                          flex: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                          },
                          itemCount: contacts.length,
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
