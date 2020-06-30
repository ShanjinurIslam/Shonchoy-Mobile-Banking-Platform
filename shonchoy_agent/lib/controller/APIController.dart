import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shonchoy_agent/model/cash_in.dart';
import 'package:shonchoy_agent/model/transaction.dart';
import 'package:http/http.dart' as http;
import 'package:shonchoy_agent/model/cash_out.dart';

import '../statics.dart';

class APIController {
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

  static Future<CashInModel> cashIn(
      String receiver, String authToken, String pinCode, double amount) async {
    String transactionType = "cashIn";

    final http.Response response = await http.post(
      CASH_IN,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + authToken,
      },
      body: jsonEncode(<String, String>{
        'transactionType': transactionType,
        'mobileNo': receiver,
        'pinCode': pinCode,
        'amount': amount.toString(),
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return CashInModel.fromJson(json);
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
      double balance = double.parse(response.data['balance'].toString());
      return balance;
    } else {
      throw Exception(response.data['message']);
    }
  }

  static Future<List<CashOut>> getCashOuts(String authToken) async {
    final Response response = await Dio().get(CASH_OUT,
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ' + authToken,
          },
        ));

    if (response.statusCode == 200) {
      List<dynamic> jsons = response.data;
      List<CashOut> cashOuts = new List<CashOut>();
      for (int i = 0; i < jsons.length; i++) {
        cashOuts.add(CashOut.fromJson(jsons[i]));
      }
      cashOuts.sort((a, b) {
        return a.createdAt.compareTo(b.createdAt);
      });

      return cashOuts.reversed.toList();
    } else {
      throw Exception(response.data['message']);
    }
  }
}
