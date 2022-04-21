import 'package:dio/dio.dart';
import 'package:khbr_app/model/news_item.dart';
import 'package:khbr_app/providers/login_provider.dart';
import 'package:khbr_app/providers/sh_prefs.dart';

var apiUrl = "https://dev.arapi.host";
LoginProvider _loginProvider = new LoginProvider();

class NewsProvider {
  Future<List<NewsItem>> getNewsDataByCategory(String categoryName) async {
    bool unreadEntries =
        toBoolean(await ShPrefs.instance.getStringValue("show_unread"));
    String startDate = await ShPrefs.instance.getStringValue("startDate");
    String endDate = await ShPrefs.instance.getStringValue("endDate");
    String selectedIndexes = await ShPrefs.instance.getStringValue("indexes");
    String selectedsort = await ShPrefs.instance.getStringValue("selectsort");
    String selectedSources = await ShPrefs.instance.getStringValue("sources");
    String selectedPerPage = await ShPrefs.instance.getStringValue("perpage");
    String selectedPage = await ShPrefs.instance.getStringValue("page");
    Dio dio = await _loginProvider.getApiClient();
    String filterParam = "";
    if (selectedsort != null) {
      //
      filterParam += "$selectedsort";
    }
    if (startDate != null && startDate != '') {
      filterParam += "&from_date=${Uri.encodeFull(startDate)}";
    }
    if (startDate == '') {
      filterParam += "";
    }
    if (endDate != null && endDate != '') {
      filterParam += "&to_date=${Uri.encodeFull(endDate)}";
    }
    if (endDate == '') {
      filterParam += "";
    }
    if (selectedIndexes != null) {
      filterParam += "$selectedIndexes";
    }
    if (selectedSources != null) {
      filterParam += "$selectedSources";
    }
    if (selectedPerPage != null) {
      filterParam += "$selectedPerPage";
    }
    if (selectedPerPage == null || selectedPerPage.isEmpty) {
      filterParam += "&per_page=10";
    }
    if (selectedPage != null || selectedPage.isNotEmpty) {
      filterParam += "&page=${await ShPrefs.instance.getStringValue('page')}";
    }
    Response response = await dio.get(apiUrl +
        "/feeds/data?categories=${Uri.encodeFull(categoryName)}&show_unread_entries_only=$unreadEntries&$filterParam&normalize=true");
    List<NewsItem> newsItems = [];
    for (var i in response.data["items"]) {
      NewsItem newsItem = new NewsItem(
        i["title"],
        i["user"],
        i["text"],
        i["date"],
        i["url"],
        i["media"],
        i["index"],
        i["self"],
        i["universal_identifier"],
        i["language"],
        i["username"],
        i["profile_image_url_https"],
        i["top_img"],
      );
      newsItems.add(newsItem);
    }
    return newsItems;
  }

  Future<List<NewsItem>> getNewsDataByCategoryP(String categoryName,
      {int pageNum = 1}) async {
    bool unreadEntries =
        toBoolean(await ShPrefs.instance.getStringValue("show_unread"));
    String startDate = await ShPrefs.instance.getStringValue("startDate");
    String endDate = await ShPrefs.instance.getStringValue("endDate");
    String selectedIndexes = await ShPrefs.instance.getStringValue("indexes");
    String selectedsort = await ShPrefs.instance.getStringValue("selectsort");
    String selectedSources = await ShPrefs.instance.getStringValue("sources");
    String selectedPerPage = await ShPrefs.instance.getStringValue("perpage");
    // String selectedPage = await ShPrefs.instance.getStringValue("page");
    Dio dio = await _loginProvider.getApiClient();
    String filterParam = "";
    if (selectedsort != null) {
      //
      filterParam += "$selectedsort";
    }
    if (startDate != null && startDate != '') {
      filterParam += "&from_date=${Uri.encodeFull(startDate)}";
    }
    if (startDate == '') {
      filterParam += "";
    }
    if (endDate != null && endDate != '') {
      filterParam += "&to_date=${Uri.encodeFull(endDate)}";
    }
    if (endDate == '') {
      filterParam += "";
    }
    if (selectedIndexes != null) {
      filterParam += "$selectedIndexes";
    }
    if (selectedSources != null) {
      filterParam += "$selectedSources";
    }
    if (selectedPerPage != null) {
      filterParam += "$selectedPerPage";
    }
    List<NewsItem> newsItems = [];
    int maxPages = pageNum;
    String maxPageS = await ShPrefs.instance.getStringValue('indexNewPages');
    if (maxPageS != "") {
      maxPages = int.parse(maxPageS);
    }

    Response response = await dio.get(apiUrl +
        "/feeds/data?categories=${Uri.encodeFull(categoryName)}&show_unread_entries_only=$unreadEntries$filterParam&normalize=true&page=$pageNum&per_page=10");

    ShPrefs.instance
        .setStringValue('indexNewPages', response.data['pages'].toString());
    if (pageNum <= maxPages) {
      for (var i in response.data["items"]) {
        NewsItem newsItem = new NewsItem(
          i["title"],
          i["user"],
          i["text"],
          i["date"],
          i["url"],
          i["media"],
          i["index"],
          i["self"],
          i["universal_identifier"],
          i["language"],
          i["username"],
          i["profile_image_url_https"],
          i["top_img"],
        );
        newsItems.add(newsItem);
      }
    }
    return newsItems;
  }

