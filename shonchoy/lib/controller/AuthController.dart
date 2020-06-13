import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shonchoy/model/personal.dart';
import 'package:shonchoy/statics.dart';

class AuthController {
  Future<Personal> logIn(String mobileNo, String pinCode) async {
    final http.Response response = await http.post(
      LOGIN_URL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'mobileNo': mobileNo, 'pinCode': pinCode}),
    );
    if (response.statusCode == 200) {
      Personal personal = Personal.fromJson(json.decode(response.body));
      return personal;
    } else {
      throw new Exception(response.body.toString());
    }
  }
}
