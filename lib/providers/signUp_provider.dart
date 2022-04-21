import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

var apiUrl = 'https://dev.arapi.host';
var _dio = Dio();

class SignUpProvider {
  signUpUser(_newUser) async {
    try {
      _dio.options.headers["Content-Type"] = "application/json";

      var dataJ = jsonEncode({
        "first_name": _newUser.firstName,
        "last_name": _newUser.lastName,
        "email": _newUser.email,
        "password": _newUser.password,
        "username": _newUser.username,
        "account_type": "sandboxed-user",
        "departments": [],
        "hierarchy": [],
        "registration_code": "khabar"
      });
      JsonEncoder encoder = new JsonEncoder.withIndent('  ');
      String prettyPrint = encoder.convert(dataJ);
      print(prettyPrint);

      Response response = await _dio.post(apiUrl + "/users/",
          data: jsonEncode({
            "first_name": _newUser.firstName,
            "last_name": _newUser.lastName,
            "email": _newUser.email,
            "password": _newUser.password,
            "username": _newUser.username,
            "account_type": "sandboxed-user",
            "departments": [],
            "hierarchy": [],
            "registration_code": "khabar"
          }),
          options: Options(headers: {
            "accept": "application/json",
            "Content-Type": "application/json",
          }));
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "تم تسجيل العضوية بنجاح شكراً لك ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        return true;
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
        Fluttertoast.showToast(
            msg: "حاول مرة ثانية  ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 409) {
        Fluttertoast.showToast(
            msg: "لا يمكن التسجيل مرتين ، تم التسجيل مسبقاً",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 500) {
        Fluttertoast.showToast(
            msg: "لا يمكن التسجيل دون بيانات",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      return false;
    }
  }
}
