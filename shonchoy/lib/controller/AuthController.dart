import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shonchoy/model/personal.dart';
import 'package:shonchoy/statics.dart';

class AuthController {
  static Future<String> otpSend(String mobileNo) async {
    final http.Response response = await http.post(
      OTP_SEND,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'mobileNo': '88' + mobileNo}),
    );
    var json = jsonDecode(response.body);

    print(json);

    if (response.statusCode == 200) {
      if (json['status'] != "0") {
        throw Exception(json['error_text']);
      } else
        return json['request_id'];
    } else {
      throw Exception('OTP Service Failed');
    }
  }

  static Future<String> otpVerify(String requestID, String code) async {
    try {
      Response response = await Dio().post(OTP_VERIFY,
          options: Options(headers: {
            Headers.contentTypeHeader:
                'application/json; charset=UTF-8', // set content-length
          }),
          data: {"request_id": requestID, "code": code});

      print(response.data);

      if (response.statusCode == 200) {
        if (response.data['status'] != "0") {
          throw new Exception(response.data['error_text']);
        } else
          return 'Verification Success';
      }
    } catch (e) {
      throw new Exception(e.message);
    }
  }

  static Future<Personal> logIn(String mobileNo, String pinCode) async {
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

  static Future<void> register(
      {String name,
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
      String postCode,
      String mobileNo,
      String pinCode,
      File idFront,
      File idBack,
      File currentPhoto}) async {
    FormData formData = new FormData();
    formData.fields.add(new MapEntry('name', name));
    formData.fields.add(new MapEntry('primaryGuardian', primaryGuardian));
    formData.fields.add(new MapEntry('motherName', motherName));
    formData.fields.add(new MapEntry('IDType', idType));
    formData.fields.add(new MapEntry('IDNumber', idNumber));
    formData.fields.add(new MapEntry('dob', dob));
    formData.fields.add(new MapEntry('address', address));
    formData.fields.add(new MapEntry('city', city));
    formData.fields.add(new MapEntry('subdistrict', subdistrict));
    formData.fields.add(new MapEntry('district', district));
    formData.fields.add(new MapEntry('postOffice', postOffice));
    formData.fields.add(new MapEntry('postalCode', postCode));
    formData.fields.add(new MapEntry('mobileNo', mobileNo));
    formData.fields.add(new MapEntry('pinCode', pinCode));
    formData.files.add(new MapEntry<String, MultipartFile>(
        'IDFront',
        new MultipartFile.fromBytes(await idFront.readAsBytes(),
            filename: 'IDFront.jpg')));
    formData.files.add(new MapEntry<String, MultipartFile>(
        'IDBack',
        new MultipartFile.fromBytes(await idBack.readAsBytes(),
            filename: 'IDBack.jpg')));
    formData.files.add(new MapEntry<String, MultipartFile>(
        'currentPhoto',
        new MultipartFile.fromBytes(await currentPhoto.readAsBytes(),
            filename: 'currentPhoto.jpg')));

    Response response = await Dio().post(REGISTER, data: formData);

    if (response.statusCode == 201) {
      //
    } else {
      throw Exception(response.statusCode);
    }
  }
  /*
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
    final http.Response response = await http.post(REGISTER_CLIENT,
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
          'postalCode': postCode
        }));

    if (response.statusCode == 201) {
      return jsonDecode(response.body)['client_id'].toString();
    } else {
      throw Exception(jsonDecode(response.body)['message'].toString());
    }
  }

  static Future<String> registerAccount(
      String clientId, String mobileNo, String pinCode) async {
    final http.Response response = await http.post(REGISTER_ACCOUNT,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'client': clientId,
          'mobileNo': mobileNo,
          'pinCode': '12345' // a demo pincode?
        }));

    if (response.statusCode == 201) {
      print(jsonDecode(response.body));
      return jsonDecode(response.body)['_id'].toString();
    } else {
      throw Exception(jsonDecode(response.body)['message'].toString());
    }
  }

  // this does not work!

  static Future<String> verifyAccount(
      File idFront, File idBack, File currentPhoto, String accountID) async {
    var request = new http.MultipartRequest("POST", Uri.parse(VERIFY_ACCOUNT));
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
  }*/
}
