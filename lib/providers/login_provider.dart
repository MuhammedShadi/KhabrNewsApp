import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khbr_app/providers/user_provider.dart';
import 'package:khbr_app/screens/home.dart';
import 'package:path_provider/path_provider.dart';
import 'package:khbr_app/providers/sh_prefs.dart';

var apiUrl = 'https://dev.arapi.host';
var _dio = Dio();
UserProvider _userProvider = new UserProvider();

class LoginProvider {
  loginFirstTime(String username, String password) async {
    try {
      Dio dio = await getApiLogin();
      Response response = await dio.post(apiUrl + '/auth/access-tokens',
          data: {
            "username": username,
            "password": password,
            "grant_type": "password",
          },
          options: Options(headers: {
            "accept": "application/json",
          }));
      if (response.statusCode == 200) {
        ShPrefs.instance.setStringValue('userNameKey', username);
        Fluttertoast.showToast(
          msg: "تم التسجيل مرحباً بك",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        //if request sucess
        if (response.data['access_token'] != null) {
          await ShPrefs.instance
              .setStringValue('access_token', response.data['access_token']);
        }
        if (response.data['refresh_access_token'] != null) {
          await ShPrefs.instance.setStringValue(
              'refresh_access_token', response.data['refresh_access_token']);
        }
        // print('ShredRefresh:' +
        //     await ShPrefs.instance.getStringValue('refresh_access_token'));
        _userProvider.getUserPermission(response.data['permissions']);
        _userProvider.getUserDetailsByUserName(username);
        _userProvider.putUserSetting(response.data['settings']);
        ShPrefs.instance.setStringValue('userName', username);
        print(response.data['settings']);
        ShPrefs.instance.setStringValue(
            "departments",
            response.data['departments']
                .toString()
                .replaceAll('[', '')
                .replaceAll(']', '')
                .replaceAll(' ', ''));
        ShPrefs.instance
            .setStringValue('organization', response.data['organization']);
        return true;
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
        //if API not found
        Fluttertoast.showToast(
            msg: "الخدمة غير متاحة حاليا حاول لاحقا",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "من فضلك تأكد من إسم المستخدم و كلمة المرور",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: '${e.response}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 422) {
        Fluttertoast.showToast(
            msg: "Invalid token/header",
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

  Future<Dio> getApiLogin() async {
    _dio.interceptors.clear();
    _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options) async {
          options.headers["Accept"] = 'application/json';
          return options;
        },
        onResponse: (Response response) {
          return response; // continue
        },
        onError: (DioError error) async {}));
    return _dio;
  }

  Future<Dio> getApiClient() async {
    var token = await ShPrefs.instance.getStringValue('access_token');
    _dio.interceptors.clear();
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      // Do something before request is sent
      options.headers["Authorization"] = "Bearer " + token;
      options.headers["Accept"] = 'application/json';
      return options;
    }, onResponse: (Response response) {
      // Do something with response data
      print(response.statusCode);
      return response; // continue
    }, onError: (DioError error) async {
      print(error.response.statusCode);
      // Do something with response error
      if (error.response.statusCode == 401) {
        _dio.interceptors.requestLock.lock();
        _dio.interceptors.responseLock.lock();
        RequestOptions options = error.response.request;
        token = await reFreshToken();
        if (token != null) {
          await ShPrefs.instance.setStringValue('access_token', token);
          _dio.options.headers["Authorization"] = "Bearer " + token;
          _dio.interceptors.requestLock.unlock();
          _dio.interceptors.responseLock.unlock();
          return _dio.request(options.path, options: options);
        } else {}
      } else {
        return error;
      }
    }));
    // _dio.options.baseUrl = baseUrl;
    return _dio;
  }

  //Login with refresh token
  Future reFreshToken() async {
    String reFreshToken =
        await ShPrefs.instance.getStringValue('refresh_access_token');
    try {
      final http.Response response = await http.post(
          apiUrl +
              '/auth/access-tokens?grant_type=refresh_token&refresh_token=$reFreshToken',
          headers: {
            "accept": "application/json",
          });
      if (response.statusCode == 200) {
        Map<String, dynamic> res = jsonDecode(response.body);
        if (res['access_token'] != null) {
          await ShPrefs.instance
              .setStringValue('access_token', res['access_token']);
          return res['access_token'];
        }
      }
    } on DioError catch (e) {
      print(e.response.data);
      if (e.response.statusCode == 401) {
        //401 (Unauthorized)
        //rout to login = log out
        logOut();
      }
      if (e.response.statusCode == 400) {
        Fluttertoast.showToast(
            msg: "الخدمة غير متاحة حاليا حاول لاحقاًً",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 403) {
        //403 (Forbidden)
      }
    }

    deleteCacheDir();
  }

  Future logOut() async {
    BuildContext context;
    ShPrefs.instance.removeValue('access_token');
    Navigator.of(context).pushReplacementNamed(HomeScreen.routName);
    Fluttertoast.showToast(
        msg: "تم تسجيل الخروج بنجاح شكراً لك ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<void> deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }
}
