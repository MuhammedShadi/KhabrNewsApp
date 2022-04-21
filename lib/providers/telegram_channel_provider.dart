import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khbr_app/model/telegram_channel.dart';
import 'package:khbr_app/model/telegram_post.dart';
import 'package:khbr_app/providers/login_provider.dart';

var apiUrl = "https://dev.arapi.host";
LoginProvider _loginProvider = new LoginProvider();

class TelegramChannelProvider {
  Future<List<TelegramChannel>> getAllTelegramAccounts() async {
    try {
      Dio dio = await _loginProvider.getApiClient();
      Response response = await dio
          .get(apiUrl + '/sources/telegram/channels/?page=1&per_page=100');
      if (response.statusCode == 200) {
        List<TelegramChannel> telegramChannelItems = [];
        for (var i in response.data["items"]) {
          TelegramChannel telegramChannelItem = new TelegramChannel(
            i["_id"],
            i["type"],
            i["name"],
            i["data"],
            i["category_name"],
            i["custom_sources"],
            i["icon"],
            i["self"],
          );
          telegramChannelItems.add(telegramChannelItem);
        }
        return telegramChannelItems;
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

  addNewTelegramChannel(
      String name, String userName, String category, int credibility) async {
    try {
      Dio dio = await _loginProvider.getApiClient();
      Response response = await dio.post(apiUrl +
          '/sources/telegram/channels/?name=$name&username=$userName&category=$category&credibility=$credibility');
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "تم إضافة القناة بنجاح",
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

  removeTelegramChannel(String _id) async {
    try {
      Dio dio = await _loginProvider.getApiClient();
      Response response =
          await dio.delete(apiUrl + '/sources/telegram/channels/$_id');
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "تم مسح القناة بنجاح",
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

  getTelegramChannelDetails(String _id) async {
    try {
      Dio dio = await _loginProvider.getApiClient();
      Response response =
          await dio.get(apiUrl + '/sources/telegram/channels/$_id');
      if (response.statusCode == 200) {
        List<TelegramChannel> telegramChannelItems = [];
        for (var i in response.data["items"]) {
          TelegramChannel telegramChannelItem = new TelegramChannel(
            i["_id"],
            i["type"],
            i["name"],
            i["data"],
            i["category_name"],
            i["custom_sources"],
            i["icon"],
            i["self"],
          );
          telegramChannelItems.add(telegramChannelItem);
        }
        return telegramChannelItems;
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

  patchTelegramChannel(
      String name, String userName, String category, int credibility) async {
    try {
      Dio dio = await _loginProvider.getApiClient();
      Response response = await dio.put(apiUrl +
          '/sources/telegram/channels/?name=$name&username=$userName&category=$category&credibility=$credibility');
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "تم تعديل القناة بنجاح",
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

  Future<List<TelegramPost>> getChannelData(String _id) async {
    try {
      Dio dio = await _loginProvider.getApiClient();
      Response response = await dio.get(
          apiUrl + '/sources/telegram/channels/$_id/data?page=1&per_page=100');
      if (response.statusCode == 200) {
        List<TelegramPost> telegramPostItems = [];
        for (var i in response.data["items"]) {
          TelegramPost telegramPostItem = new TelegramPost(
            i["_id"],
            i["date"],
            i["text"],
            i["username"],
            i["report_identifier"],
            i["universal_identifier"],
          );
          telegramPostItems.add(telegramPostItem);
        }
        return telegramPostItems;
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
    return null;
  }
}
