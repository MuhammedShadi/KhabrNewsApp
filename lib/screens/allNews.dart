import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:khbr_app/model/news_item.dart';
import 'package:khbr_app/providers/news_provider.dart';
import 'package:khbr_app/screens/news_details.dart';
import 'package:khbr_app/widgets/app_drawer.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:khbr_app/providers/sh_prefs.dart';

NewsProvider _newsProvider = new NewsProvider();
List<String> isRemoved = [];
var categorySelected = '';
final sortOnSelected = TextEditingController();
bool isSwitched = false;

class AllNewsData extends StatefulWidget {
  static const routName = '/allnews';
  @override
  _AllNewsDataState createState() => _AllNewsDataState();
}

class _AllNewsDataState extends State<AllNewsData> {
  ScrollController _scrollController = ScrollController();
  List newValues;

  int page;
  PaginationViewType paginationViewType;
  GlobalKey<PaginationViewState> key;
  List<String> isChecked = [];

  bool themeSwitched = false;

  dynamic themeColor() {
    if (themeSwitched) {
      return Colors.grey[850];
    } else {}
  }

  Widget chooseSearchBar = Center(
    child: Text(
      "جميع الأخبار",
      style: TextStyle(fontFamily: 'Jazeera'),
    ),
  );

  @override
  void initState() {
    page = 0;
    paginationViewType = PaginationViewType.listView;
    key = GlobalKey<PaginationViewState>();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor(),
        elevation: 0,
        brightness: themeSwitched ? Brightness.light : Brightness.dark,
        title: chooseSearchBar,
        leading: IconButton(
          icon: themeSwitched
              ? Icon(Icons.wb_sunny,
                  color: themeSwitched ? Colors.white : Colors.black)
              : Icon(
                  Icons.brightness_3,
                  color: themeSwitched ? Colors.white : Colors.black,
                ),
          onPressed: () {
            setState(() {
              themeSwitched = !themeSwitched;
            });
          },
        ),
      ),
      body: indexWidget(),
      endDrawer: AppDrawer(),
    );
  }

  Widget indexWidget() {
    return Container(
      color: themeColor(),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // color: Colors.black12,
      child: getAllNewsData(),
    );
  }

  onTabCategory(index) async {
    setState(() {
      categorySelected = index;
      ShPrefs.instance.setStringValue('categorySelected', categorySelected);
    });
  }

  bool toBoolean(String str, [bool strict]) {
    if (strict == true) {
      return str == '1' || str == 'true';
    }
    return str != '0' && str != 'false' && str != '';
  }

  setCat(String catName) async {
    ShPrefs.instance.setStringValue('categorySelected', catName);
  }

  Future<List<NewsItem>> pageFetch(int offset) async {
    print('aaa');
    page++;
    print(page);
    final List<NewsItem> nextDiscList =
        await _newsProvider.getAllNewsData(pageNum: page);
    await Future<List<NewsItem>>.delayed(Duration(milliseconds: 30));
    var maxPage = 0;
    String maxPageS = await ShPrefs.instance.getStringValue('allNewPages');
    if (maxPageS != "") {
      maxPage = int.parse(maxPageS);
    }
    return page == maxPage + 1 ? [] : nextDiscList;
  }

  Future<List<NewsItem>> pageRefresh(int offset) async {
    page = 0;
    return pageFetch(offset);
  }

  Widget getAllNewsData() {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      clipBehavior: Clip.hardEdge,
      child: Container(
        color: themeColor(),
        child: PaginationView<NewsItem>(
          key: key,
          paginationViewType: paginationViewType,
          itemBuilder: (BuildContext context, NewsItem disc, int index) =>
              ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            clipBehavior: Clip.hardEdge,
            child: Container(
              color: Colors.black12,
              child: Container(
                child: InkWell(
                  onTap: () async {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => NewsScreenDetails(disc)),
                    );
                    _newsProvider.getNewsViews(disc.universalIdentifier);
                    setState(() {
                      isRemoved.remove(disc.universalIdentifier);
                    });
                  },
                  child: ClipRRect(
                    child: Card(
                      color: themeColor(),
                      margin: const EdgeInsets.only(
                          left: 5.0, right: 5.0, bottom: 10.0, top: 0.0),
                      elevation: 4.0,
                      child: Row(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              ClipRRect(
                                child: Image.network(
                                  disc.getAllNewsUserImage(),
                                  width: 83.0,
                                  height: 83.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              Positioned(
                                left: 0.0,
                                bottom: 0.0,
                                child: Material(
                                  // eye button (customised radius)
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(50.0),
                                  ),
                                  color: Colors.white,

                                  child: InkWell(
                                    splashColor: Colors.white,
                                    // inkwell onPress colour
                                    child: SizedBox(
                                      width: 18,
                                      height: 18,
                                      //customisable size of 'button'
                                      child: disc.getNewsIcon(),
                                    ),
                                    onTap: () {}, // or use onPressed: () {}
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          child: Text(
                                            disc.getAllNewsUserTitle(),
                                            style: new TextStyle(
                                              color: themeSwitched
                                                  ? Colors.white
                                                  : Colors.indigo,
                                              fontFamily: 'Jazeera',
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: disc.getNewsTextAlign(),
                                            textDirection:
                                                disc.getNewsTextDirection(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.date_range,
                                      color: themeSwitched
                                          ? Colors.white
                                          : Colors.indigo,
                                      size: 10,
                                    ),
                                    Text(
                                      disc.getNewsDate(),
                                      style: new TextStyle(
                                        color: themeSwitched
                                            ? Colors.white
                                            : Colors.indigo,
                                        fontFamily: 'Jazeera',
                                        fontSize: 10,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.access_time,
                                      color: themeSwitched
                                          ? Colors.white
                                          : Colors.indigo,
                                      size: 10,
                                    ),
                                    Text(
                                      disc.getNewsTime(),
                                      style: new TextStyle(
                                        color: themeSwitched
                                            ? Colors.white
                                            : Colors.indigo,
                                        fontFamily: 'Jazeera',
                                        fontSize: 10,
                                      ),
                                    ),
                                    SizedBox(width: 60),
                                    InkWell(
                                      child: Text(
                                        disc.getAllNewsUserName(),
                                        style: new TextStyle(
                                          color: themeSwitched
                                              ? Colors.white
                                              : Colors.indigo,
                                          fontFamily: 'Jazeera',
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      onTap: () async {
                                        if (await canLaunch(disc.url)) {
                                          await launch(disc.url);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          pageFetch: pageFetch,
          pageRefresh: pageRefresh,
          pullToRefresh: true,
          onError: (dynamic error) => Center(
            child: Text('Some error occured'),
          ),
          onEmpty: Center(
            heightFactor: 20,
            child: Text(
              'حدث خطأ ما...!',
              style: TextStyle(fontFamily: 'Jazeera'),
            ),
          ),
          bottomLoader: Center(
            child: CircularProgressIndicator(),
          ),
          initialLoader: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
