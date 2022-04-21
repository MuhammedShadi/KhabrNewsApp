import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khbr_app/model/category_item.dart';
import 'package:khbr_app/providers/login_provider.dart';
import 'package:khbr_app/model/category_sources.dart';
import 'package:dio/dio.dart';
import 'package:khbr_app/providers/sh_prefs.dart';

var apiUrl = "https://dev.arapi.host";
LoginProvider _loginProvider = new LoginProvider();

class CategoryProvider {
  //get Category Choices
  Future<List<CateItems>> getCategoryChoices() async {
    Dio dio = await _loginProvider.getApiClient();
    Response response = await dio.get(apiUrl + '/feeds/categories/choices');
    List<CateItems> categories = [];
    for (var i in response.data["items"]) {
      CateItems category = CateItems(
        i["_id"],
        i["name"],
        i["data"],
        i["sources"],
      );
      categories.add(category);
    }
    return categories;
  }

  Future<List<CateItems>> getCategoryChoicesP({int pageNum = 1}) async {
    int maxPages = pageNum;
    String maxPageS =
        await ShPrefs.instance.getStringValue('categoryChoicesPages');
    List<CateItems> categories = [];
    if (maxPageS != "") {
      maxPages = int.parse(maxPageS);
    }
    if (pageNum <= maxPages) {
      Dio dio = await _loginProvider.getApiClient();
      Response response = await dio
          .get(apiUrl + '/feeds/categories/choices?page=$pageNum&per_page=5');
      ShPrefs.instance.setStringValue(
          'categoryChoicesPages', response.data['pages'].toString());
      for (var i in response.data["items"]) {
        CateItems category = CateItems(
          i["_id"],
          i["name"],
          i["data"],
          i["sources"],
        );
        categories.add(category);
      }
    }
    return categories;
  }

  Future<List<CateItems>> getCategoryChoicesByName(String name) async {
    Dio dio = await _loginProvider.getApiClient();
    Response response = await dio.get(
        apiUrl + '/feeds/categories/choices/?name=${Uri.encodeFull(name)}');
    List<CateItems> categories = [];
    for (var i in response.data["items"]) {
      CateItems category = CateItems(
        i["_id"],
        i["name"],
        i["data"],
        i["sources"],
      );
      categories.add(category);
    }
    return categories;
  }

  Future<List<CateItems>> getCategorySubscribed() async {
    Dio dio = await _loginProvider.getApiClient();
    Response response = await dio.get(apiUrl + '/feeds/categories/subscribed');
    List<CateItems> categories = [];
    for (var i in response.data["items"]) {
      CateItems category = CateItems(
        i["_id"],
        i["name"],
        i["data"],
        i["sources"],
      );
      categories.add(category);
    }
    return categories;
  }

  Future<List<CateItems>> getCategorySubscribedP({int pageNum = 1}) async {
    int maxPages = pageNum;
    String maxPageS =
        await ShPrefs.instance.getStringValue('categorySubscribedPages');
    List<CateItems> categories = [];
    if (maxPageS != "") {
      maxPages = int.parse(maxPageS);
    }
    if (pageNum <= maxPages) {
      Dio dio = await _loginProvider.getApiClient();
      Response response = await dio.get(
          apiUrl + '/feeds/categories/subscribed?page=$pageNum&per_page=5');
      ShPrefs.instance.setStringValue(
          'categorySubscribedPages', response.data['pages'].toString());
      for (var i in response.data["items"]) {
        CateItems category = CateItems(
          i["_id"],
          i["name"],
          i["data"],
          i["sources"],
        );
        categories.add(category);
      }
    }
    return categories;
  }

