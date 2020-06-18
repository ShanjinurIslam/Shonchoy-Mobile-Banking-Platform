import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shonchoy/scoped_model/my_model.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new ProfileState();
  }
}

class ProfileState extends State<Profile> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                Image.asset(
                  'images/profile.png',
                  scale: 5,
                ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24, 24, 24, 10),
            child: Text(
              'Client Profile',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    readOnly: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                  TextField(
                    readOnly: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'Father/Husband\'s Name',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                  TextField(
                    readOnly: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'Mother\'s Name',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'Address',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                  TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'City',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                  TextField(
                    keyboardType: TextInputType.text,
                    controller: ScopedModel.of<MyModel>(context).subDistrict,
                    decoration: InputDecoration(
                        labelText: 'Subdistrict',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                  TextField(
                    keyboardType: TextInputType.text,
                    controller: ScopedModel.of<MyModel>(context).district,
                    decoration: InputDecoration(
                        labelText: 'District',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                  TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'Post Office',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: ScopedModel.of<MyModel>(context).postCode,
                    decoration: InputDecoration(
                        labelText: 'Post Code',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            ),
          )),
          Container(
              child: Padding(
                  padding: EdgeInsets.all(24),
                  child: RaisedButton(
                    onPressed: () {},
                    elevation: 0,
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      height: 50,
                      child: Center(
                        child: Text(
                          'Update',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )))
        ],
      ),
    ));
  }
}
