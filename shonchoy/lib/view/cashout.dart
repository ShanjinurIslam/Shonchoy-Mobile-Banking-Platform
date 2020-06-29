import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shonchoy/controller/APIController.dart';
import 'package:shonchoy/model/cashOut.dart';
import 'package:shonchoy/scoped_model/my_model.dart';

class CashOut extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CashOutState();
  }
}

class CashOutState extends State<CashOut> {
  static final _possibleFormats = BarcodeFormat.qr;
  List<BarcodeFormat> selectedFormats = [_possibleFormats];
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final TextEditingController agentTextField = new TextEditingController();
  final TextEditingController amount = new TextEditingController();
  final TextEditingController pinCode = new TextEditingController();
  double balance = 0;

  FocusNode agent = new FocusNode();
  FocusNode amountNode = new FocusNode();
  FocusNode pinCodeNode = new FocusNode();

  bool isLoading = false;
  bool disabled = true;

  void isEmpty() {
    setState(() {
      if (agentTextField.text.trim() != "" &&
          amount.text.trim() != "" &&
          pinCode.text.trim() != "") {
        disabled = false;
      } else {
        disabled = true;
      }
    });
  }

  void getBalance() async {
    balance = await APIController.getBalance(
        ScopedModel.of<MyModel>(context).personal.authToken);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
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
                  agentTextField.text = result.rawContent.trim().toString();
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
                          'Cash Out',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Spacer(
                          flex: 8,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text('Available Balance: '),
                              Text(
                                '৳' + balance.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            keyboardType: TextInputType.number,
                            controller: agentTextField,
                            focusNode: agent,
                            decoration: InputDecoration(
                                labelText: 'Agent Number',
                                labelStyle: TextStyle(color: Colors.grey)),
                          ),
                          TextField(
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            focusNode: amountNode,
                            controller: amount,
                            onChanged: (val) => isEmpty(),
                            decoration: InputDecoration(
                                labelText: 'Amount',
                                labelStyle: TextStyle(color: Colors.grey)),
                          ),
                          TextField(
                            maxLength: 5,
                            obscureText: true,
                            keyboardType: TextInputType.number,
                            focusNode: pinCodeNode,
                            controller: pinCode,
                            onChanged: (val) => isEmpty(),
                            decoration: InputDecoration(
                                labelText: 'Pincode',
                                labelStyle: TextStyle(color: Colors.grey)),
                          )
                        ],
                      )),
                  Container(
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
                                      try {
                                        CashOutModel cashOutModel =
                                            await APIController.cashOut(
                                                agentTextField.text,
                                                ScopedModel.of<MyModel>(context)
                                                    .personal
                                                    .authToken,
                                                pinCode.text,
                                                double.parse(amount.text));

                                        setState(() {
                                          isLoading = false;
                                        });

                                        Navigator.pushReplacementNamed(
                                            context, '/cashOutInvoice',
                                            arguments: cashOutModel);
                                      } catch (e) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        _scaffoldkey.currentState.showSnackBar(
                                            SnackBar(
                                                duration: Duration(seconds: 1),
                                                content: Text(e.message)));
                                      }
                                    },
                              child: Container(
                                height: 50,
                                child: Center(
                                  child: Text(
                                    'Confirm',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                ])));
  }
}