  Future<List<CateItems>> getCategorySubscribedByName(String name) async {
    Dio dio = await _loginProvider.getApiClient();
    Response response = await dio.get(
        apiUrl + '/feeds/categories/subscribed?name=${Uri.encodeFull(name)}');
    List<CateItems> categories = [];
    for (var i in response.data["items"]) {
      CateItems category = CateItems(
        i["_id"],
        i["name"],
        i["data"],
        i["sources"],
      );
      categories.add(category);
    }
    return categories;
  }

//get subscribe for selected sources
  Future subscribeSource(String id, String name) async {
    Dio dio = await _loginProvider.getApiClient();
    Response response =
        await dio.post(apiUrl + '/feeds/sources/subscribed?_id=$id');
    if (response.statusCode == 204) {
      Fluttertoast.showToast(
          msg: " تم إضافة $name بنجاح",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

//get unsubscribe categorySources
  Future unsubscribeSource(String id, String name) async {
    Dio dio = await _loginProvider.getApiClient();
    Response response =
        await dio.delete(apiUrl + '/feeds/sources/subscribed?_id=$id');
    if (response.statusCode == 204) {
      Fluttertoast.showToast(
          msg: " تم مسح $name  بنجاح  ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<List<CategorySources>> getCategorySourcesChoicesByTypes(
      String categoryName, String filterType) async {
    String types = "";
    if (ShPrefs.instance.getStringValue(filterType) != null) {
      types = await ShPrefs.instance.getStringValue(filterType);
    }

    Dio dio = await _loginProvider.getApiClient();
    Response response = await dio.get(apiUrl +
        "/feeds/sources/choices?categories=${Uri.encodeFull(categoryName)}" +
        types);
    List<CategorySources> categoriesSources = [];
    for (var i in response.data["items"]) {
      CategorySources categorySources = CategorySources(
        i["_id"],
        i["type"],
        i["name"],
        i["data"],
        i["url"],
        i["categoryName"],
        i["categorySourcs"],
        i["icon"],
        i["self"],
      );
      categoriesSources.add(categorySources);
    }
    return categoriesSources;
  }

  Future<List<CategorySources>> getCategorySourcesChoicesByTypesByName(
      String categoryName, String sourceName) async {
    Dio dio = await _loginProvider.getApiClient();
    Response response = await dio.get(apiUrl +
        "/feeds/sources/choices?categories=${Uri.encodeFull(categoryName)}&name=${Uri.encodeFull(sourceName)}");
    List<CategorySources> categoriesSources = [];
    for (var i in response.data["items"]) {
      CategorySources categorySources = CategorySources(
        i["_id"],
        i["type"],
        i["name"],
        i["data"],
        i["url"],
        i["categoryName"],
        i["categorySourcs"],
        i["icon"],
        i["self"],
      );
      categoriesSources.add(categorySources);
    }
    return categoriesSources;
  }

  Future<List<CategorySources>> getCategorySourcesSubscribedByTypesByName(
      String categoryName, String sourceName) async {
    Dio dio = await _loginProvider.getApiClient();
    Response response = await dio.get(apiUrl +
        "/feeds/sources/subscribed?categories=${Uri.encodeFull(categoryName)}&name=${Uri.encodeFull(sourceName)}");
    List<CategorySources> categoriesSources = [];
    for (var i in response.data["items"]) {
      CategorySources categorySources = CategorySources(
        i["_id"],
        i["type"],
        i["name"],
        i["data"],
        i["url"],
        i["categoryName"],
        i["categorySourcs"],
        i["icon"],
        i["self"],
      );
      categoriesSources.add(categorySources);
    }
    return categoriesSources;
  }

  Future<List<CategorySources>> getCategorySourcesSubscribedBySourceName(
      String sourceName) async {
    Dio dio = await _loginProvider.getApiClient();
    Response response = await dio.get(apiUrl +
        "/feeds/sources/subscribed?name=${Uri.encodeFull(sourceName)}");
    List<CategorySources> categoriesSources = [];
    for (var i in response.data["items"]) {
      CategorySources categorySources = CategorySources(
        i["_id"],
        i["type"],
        i["name"],
        i["data"],
        i["url"],
        i["categoryName"],
        i["categorySourcs"],
        i["icon"],
        i["self"],
      );
      categoriesSources.add(categorySources);
    }
    return categoriesSources;
  }

  Future<List<CategorySources>> getCategorySourcesSubscribedByTypes(
      String categoryName) async {
    String types = "";
    if (ShPrefs.instance.getStringValue('types') != null) {
      types += '${ShPrefs.instance.getStringValue('types')}';
    }
    Dio dio = await _loginProvider.getApiClient();
    List<CategorySources> categoriesSources = [];
    try {
      Response response = await dio.get(apiUrl +
          "/feeds/sources/subscribed?categories=${Uri.encodeFull(categoryName)}$types");
      for (var i in response.data["items"]) {
        CategorySources categorySources = CategorySources(
          i["_id"],
          i["type"],
          i["name"],
          i["data"],
          i["url"],
          i["categoryName"],
          i["categorySourcs"],
          i["icon"],
          i["self"],
        );
        categoriesSources.add(categorySources);
      }
    } on DioError catch (e) {
      print(e.response.statusCode);
    }
    return categoriesSources;
  }
}
