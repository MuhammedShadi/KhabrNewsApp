import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khbr_app/model/report_item.dart';
import 'package:khbr_app/providers/login_provider.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:khbr_app/providers/sh_prefs.dart';

var apiUrl = "https://dev.arapi.host";
LoginProvider _loginProvider = new LoginProvider();

class ReportProvider {
  Future<List<ReportItem>> getAllReports() async {
    Dio dio = await _loginProvider.getApiClient();
    Response response =
        await dio.get(apiUrl + '/reports/saved?page=1&per_page=100');

    List<ReportItem> reportItems = [];
    for (var i in response.data["items"]) {
      ReportItem reportItem = new ReportItem(
        i["_id"],
        i["name"],
        i["title"],
        i["description"],
        i["created_at"],
        i["whitelisted_departments"],
        i["owner"],
        i["author"],
        i["author_profile_picture"],
        i["most_recent_version"],
        i["self"],
      );
      reportItems.add(reportItem);
    }
    return reportItems;
  }

  deleteReport(String reportId, String reportName) async {
    Dio dio = await _loginProvider.getApiClient();
    try {
      Response response = await dio.delete(apiUrl + '/reports/saved/$reportId',
          options: Options(headers: {
            "accept": "application/json",
          }));
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "تم مسح التقرير بنجاح $reportName",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: "غير مسموح",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 401) {
        Fluttertoast.showToast(
            msg: " حاول مرة ثانية ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  Future<File> postReportSelf(String reportSelf) async {
    Dio dio = await _loginProvider.getApiClient();
    Response response = await dio.post(apiUrl + reportSelf + "/files",
        data: {"report_type": "compilation", "formats": "pdf"});
    Uint8List bytes = base64.decode(response.data['files'][0]['file']);
    String dir = (await getTemporaryDirectory()).path;
    File temp = new File('$dir/temp.file');
    await temp.writeAsBytes(bytes);
    return temp;
  }

  postReportCompile() async {
    String token = await ShPrefs.instance.getStringValue("access_token");
    Dio dio = await _loginProvider.getApiClient();
    try {
      Response response = await dio.post(apiUrl + "/reports/compile",
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          }));
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
      if (e.response.statusCode == 400) {
        Fluttertoast.showToast(
          msg: "تأكد من البيانات",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: "لم يتم",
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

  getReportDetails(String reportIdentifier) async {
    String token = await ShPrefs.instance.getStringValue("access_token");
    Dio dio = await _loginProvider.getApiClient();
    try {
      Response response =
          await dio.get(apiUrl + "/reports/identifiers/$reportIdentifier",
              options: Options(headers: {
                "accept": "application/json",
                "Authorization": "Bearer $token",
              }));
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
      if (e.response.statusCode == 400) {
        Fluttertoast.showToast(
          msg: "تأكد من البيانات",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: "لم يتم",
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

  getAllSavedReportDetails() async {
    String token = await ShPrefs.instance.getStringValue("access_token");
    String filterParm = "";
    String pageNumber = "1";
    int perPage = 1;
    String query = "تجريبي";
    String author = "khabar";
    String name = "تجريبي";
    String title = "13:43:46 19-10-2020";
    String description = '';
    String fromDate = '2020-10-19 13:43';
    String toDate = '2020-10-19 13:43';
    if (pageNumber != null && pageNumber.isNotEmpty) {
      filterParm += 'page=$pageNumber';
    }
    if (perPage != null && perPage.toString().isNotEmpty) {
      filterParm += '&per_page=$perPage';
    }
    if (query != null && query.isNotEmpty) {
      filterParm += '&query=${Uri.encodeFull(query)}';
    }
    if (author != null && author.isNotEmpty) {
      filterParm += '&author=$author';
    }
    if (name != null && name.isNotEmpty) {
      filterParm += '&name=${Uri.encodeFull(name)}';
    }
    if (title != null && title.isNotEmpty) {
      filterParm += '&title=${Uri.encodeFull(title)}';
    }
    if (description != null && description.isNotEmpty) {
      filterParm += '&description=${Uri.encodeFull(description)}';
    }
    if (fromDate != null && fromDate.isNotEmpty) {
      filterParm += '&from_date=${Uri.encodeFull(fromDate)}';
    }
    if (toDate != null && toDate.isNotEmpty) {
      filterParm += '&to_date=${Uri.encodeFull(toDate)}';
    }
    Dio dio = await _loginProvider.getApiClient();
    try {
      Response response = await dio.get(apiUrl + "/reports/saved?$filterParm",
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          }));
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
      if (e.response.statusCode == 400) {
        Fluttertoast.showToast(
          msg: "تأكد من البيانات",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: "لم يتم",
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

  postReportMerge() async {
    String token = await ShPrefs.instance.getStringValue("access_token");
    Dio dio = await _loginProvider.getApiClient();
    try {
      Response response = await dio.post(apiUrl + "/reports/merge",
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          }));
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
      if (e.response.statusCode == 400) {
        Fluttertoast.showToast(
          msg: "تأكد من البيانات",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: "لم يتم",
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

  getSavedReportById(String reportIdentifier) async {
    String token = await ShPrefs.instance.getStringValue("access_token");
    Dio dio = await _loginProvider.getApiClient();
    try {
      Response response =
          await dio.get(apiUrl + "/reports/saved/$reportIdentifier",
              options: Options(headers: {
                "accept": "application/json",
                "Authorization": "Bearer $token",
              }));
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
      if (e.response.statusCode == 400) {
        Fluttertoast.showToast(
          msg: "تأكد من البيانات",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: "لم يتم",
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

  postNewVersionReport(String reportIdentifier) async {
    String token = await ShPrefs.instance.getStringValue("access_token");
    Dio dio = await _loginProvider.getApiClient();
    String filterParm = '';
    int numberEmbeddedDocuments;
    if (numberEmbeddedDocuments != null &&
        numberEmbeddedDocuments.toString().isNotEmpty) {
      filterParm +=
          '?number_embedded_documents=${numberEmbeddedDocuments.toString()}';
    }
    try {
      Response response =
          await dio.post(apiUrl + "/reports/saved/$reportIdentifier$filterParm",
              options: Options(headers: {
                "accept": "application/json",
                "Authorization": "Bearer $token",
              }));
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
      if (e.response.statusCode == 400) {
        Fluttertoast.showToast(
          msg: "تأكد من البيانات",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: "لم يتم",
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

  getSavedReportNotes(String reportIdentifier) async {
    String token = await ShPrefs.instance.getStringValue("access_token");
    String filterParm = "";
    String pageNumber = "1";
    int perPage = 1;
    String author = "khabar";
    bool acknowledged = false;
    String acknowledgedBy = "";
    String fromDate = '2020-10-19 13:43';
    String toDate = '2020-10-19 13:43';
    if (pageNumber != null && pageNumber.isNotEmpty) {
      filterParm += 'page=$pageNumber';
    }
    if (perPage != null && perPage.toString().isNotEmpty) {
      filterParm += '&per_page=$perPage';
    }
    if (acknowledged != null && acknowledged.toString().isNotEmpty) {
      filterParm += '&acknowledged=$acknowledged';
    }
    if (author != null && author.isNotEmpty) {
      filterParm += '&author=$author';
    }
    if (acknowledgedBy != null && acknowledgedBy.isNotEmpty) {
      filterParm += '&acknowledged_by=$acknowledgedBy';
    }
    if (fromDate != null && fromDate.isNotEmpty) {
      filterParm += '&from_date=${Uri.encodeFull(fromDate)}';
    }
    if (toDate != null && toDate.isNotEmpty) {
      filterParm += '&to_date=${Uri.encodeFull(toDate)}';
    }
    Dio dio = await _loginProvider.getApiClient();
    try {
      Response response = await dio.get(
          apiUrl + "/reports/saved/$reportIdentifier/notes?$filterParm",
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          }));
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
      if (e.response.statusCode == 400) {
        Fluttertoast.showToast(
          msg: "تأكد من البيانات",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: "لم يتم",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 403) {
        Fluttertoast.showToast(
          msg: "غير مسموح ليس لديك صلاحيات",
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

  getSavedReportVersion(String reportIdentifier, String reportVersion) async {
    String token = await ShPrefs.instance.getStringValue("access_token");
    String filterParm = "";
    int numberEmbeddedDocuments = 1;
    bool isUsed = false;
    if (isUsed != null && isUsed.toString().isNotEmpty) {
      filterParm += 'is_used=$isUsed';
    }
    if (numberEmbeddedDocuments != null &&
        numberEmbeddedDocuments.toString().isNotEmpty) {
      filterParm += '&number_embedded_documents=$numberEmbeddedDocuments';
    }
    Dio dio = await _loginProvider.getApiClient();
    try {
      Response response = await dio.get(
          apiUrl +
              "/reports/saved/$reportIdentifier/versions/$reportVersion?$filterParm",
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          }));
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
      if (e.response.statusCode == 400) {
        Fluttertoast.showToast(
          msg: "تأكد من البيانات",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: "لم يتم",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 403) {
        Fluttertoast.showToast(
          msg: "غير مسموح ليس لديك صلاحيات",
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

  deleteSavedReportVersion(
      String reportIdentifier, String reportVersion) async {
    String token = await ShPrefs.instance.getStringValue("access_token");
    Dio dio = await _loginProvider.getApiClient();
    try {
      Response response = await dio.delete(
          apiUrl + "/reports/saved/$reportIdentifier/versions/$reportVersion",
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          }));
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
      if (e.response.statusCode == 400) {
        Fluttertoast.showToast(
          msg: "تأكد من البيانات",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: "لم يتم",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 403) {
        Fluttertoast.showToast(
          msg: "غير مسموح ليس لديك صلاحيات",
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

  getSavedReportVersionFacts(
      String reportIdentifier, String reportVersion) async {
    String token = await ShPrefs.instance.getStringValue("access_token");
    String filterParm = "";
    String pageNumber = "1";
    int perPage = 1;
    bool isUsed = false;
    if (pageNumber != null && pageNumber.isNotEmpty) {
      filterParm += 'page=$pageNumber';
    }
    if (perPage != null && perPage.toString().isNotEmpty) {
      filterParm += '&per_page=$perPage';
    }
    if (isUsed != null && isUsed.toString().isNotEmpty) {
      filterParm += '&is_used=$isUsed';
    }
    Dio dio = await _loginProvider.getApiClient();
    try {
      Response response = await dio.get(
          apiUrl +
              "/reports/saved/$reportIdentifier/versions/$reportVersion/facts?$filterParm",
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          }));
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
      if (e.response.statusCode == 400) {
        Fluttertoast.showToast(
          msg: "تأكد من البيانات",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: "لم يتم",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 403) {
        Fluttertoast.showToast(
          msg: "غير مسموح ليس لديك صلاحيات",
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

  postSavedReportVersionFacts(
      String reportIdentifier, String reportVersion) async {
    String token = await ShPrefs.instance.getStringValue("access_token");
    String filterParm = "";
    String factIds = "1";
    bool isUsed = false;
    if (factIds != null && factIds.isNotEmpty) {
      filterParm += 'fact_ids=$factIds';
    }
    if (isUsed != null && isUsed.toString().isNotEmpty) {
      filterParm += '&is_used=$isUsed';
    }
    Dio dio = await _loginProvider.getApiClient();
    try {
      Response response = await dio.post(
          apiUrl +
              "/reports/saved/$reportIdentifier/versions/$reportVersion/facts?$filterParm",
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          }));
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
      if (e.response.statusCode == 400) {
        Fluttertoast.showToast(
          msg: "تأكد من البيانات",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: "لم يتم",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 403) {
        Fluttertoast.showToast(
          msg: "غير مسموح ليس لديك صلاحيات",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 404) {
        Fluttertoast.showToast(
          msg: "لا يوجد",
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

  getSavedReportVersionFact(
      String reportIdentifier, String reportVersion, String factId) async {
    String token = await ShPrefs.instance.getStringValue("access_token");
    Dio dio = await _loginProvider.getApiClient();
    try {
      Response response = await dio.get(
          apiUrl +
              "/reports/saved/$reportIdentifier/versions/$reportVersion/facts/$factId",
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          }));
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
      if (e.response.statusCode == 400) {
        Fluttertoast.showToast(
          msg: "تأكد من البيانات",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: "لم يتم",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 403) {
        Fluttertoast.showToast(
          msg: "غير مسموح ليس لديك صلاحيات",
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

  deleteSavedReportVersionFact(
      String reportIdentifier, String reportVersion, String factId) async {
    String token = await ShPrefs.instance.getStringValue("access_token");
    Dio dio = await _loginProvider.getApiClient();
    try {
      Response response = await dio.delete(
          apiUrl +
              "/reports/saved/$reportIdentifier/versions/$reportVersion/facts/$factId",
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          }));
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
      if (e.response.statusCode == 400) {
        Fluttertoast.showToast(
          msg: "تأكد من البيانات",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: "لم يتم",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 403) {
        Fluttertoast.showToast(
          msg: "غير مسموح ليس لديك صلاحيات",
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

  replaceSavedReportVersionFact(
      String reportIdentifier, String reportVersion, String factId) async {
    String token = await ShPrefs.instance.getStringValue("access_token");
    Dio dio = await _loginProvider.getApiClient();
    try {
      Response response = await dio.put(
          apiUrl +
              "/reports/saved/$reportIdentifier/versions/$reportVersion/facts/$factId",
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          }));
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
      if (e.response.statusCode == 400) {
        Fluttertoast.showToast(
          msg: "تأكد من البيانات",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: "لم يتم",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 403) {
        Fluttertoast.showToast(
          msg: "غير مسموح ليس لديك صلاحيات",
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

  postSavedReportVersionFact(
      String reportIdentifier, String reportVersion, String factId) async {
    String token = await ShPrefs.instance.getStringValue("access_token");
    Dio dio = await _loginProvider.getApiClient();
    try {
      Response response = await dio.post(
          apiUrl +
              "/reports/saved/$reportIdentifier/versions/$reportVersion/facts/$factId",
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          }));
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
      if (e.response.statusCode == 400) {
        Fluttertoast.showToast(
          msg: "تأكد من البيانات",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: "لم يتم",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 403) {
        Fluttertoast.showToast(
          msg: "غير مسموح ليس لديك صلاحيات",
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

  exportSavedReportVersionFact(
      String reportIdentifier, String reportVersion) async {
    String token = await ShPrefs.instance.getStringValue("access_token");
    Dio dio = await _loginProvider.getApiClient();
    String filterParm = "";
    String reportType = "compilation";
    String formats = "pdf";
    if (formats != null && formats.isNotEmpty) {
      filterParm += "formats=$formats";
    }
    if (reportType != null && reportType.isNotEmpty) {
      filterParm += "&report_type=$reportType";
    }
    try {
      Response response = await dio.post(
          apiUrl +
              "/reports/saved/$reportIdentifier/versions/$reportVersion/files?$filterParm",
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          }));
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
      if (e.response.statusCode == 400) {
        Fluttertoast.showToast(
          msg: "تأكد من البيانات",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: "لم يتم",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 403) {
        Fluttertoast.showToast(
          msg: "غير مسموح ليس لديك صلاحيات",
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

  getSavedReportVersionNotes(
      String reportIdentifier, String reportVersion) async {
    String token = await ShPrefs.instance.getStringValue("access_token");
    String filterParm = "";
    String pageNumber = "1";
    int perPage = 1;
    String author = "khabar";
    bool acknowledged = false;
    String acknowledgedBy = "";
    String fromDate = '2020-10-19 13:43';
    String toDate = '2020-10-19 13:43';
    if (pageNumber != null && pageNumber.isNotEmpty) {
      filterParm += 'page=$pageNumber';
    }
    if (perPage != null && perPage.toString().isNotEmpty) {
      filterParm += '&per_page=$perPage';
    }
    if (acknowledged != null && acknowledged.toString().isNotEmpty) {
      filterParm += '&acknowledged=$acknowledged';
    }
    if (author != null && author.isNotEmpty) {
      filterParm += '&author=$author';
    }
    if (acknowledgedBy != null && acknowledgedBy.isNotEmpty) {
      filterParm += '&acknowledged_by=$acknowledgedBy';
    }
    if (fromDate != null && fromDate.isNotEmpty) {
      filterParm += '&from_date=${Uri.encodeFull(fromDate)}';
    }
    if (toDate != null && toDate.isNotEmpty) {
      filterParm += '&to_date=${Uri.encodeFull(toDate)}';
    }
    Dio dio = await _loginProvider.getApiClient();
    try {
      Response response = await dio.get(
          apiUrl +
              "/reports/saved/$reportIdentifier/versions/$reportVersion/notes?$filterParm",
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          }));
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
      if (e.response.statusCode == 400) {
        Fluttertoast.showToast(
          msg: "تأكد من البيانات",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: "لم يتم",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 403) {
        Fluttertoast.showToast(
          msg: "غير مسموح ليس لديك صلاحيات",
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

  postSavedReportVersionNotes(
      String reportIdentifier, String reportVersion) async {
    String token = await ShPrefs.instance.getStringValue("access_token");
    String filterParm = "";
    String text = "1";
    int numberEmbeddedDocuments = 1;
    String meantForDepartments = "all";
    if (text != null && text.isNotEmpty) {
      filterParm += '?text=$text';
    }
    if (numberEmbeddedDocuments != null &&
        numberEmbeddedDocuments.toString().isNotEmpty) {
      filterParm += '&number_embedded_documents=$numberEmbeddedDocuments';
    }
    if (meantForDepartments != null && meantForDepartments.isNotEmpty) {
      filterParm += '&meant_for_users=$meantForDepartments';
    }
    Dio dio = await _loginProvider.getApiClient();
    try {
      Response response = await dio.post(
          apiUrl +
              "/reports/saved/$reportIdentifier/versions/$reportVersion/notes$filterParm",
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          }));
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
      if (e.response.statusCode == 400) {
        Fluttertoast.showToast(
          msg: "تأكد من البيانات",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: "لم يتم",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 403) {
        Fluttertoast.showToast(
          msg: "غير مسموح ليس لديك صلاحيات",
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

  getSavedReportVersionNotesByNotesId(
      String reportIdentifier, String reportVersion, String noteId) async {
    String token = await ShPrefs.instance.getStringValue("access_token");
    Dio dio = await _loginProvider.getApiClient();
    try {
      Response response = await dio.get(
          apiUrl +
              "/reports/saved/$reportIdentifier/versions/$reportVersion/notes/$noteId",
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          }));
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
      if (e.response.statusCode == 400) {
        Fluttertoast.showToast(
          msg: "تأكد من البيانات",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: "لم يتم",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 403) {
        Fluttertoast.showToast(
          msg: "غير مسموح ليس لديك صلاحيات",
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

  postSavedReportVersionNotesByNotesId(
      String reportIdentifier, String reportVersion, String noteId) async {
    String token = await ShPrefs.instance.getStringValue("access_token");
    Dio dio = await _loginProvider.getApiClient();
    try {
      Response response = await dio.post(
          apiUrl +
              "/reports/saved/$reportIdentifier/versions/$reportVersion/notes/$noteId",
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          }));
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
      if (e.response.statusCode == 400) {
        Fluttertoast.showToast(
          msg: "تأكد من البيانات",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: "لم يتم",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 403) {
        Fluttertoast.showToast(
          msg: "غير مسموح ليس لديك صلاحيات",
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

  deleteSavedReportVersionNotesByNotesId(
      String reportIdentifier, String reportVersion, String noteId) async {
    String token = await ShPrefs.instance.getStringValue("access_token");
    Dio dio = await _loginProvider.getApiClient();
    try {
      Response response = await dio.delete(
          apiUrl +
              "/reports/saved/$reportIdentifier/versions/$reportVersion/notes/$noteId",
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          }));
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
      if (e.response.statusCode == 400) {
        Fluttertoast.showToast(
          msg: "تأكد من البيانات",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: "لم يتم",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (e.response.statusCode == 403) {
        Fluttertoast.showToast(
          msg: "غير مسموح ليس لديك صلاحيات",
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
}
