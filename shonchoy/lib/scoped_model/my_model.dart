import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shonchoy/model/personal.dart';

class MyModel extends Model {
  Personal personal;

  TextEditingController mobileNo = new TextEditingController();
  TextEditingController name = new TextEditingController();
  TextEditingController primaryName = new TextEditingController();
  TextEditingController motherName = new TextEditingController();
  TextEditingController idNumber = new TextEditingController();
  TextEditingController dob = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController city = new TextEditingController();
  TextEditingController subDistrict = new TextEditingController();
  TextEditingController district = new TextEditingController();
  TextEditingController postOffice = new TextEditingController();
  TextEditingController postCode = new TextEditingController();

  File idFront;
  File idBack;
  File currentPhoto;

  String idType = "Select ID Type";

  void setPersonal(Personal personal) {
    this.personal = personal;
  }

  void clearTEC() {
    name.clear();
    primaryName.clear();
    motherName.clear();
    idNumber.clear();
    dob.clear();
    address.clear();
    city.clear();
    subDistrict.clear();
    district.clear();
    postOffice.clear();
    postCode.clear();
  }

  bool isEmpty() {
    if (name.text.trim() != "" &&
        primaryName.text.trim() != "" &&
        motherName.text.trim() != "" &&
        idNumber.text.trim() != "" &&
        dob.text.trim() != "" &&
        address.text.trim() != "" &&
        city.text.trim() != "" &&
        subDistrict.text.trim() != "" &&
        district.text.trim() != "" &&
        postOffice.text.trim() != "" &&
        postCode.text.trim() != "" &&
        idType != "Select ID Type") {
      return true;
    } else {
      return false;
    }
  }

  void checkValidity() {
    var date = RegExp("^(0[1-9]|[12][0-9]|3[01])\-(0[1-9]|1[012]\-[0-9]{4})");
    bool flag = date.hasMatch(dob.text.trim());
    if (flag) {
      bool pcf = RegExp("^[12]{2}[0-9]{2}").hasMatch(postCode.text.trim());
      if (pcf) {
        return;
      } else {
        throw Exception('Invalid Postcode');
      }
    } else {
      throw Exception('Invalid Date Format');
    }
  }
}
