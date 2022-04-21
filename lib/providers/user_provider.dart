import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khbr_app/providers/login_provider.dart';
import 'package:khbr_app/providers/sh_prefs.dart';

LoginProvider _loginProvider = new LoginProvider();

class UserProvider {
  getAllUsers() async {
    Dio dio = await _loginProvider.getApiLogin();
    String token = await ShPrefs.instance.getStringValue("access_token");
    String filterParam = "";
    String userQuery = "";
    String userName = "test12";
    String userEmail = "dasd";
    String userFirstName = "";
    String userLastName = "";
    bool userActive = false;
    String userOrganization = "";
    String userDepartments = "";
    String userAccountType = "";
    String userPermissions = "";
    String userEndpoints = "";
    String userPage = "";
    int userPerPage = 1;
    if (userQuery != null && userQuery.isNotEmpty) {
      filterParam += "query=$userQuery";
    }
    if (userName != null && userName.isNotEmpty) {
      filterParam += "&username=$userName";
    }
    if (userEmail != null && userEmail.isNotEmpty) {
      filterParam += "&email=$userEmail";
    }
    if (userFirstName != null && userFirstName.isNotEmpty) {
      filterParam += "&first_name=$userFirstName";
    }
    if (userLastName != null && userLastName.isNotEmpty) {
      filterParam += "&last_name=$userLastName";
    }
    if (userOrganization != null && userOrganization.isNotEmpty) {
      filterParam += "&organization=$userOrganization";
    }
    if (userDepartments != null && userDepartments.isNotEmpty) {
      filterParam += "&departments=$userDepartments";
    }
    if (userAccountType != null && userAccountType.isNotEmpty) {
      filterParam += "&account_type=$userAccountType";
    }
    if (userPermissions != null && userPermissions.isNotEmpty) {
      filterParam += "&permissions=$userPermissions";
    }
    if (userEndpoints != null && userEndpoints.isNotEmpty) {
      filterParam += "&endpoints=$userEndpoints";
    }
    if (userPage != null && userPage.isNotEmpty) {
      filterParam += "&page=$userPage";
    }
    if (userPerPage != null && userPerPage.toString().isNotEmpty) {
      filterParam += "&per_page=$userPerPage";
    }
    if (userActive != null && userActive.toString().isNotEmpty) {
      filterParam += "&active=$userActive";
    }
    try {
      Response response = await dio.get(apiUrl + '/users/?$filterParam',
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
            fontSize: 16.0);
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
        Fluttertoast.showToast(
            msg:
                "كلمة مرور ضعيفة / اسم مستخدم أو بريد إلكتروني مكرر أو غير صالح",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: "ليس لديك صلاحيات",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 402) {}
      if (e.response.statusCode == 403) {}
    }
  }

