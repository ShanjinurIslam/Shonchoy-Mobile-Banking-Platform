import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shonchoy/model/cashOut.dart';
import 'package:shonchoy/model/sendMoney.dart';
import 'package:shonchoy/model/transaction.dart';

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

  static Future<CashOutModel> cashOut(
      String receiver, String authToken, String pinCode, double amount) async {
    String transactionType = "cashOut";

    final http.Response response = await http.post(
      CASH_OUT,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + authToken,
      },
      body: jsonEncode(<String, String>{
        'transactionType': transactionType,
        'receiver': receiver,
        'pinCode': pinCode,
        'amount': amount.toString(),
        'charge': (amount * .01).toString(),
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return CashOutModel.fromJson(json);
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  static Future<List<Transaction>> getTransactions(String authToken) async {
    final http.Response response = await http.get(
      GET_TRANSACTIONS,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + authToken,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsons = jsonDecode(response.body);
      List<Transaction> transactions = new List<Transaction>();
      for (int i = 0; i < jsons.length; i++) {
        transactions.add(Transaction.fromJson(jsons[i]));
      }
      transactions.sort((a, b) {
        return a.createdAt.compareTo(b.createdAt);
      });

      return transactions.reversed.toList();
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  static Future<double> getBalance(String authToken) async {
    final Response response = await Dio().get(GET_BALANCE,
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ' + authToken,
          },
        ));

    if (response.statusCode == 200) {
      double balance = response.data['balance'];
      return balance;
    } else {
      throw Exception(response.data['message']);
    }
  }
}
