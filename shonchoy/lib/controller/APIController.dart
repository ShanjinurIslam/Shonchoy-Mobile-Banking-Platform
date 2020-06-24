import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shonchoy/model/sendMoney.dart';

import '../statics.dart';

class APIController {
  static Future<SendMoneyModel> sendMoney(
      String receiver, String authToken, String pinCode, double amount) async {
    String transactionType = "sendMoney";

    final http.Response response = await http.post(
      SEND_MONEY,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + authToken,
      },
      body: jsonEncode(<String, String>{
        'transactionType': transactionType,
        'receiver': receiver,
        'pinCode': pinCode,
        'amount': amount.toString(),
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return SendMoneyModel.fromJson(json);
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }
}