  getUserDetailsByUserName(String userName) async {
    Dio dio = await _loginProvider.getApiLogin();
    String token = await ShPrefs.instance.getStringValue("access_token");
    try {
      Response response = await dio.get(apiUrl + '/users/$userName',
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token ",
          }));
      if (response.statusCode == 200) {
        print(response.data);
        ShPrefs.instance.setStringValue('email', response.data['email']);
        ShPrefs.instance.setStringValue('fname', response.data['first_name']);
        ShPrefs.instance.setStringValue('lname', response.data['last_name']);
        Fluttertoast.showToast(
            msg: "تم بنجاح",
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
            msg: "ليس لديك صلاحيات",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 404) {
        Fluttertoast.showToast(
            msg: "لا يوجد مستخدم بهذا الاسم",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  deleteUserAccount(String userName, bool select) async {
    try {
      Dio dio = await _loginProvider.getApiLogin();
      Response response =
          await dio.delete(apiUrl + '/users/$userName?delete_user=$select',
              data: {},
              options: Options(headers: {
                "accept": "application/json",
                "Authorization":
                    "Bearer ${await ShPrefs.instance.getStringValue('access_token')} ",
              }));
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "تم وقف الحساب ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        _loginProvider.logOut();
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "من فضلك تأكد من إسم المستخدم",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: "ليس لديك الصلاحيات",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 404) {
        Fluttertoast.showToast(
            msg: " إسم المستخدم غير موجود ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  getUserPermission(String permissionsUrl) async {
    Dio dio = await _loginProvider.getApiLogin();
    String token = await ShPrefs.instance.getStringValue("access_token");
    Map<String, dynamic> userPermissions;
    try {
      Response response = await dio.get(apiUrl + permissionsUrl,
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer  $token",
          }));
      if (response.statusCode == 200) {
        ShPrefs.instance.setStringValue(
            "permissions",
            response.data["permissions"][12]["permissions"]
                .toString()
                .replaceAll('[', '')
                .replaceAll(']', '')
                .replaceAll(' ', ''));
        ShPrefs.instance.setStringValue(
            "userspermissions",
            response.data["permissions"][9]["permissions"]
                .toString()
                .replaceAll('[', '')
                .replaceAll(']', '')
                .replaceAll(' ', ''));
        userPermissions = response.data;
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
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
            msg: "بيانات غير صحيحة",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 402) {}
      if (e.response.statusCode == 403) {}
    }
    return userPermissions;
  }

  putUserSetting(String userSettingsUrl) async {
    Dio dio = await _loginProvider.getApiLogin();
    String token = await ShPrefs.instance.getStringValue("access_token");
    Map<String, dynamic> userSettings;
    // String filterParam = "";
    try {
      Response response = await dio.put(apiUrl + userSettingsUrl,
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          }));
      if (response.statusCode == 200) {
        userSettings = response.data;
        ShPrefs.instance.setStringValue('email', response.data['email']);
        ShPrefs.instance.setStringValue('fname', response.data['first_name']);
        ShPrefs.instance.setStringValue('lname', response.data['last_name']);
        return userSettings;
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
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
            msg: "بيانات غير صحيحة",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 402) {}
      if (e.response.statusCode == 403) {}
    }
  }

  reSetPassword(String oldPassWord, String newPassWord) async {
    Dio dio = await _loginProvider.getApiLogin();
    String userName = await ShPrefs.instance.getStringValue('userName');
    try {
      Response response = await dio.put(
          apiUrl +
              '/users/$userName/password?old_password=$oldPassWord&new_password=$newPassWord',
          data: {
            "username": userName,
            "password": newPassWord,
          },
          options: Options(headers: {
            "accept": "application/json",
            "Authorization":
                "Bearer ${await ShPrefs.instance.getStringValue('access_token')}",
          }));
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "تم تغيير كلمة المرور بنجاح قم بتسجيل الدخول مرة أخرى",
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
            msg:
                "يجب أن تتكون كلمة المرور من 8 أحرف على الأقل ، ويجب أن تحتوي كلمة المرور على رقم واحد على الأقل ، ويجب أن تحتوي كلمة المرور على رمز واحد على الأقل من! # ٪ & '() * +، -.، -. / \\ ^ _ `{|} ~ @ ، يجب أن تحتوي كلمة المرور على حرف واحد كبير على الأقل (az) ، ويجب أن تحتوي كلمة المرور على حرف صغير واحد على الأقل (az)",
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
      if (e.response.statusCode == 404) {
        Fluttertoast.showToast(
            msg: " إسم المستخدم غير موجود ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  changeUserPassword(String userName, String passWord) async {
    try {
      Dio dio = await _loginProvider.getApiLogin();
      Response response = await dio.delete(
          apiUrl + '/users/$userName/password?new_password=$passWord',
          data: {
            "username": userName,
            "password": passWord,
          },
          options: Options(headers: {
            "accept": "application/json",
            "Authorization":
                "Bearer ${ShPrefs.instance.getStringValue('access_token')}",
          }));

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "تم تغيير كلمة المرور بنجاح قم بتسجيل الدخول مرة أخرى",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } on DioError catch (e) {
      print(e.response.statusCode);
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
            msg: "غير متاح حالياً ليس لديك صلاحيات",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 404) {
        Fluttertoast.showToast(
            msg: " إسم المستخدم غير موجود ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "${e.response.statusMessage}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  getUserHierarchyByUserName(String userName) async {
    Dio dio = await _loginProvider.getApiLogin();
    String token = await ShPrefs.instance.getStringValue("access_token");
    try {
      Response response = await dio.get(apiUrl + '/users/$userName/hierarchy',
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token ",
          }));
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "تم بنجاح",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
        Fluttertoast.showToast(
            msg: "ليس لديك صلاحيات",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: "ليس لديك صلاحيات",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 404) {
        Fluttertoast.showToast(
            msg: "لا يوجد مستخدم بهذا الاسم",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  putUserHierarchyByUserName(String userName) async {
    Dio dio = await _loginProvider.getApiLogin();
    String token = await ShPrefs.instance.getStringValue("access_token");
    try {
      Response response = await dio.put(apiUrl + '/users/$userName/hierarchy',
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token ",
          }));
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "تم بنجاح",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
        Fluttertoast.showToast(
            msg: "ليس لديك صلاحيات",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: "ليس لديك صلاحيات",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 404) {
        Fluttertoast.showToast(
            msg: "لا يوجد مستخدم بهذا الاسم",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  deleteUserPermission(String userName) async {
    Dio dio = await _loginProvider.getApiLogin();
    String token = await ShPrefs.instance.getStringValue("access_token");
    String userEndPoints = "twitter-trends";
    String userPermissions = "packages: [ modify-package, delete-package ]";
    try {
      Response response = await dio.delete(
          apiUrl +
              "/$userName/permissions?endpoint=$userEndPoints&permissions=${Uri.encodeFull(userPermissions)}",
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer  $token",
          }));
      if (response.statusCode == 200) {}
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
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
            msg: "بيانات غير صحيحة",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: "بيانات غير صحيحة",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 404) {
        Fluttertoast.showToast(
            msg: "لا يوجد",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  postUserPermission(String userName) async {
    Dio dio = await _loginProvider.getApiLogin();
    String token = await ShPrefs.instance.getStringValue("access_token");
    String userEndPoints = "twitter-trends";
    String userPermissions = "packages: [ modify-package, delete-package ]";
    try {
      Response response = await dio.post(
          apiUrl +
              "/$userName/permissions?endpoint=$userEndPoints&permissions=${Uri.encodeFull(userPermissions)}",
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer  $token",
          }));
      if (response.statusCode == 200) {}
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
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
            msg: "بيانات غير صحيحة",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: "بيانات غير صحيحة",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 404) {
        Fluttertoast.showToast(
            msg: "لا يوجد",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  getUserSetting(String userName) async {
    Dio dio = await _loginProvider.getApiLogin();
    String token = await ShPrefs.instance.getStringValue("access_token");

    try {
      Response response = await dio.get(apiUrl + '/users/$userName/settings',
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          }));
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "بيانات صحيحة",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
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
            msg: "بيانات غير صحيحة",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 404) {
        Fluttertoast.showToast(
            msg: "بيانات غير موجودة",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 403) {}
    }
  }

  getUserLimits(String userName) async {
    Dio dio = await _loginProvider.getApiLogin();
    String token = await ShPrefs.instance.getStringValue("access_token");

    try {
      Response response = await dio.get(apiUrl + '/users/$userName/rate-limits',
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          }));
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "بيانات صحيحة",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
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
            msg: "بيانات غير صحيحة",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 404) {
        Fluttertoast.showToast(
            msg: "بيانات غير موجودة",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: "ليس لديك صلاحية",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  putUserLimits(String userName) async {
    Dio dio = await _loginProvider.getApiLogin();
    String token = await ShPrefs.instance.getStringValue("access_token");
    String userSources = "tier-1";
    String userNlpToolkit = "tier-1";
    String userReports = "tier-1";
    String userWebSockets = "tier-1";
    try {
      Response response = await dio.put(
          apiUrl +
              '/users/$userName/rate-limits?sources=$userSources&nlp-toolkit=$userNlpToolkit&reports=$userReports&websockets=$userWebSockets',
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          }));
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "بيانات صحيحة",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
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
            msg: "بيانات غير صحيحة",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 404) {
        Fluttertoast.showToast(
            msg: "بيانات غير موجودة",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: "ليس لديك صلاحية",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  userCallBack(String code, String sessionState) async {
    Dio dio = await _loginProvider.getApiLogin();
    try {
      Response response = await dio.get(
          apiUrl +
              '/auth/openid/callback?code=$code&session_state=$sessionState',
          options: Options(headers: {
            "accept": "application/json",
          }));
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "تم التسجيل بنجاح",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
        Fluttertoast.showToast(
            msg: "فشل التحقق من مطالبات المستخدم",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "رمز تم إبطاله / منتهي الصلاحية أو بيانات اعتماد غير صحيحة",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 404) {
        Fluttertoast.showToast(
            msg: "بيانات غير موجودة",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 403) {
        Fluttertoast.showToast(
            msg:
                "الرمز المميز المقدم ليس رمز تحديث أو تم إلغاء تنشيط حساب المستخدم أو رمز التحديث فارغ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 422) {
        Fluttertoast.showToast(
            msg: "رمز غير صالح",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 500) {
        Fluttertoast.showToast(
            msg: "خطأ في الخادم الداخلي",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }
}
