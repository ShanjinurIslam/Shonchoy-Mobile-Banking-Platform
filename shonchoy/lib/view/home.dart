import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shonchoy/scoped_model/my_model.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Flexible(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Your Wallet',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    // hero hobe eikhane
                    Hero(
                      tag: "DemoTag",
                      child: GestureDetector(
                        child: Image.asset(
                          'images/profile.png',
                          scale: 15,
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/profile');
                        },
                      ),
                      transitionOnUserGestures: true,
                    )
                  ],
                ),
              ),
              flex: 1),
          Flexible(
            child: Container(
              margin: EdgeInsets.all(24),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.red, Colors.blue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(15)),
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Balance',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    Text(
                      '৳' /*+
                          ScopedModel.of<MyModel>(context)
                              .personal
                              .balance
                              .toString()*/
                      ,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700),
                    ),
                    Spacer(),
                    Text(
                      'Account Holder',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    Text(
                      /*ScopedModel.of<MyModel>(context).personal.client.name*/ 'Placeholder',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(24, 0, 30, 0),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Services',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          IconButton(
                            onPressed: () {},
                            iconSize: 50,
                            icon: Image.asset('images/cashin.png'),
                          ),
                          Text(
                            'Cash In',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          IconButton(
                            onPressed: () {},
                            iconSize: 50,
                            icon: Image.asset('images/cashout.png'),
                          ),
                          Text(
                            'Cash Out',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          IconButton(
                            onPressed: () {},
                            iconSize: 50,
                            icon: Image.asset('images/sendmoney.png'),
                          ),
                          Text(
                            'Send Money',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          IconButton(
                            onPressed: () {},
                            iconSize: 50,
                            icon: Image.asset('images/payment.png'),
                          ),
                          Text(
                            'Payment',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            flex: 4,
          )
        ],
      )),
    );
  }
}
