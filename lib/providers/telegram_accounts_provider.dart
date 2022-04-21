import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khbr_app/model/telegram_account.dart';
import 'package:khbr_app/providers/login_provider.dart';

var apiUrl = "https://dev.arapi.host";
LoginProvider _loginProvider = new LoginProvider();

class TelegramAccountProvider {
  Future<List<TelegramAccount>> getAllTelegramAccounts() async {
    try {
      Dio dio = await _loginProvider.getApiClient();
      Response response = await dio
          .get(apiUrl + '/sources/telegram/accounts/?page=1&per_page=100');
      List<TelegramAccount> telegramAccountItems = [];
      if (response.statusCode == 200) {
        for (var i in response.data["items"]) {
          TelegramAccount telegramAccountItem = new TelegramAccount(
            i["_id"],
            i["name"],
            i["active"],
            i["error"],
            i["last_active"],
            i["volume"],
            i["category_id"],
            i["category_name"],
            i["category"],
            i["custom_sources"],
            i["self"],
          );
          telegramAccountItems.add(telegramAccountItem);
        }
        return telegramAccountItems;
      }
    } on DioError catch (e) {
      print(e.response.data);
      if (e.response.statusCode == 403) {
        Fluttertoast.showToast(
          msg: "ليس لديك صلاحيات",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "${e.response.statusMessage}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
    return null;
  }

  addNewTelegramAccount(String name, String apiHash, String apiId, String phone,
      String category, int credibility,
      {List<String> customSources}) async {
    try {
      Dio dio = await _loginProvider.getApiClient();
      Response response = await dio.post(apiUrl +
          '/sources/telegram/accounts/?name=$name&api_hash=$apiHash&api_id=$apiId&phone=$phone&category=$category&credibility=$credibility');
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "تم إضافة حساب بنجاح",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } on DioError catch (e) {
      Fluttertoast.showToast(
        msg: "${e.response.statusMessage}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  removeTelegramAccount(String _id) async {
    try {
      Dio dio = await _loginProvider.getApiClient();
      Response response =
          await dio.delete(apiUrl + '/sources/telegram/accounts/$_id');
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "تم مسح الحساب بنجاح",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } on DioError catch (e) {
      Fluttertoast.showToast(
        msg: "${e.response.statusMessage}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  getTelegramAccountDetails(String _id) async {
    try {
      Dio dio = await _loginProvider.getApiClient();
      Response response =
          await dio.get(apiUrl + '/sources/telegram/accounts/$_id');
      if (response.statusCode == 200) {
        List<TelegramAccount> telegramAccountItems = [];
        if (response.statusCode == 200) {
          for (var i in response.data["items"]) {
            TelegramAccount telegramAccountItem = new TelegramAccount(
              i["_id"],
              i["name"],
              i["active"],
              i["error"],
              i["last_active"],
              i["volume"],
              i["category_id"],
              i["category_name"],
              i["category"],
              i["custom_sources"],
              i["self"],
            );
            telegramAccountItems.add(telegramAccountItem);
          }
          return telegramAccountItems;
        }
      }
    } on DioError catch (e) {
      Fluttertoast.showToast(
        msg: "${e.response.statusMessage}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  patchTelegramAccount(String _id, String name, String apiHash, String apiId,
      String phone, String category, int credibility,
      {List<String> customSources}) async {
    try {
      Dio dio = await _loginProvider.getApiClient();
      Response response = await dio.put(apiUrl +
          '/sources/telegram/accounts/$_id?name=$name&api_hash=$apiHash&api_id=$apiId&phone=$phone&category=$category&credibility=$credibility');
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "تم تعديل حساب بنجاح",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } on DioError catch (e) {
      Fluttertoast.showToast(
        msg: "${e.response.statusMessage}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  postRequestToken(String _id) async {
    try {
      Dio dio = await _loginProvider.getApiClient();
      Response response = await dio.post(apiUrl + '/$_id/request-token');
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "تم بنجاح",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } on DioError catch (e) {
      Fluttertoast.showToast(
        msg: "${e.response.statusMessage}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  postSubmitToken(String _id, String token) async {
    try {
      Dio dio = await _loginProvider.getApiClient();
      Response response =
          await dio.post(apiUrl + '/$_id/submit-token?token=$token');
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "تم بنجاح",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } on DioError catch (e) {
      Fluttertoast.showToast(
        msg: "${e.response.statusMessage}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
