import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shonchoy_agent/controller/APIController.dart';
import 'package:shonchoy_agent/model/cash_in.dart';
import 'package:shonchoy_agent/scoped_model/my_model.dart';

class CashIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CashInState();
  }
}

class CashInState extends State<CashIn> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final TextEditingController receiverTextField = new TextEditingController();
  final TextEditingController amount = new TextEditingController();
  final TextEditingController pinCode = new TextEditingController();
  double balance = 0;

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
  void initState() {
    super.initState();
    getBalance();
  }

  void getBalance() async {
    balance = await APIController.getBalance(
        ScopedModel.of<MyModel>(context).agent.authToken);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                          'Cash In',
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
                                        setState(() {
                                          isLoading = false;
                                        });
                                        CashInModel cashInModel =
                                            await APIController.cashIn(
                                                receiverTextField.text,
                                                ScopedModel.of<MyModel>(context)
                                                    .agent
                                                    .authToken,
                                                pinCode.text,
                                                double.parse(amount.text));

                                        Navigator.pushReplacementNamed(
                                            context, '/cashInInvoice',
                                            arguments: cashInModel);
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
