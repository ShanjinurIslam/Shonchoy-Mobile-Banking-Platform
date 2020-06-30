import 'dart:convert';

import 'package:shonchoy_agent/model/agent.dart';
import 'package:http/http.dart' as http;

import '../statics.dart';

class AuthController {
  static Future<Agent> logIn(String mobileNo, String pinCode) async {
    final http.Response response = await http
        .post(
          LOGIN_URL,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
              <String, String>{'mobileNo': mobileNo, 'pinCode': pinCode}),
        )
        .timeout(new Duration(seconds: 1));
    if (response.statusCode == 200) {
      Agent agent = Agent.fromJson(json.decode(response.body));
      return agent;
    } else {
      throw new Exception(jsonDecode(response.body)['message'].toString());
    }
  }
}
