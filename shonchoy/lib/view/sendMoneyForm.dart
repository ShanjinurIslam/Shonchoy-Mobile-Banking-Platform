import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shonchoy/controller/APIController.dart';
import 'package:shonchoy/model/sendMoney.dart';
import 'package:shonchoy/scoped_model/my_model.dart';

class SendMoneyForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SendMoneyFormState();
  }
}

class SendMoneyFormState extends State<SendMoneyForm> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final TextEditingController receiverTextField = new TextEditingController();
  final TextEditingController amount = new TextEditingController();
  final TextEditingController pinCode = new TextEditingController();

  FocusNode amountNode = new FocusNode();
  FocusNode pinCodeNode = new FocusNode();

  bool isLoading = false;
  bool disabled = true;

  void isEmpty() {
    setState(() {
      if (amount.text.trim() != "" && pinCode.text.trim() != "") {
        disabled = false;
      } else {
        disabled = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String receiver = ModalRoute.of(context).settings.arguments;
    receiverTextField.text = receiver;
    return Scaffold(
        key: _scaffoldkey,
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
                          'Confirm Amount',
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
                                '৳' + '1000.00',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            readOnly: true,
                            controller: receiverTextField,
                            decoration: InputDecoration(
                                labelText: 'Receiver',
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
                                        SendMoneyModel sendMoneyModel =
                                            await APIController.sendMoney(
                                                receiverTextField.text,
                                                ScopedModel.of<MyModel>(context)
                                                    .personal
                                                    .authToken,
                                                pinCode.text,
                                                double.parse(amount.text));
                                        setState(() {
                                          isLoading = false;
                                        });
                                        Navigator.pushReplacementNamed(
                                            context, '/sendMoneyInvoice',
                                            arguments: sendMoneyModel);
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
