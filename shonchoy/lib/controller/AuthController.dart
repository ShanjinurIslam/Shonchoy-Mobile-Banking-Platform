import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shonchoy/model/personal.dart';
import 'package:shonchoy/statics.dart';

class AuthController {
  static Future<Personal> logIn(String mobileNo, String pinCode) async {
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

  static Future<int> checkNumber(String mobileNo) async {
    final http.Response response = await http.post(
      CHECK_NUMBER_URL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'mobileNo': mobileNo}),
    );
    return response.statusCode;
  }

  static Future<String> registerClient(
      String name,
      String primaryGuardian,
      String motherName,
      String idType,
      String idNumber,
      String dob,
      String address,
      String city,
      String subdistrict,
      String district,
      String postOffice,
      String postCode) async {
    final http.Response response = await http.post(registerClient,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'primaryGuardian': primaryGuardian,
          'motherName': motherName,
          'IDType': idType,
          'IDNumber': idNumber,
          'dob': dob,
          'address': address,
          'city': city,
          'subdistrict': subdistrict,
          'district': district,
          'postOffice': postOffice,
          'postCode': postCode
        }));

    if (response.statusCode == 201) {
      return jsonDecode(response.body)['_id'].toString();
    } else {
      throw Exception(jsonDecode(response.body)['message'].toString());
    }
  }

  static Future<String> registerAccount(
      String clientId, String mobileNo, String pinCode) async {
    final http.Response response = await http.post(registerClient,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'client': clientId,
          'mobileNo': mobileNo,
          'pinCode': '12345' // a demo pincode?
        }));

    if (response.statusCode == 201) {
      return jsonDecode(response.body)['_id'].toString();
    } else {
      throw Exception(jsonDecode(response.body)['message'].toString());
    }
  }

  static Future<String> verifyAccount(
      File idFront, File idBack, File currentPhoto, String accountID) async {
    var request = new http.MultipartRequest("POST", Uri.parse(VERIFY_ACCOUNT));
    request.headers['enctype'] = 'multipart/form-data';
    request.fields['accountID'] = accountID;
    request.files.add(
      new http.MultipartFile.fromBytes(
        'IDFront',
        await idFront.readAsBytes(),
      ),
    );
    request.files.add(
        new http.MultipartFile.fromBytes('IDBack', await idBack.readAsBytes()));
    request.files.add(new http.MultipartFile.fromBytes(
        'currentPhoto', await currentPhoto.readAsBytes()));
    request.send().then((response) {
      if (response.statusCode == 201)
        return jsonDecode(response.statusCode.toString());
      else
        throw Exception('Verification Failed');
    });
  }
}