  Future<List<NewsItem>> getAllNewsData({int pageNum = 1}) async {
    int maxPages = pageNum;
    String maxPageS = await ShPrefs.instance.getStringValue('allNewPages');
    List<NewsItem> newsItems = [];
    if (maxPageS != "") {
      maxPages = int.parse(maxPageS);
    }
    if (pageNum <= maxPages) {
      Dio dio = await _loginProvider.getApiClient();
      Response response = await dio.get(apiUrl +
          "/feeds/data?normalize=false&sort_on=date&page=$pageNum&per_page=10");
      ShPrefs.instance
          .setStringValue('allNewPages', response.data['pages'].toString());
      for (var i in response.data["items"]) {
        NewsItem newsItem = new NewsItem(
          i["title"],
          i["user"],
          i["text"],
          i["date"],
          i["url"],
          i["media"],
          i["index"],
          i["self"],
          i["universal_identifier"],
          i["language"],
          i["username"],
          i["profile_image_url_https"],
          i["top_img"],
        );
        newsItems.add(newsItem);
      }
    }

    return newsItems;
  }

  Future<List<NewsItem>> getNewsDataBySourceBySearch(
      String sourceId, bool unreadEntries) async {
    Dio dio = await _loginProvider.getApiClient();
    Response response = await dio.get(apiUrl +
        "/feeds/data?sources=${Uri.encodeFull(sourceId)}&show_unread_entries_only=$unreadEntries&normalize=true&page=1&per_page=100");
    List<NewsItem> newsItems = [];
    for (var i in response.data["items"]) {
      NewsItem newsItem = NewsItem(
        i["title"],
        i["user"],
        i["text"],
        i["date"],
        i["url"],
        i["media"],
        i["index"],
        i["self"],
        i["universal_identifier"],
        i["language"],
        i["username"],
        i["profile_image_url_https"],
        i["top_img"],
      );
      if (response.statusCode == 200) {
        newsItems.add(newsItem);
      }
    }
    return newsItems;
  }

  Future<List<NewsItem>> getNewsDataBySourceP(bool unreadEntries,
      {int pageNum = 1}) async {
    int maxPages = pageNum;
    String maxPageS = await ShPrefs.instance.getStringValue('newsPagesNum');
    String sourceId = await ShPrefs.instance.getStringValue('sourceId');
    List<NewsItem> newsItems = [];
    if (maxPageS != "") {
      maxPages = int.parse(maxPageS);
    }
    if (pageNum <= maxPages) {
      Dio dio = await _loginProvider.getApiClient();
      Response response = await dio.get(apiUrl +
          "/feeds/data?sources=${Uri.encodeFull(sourceId)}&show_unread_entries_only=$unreadEntries&normalize=true&page=$pageNum&per_page=10");

      ShPrefs.instance
          .setStringValue('newsPagesNum', response.data['pages'].toString());
      for (var i in response.data["items"]) {
        NewsItem newsItem = NewsItem(
          i["title"],
          i["user"],
          i["text"],
          i["date"],
          i["url"],
          i["media"],
          i["index"],
          i["self"],
          i["universal_identifier"],
          i["language"],
          i["username"],
          i["profile_image_url_https"],
          i["top_img"],
        );
        if (response.statusCode == 200) {
          newsItems.add(newsItem);
        }
      }
    }

    return newsItems;
  }

  Future getNewsViews(String universalIdentifier) async {
    Dio dio = await _loginProvider.getApiClient();
    Response response = await dio
        .put(apiUrl + "/feeds/entries/$universalIdentifier/statistics/views");
    if (response.statusCode == 201) {
      return true;
    }
  }

  Future getNewsShares(String universalIdentifier) async {
    Dio dio = await _loginProvider.getApiClient();
    Response response = await dio
        .put(apiUrl + "/feeds/entries/$universalIdentifier/statistics/shares");
    if (response.statusCode == 200) {
      return true;
    }
  }

  bool toBoolean(String str, [bool strict]) {
    if (strict == true) {
      return str == '1' || str == 'true';
    }
    return str != '0' && str != 'false' && str != '';
  }
}
