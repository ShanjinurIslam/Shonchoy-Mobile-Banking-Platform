import 'package:shonchoy/model/client.dart';

class Personal {
  final String id;
  final Client client;
  final String mobileNo;
  final String authToken;
  final double balance;

  Personal({this.id, this.client, this.mobileNo, this.authToken, this.balance});

  factory Personal.fromJson(Map<String, dynamic> json) {
    try {
      return Personal(
        id: json['_id'],
        client: Client.fromJson(json['client']),
        mobileNo: json['mobileNo'],
        authToken: json['token'],
        balance: double.parse(json['balance'].toString()),
      );
    } catch (e) {
      print(e);
      return null;
    }
  }
}
