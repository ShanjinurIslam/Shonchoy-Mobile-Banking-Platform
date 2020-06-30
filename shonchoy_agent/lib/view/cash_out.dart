import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shonchoy_agent/controller/APIController.dart';
import 'package:shonchoy_agent/model/cash_out.dart';
import 'package:shonchoy_agent/scoped_model/my_model.dart';

class CashOutView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CashOutState();
  }
}

class CashOutState extends State<CashOutView> {
  bool isLoading = true;
  List<CashOut> cashOuts = new List<CashOut>();
  void getCashOuts() async {
    cashOuts = await APIController.getCashOuts(
        ScopedModel.of<MyModel>(context).agent.authToken);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getCashOuts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Spacer(
                    flex: 8,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Recent Cashouts',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  isLoading
                      ? Center(
                          child: CupertinoActivityIndicator(),
                        )
                      : Container()
                ],
              ),
            ),
            !isLoading
                ? Expanded(
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            margin: EdgeInsets.all(1),
                            width: MediaQuery.of(context).size.width,
                            height: 100,
                            child: Padding(
                              padding: EdgeInsets.all(22),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Tab(
                                      icon: new Image.asset(
                                          "images/cashout.png")),
                                  Spacer(
                                    flex: 2,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(cashOuts[index].sender),
                                      Text(cashOuts[index].createdAt.toString())
                                    ],
                                  ),
                                  Spacer(
                                    flex: 5,
                                  ),
                                  Text(
                                    '+৳' + cashOuts[index].amount,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                            color: Colors.white);
                      },
                      itemCount: cashOuts.length,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
