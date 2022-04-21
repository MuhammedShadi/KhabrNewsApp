import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khbr_app/model/category_item.dart';
import 'package:khbr_app/model/category_sources.dart';
import 'package:khbr_app/model/news_item.dart';
import 'package:khbr_app/providers/news_provider.dart';
import 'package:khbr_app/screens/news_details.dart';
import 'package:khbr_app/screens/search_screen.dart';
import 'package:khbr_app/screens/subscribed_categories.dart';
import 'package:khbr_app/widgets/app_drawer.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:khbr_app/providers/sh_prefs.dart';

NewsProvider _newsProvider = new NewsProvider();
List<String> isRemoved = [];
var categorySelected = '';
final sortOnSelected = TextEditingController();
bool isSwitched = false;

class IndexScreen extends StatefulWidget {
  static const routName = '/index';
  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  PaginationViewType paginationViewType;
  GlobalKey<PaginationViewState> key;
  ScrollController _scrollController = ScrollController();
  List newValues;
  List myList;

  bool themeSwitched = false;

  dynamic themeColor() {
    if (themeSwitched) {
      return Colors.grey[850];
    } else {}
  }

  Widget chooseSearchBar = Center(
    child: Text(
      "الرئيسية",
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

  _setDefaultData() async {
    ShPrefs.instance.setStringValue("page", "1");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor(),
        elevation: 0,
        brightness: themeSwitched ? Brightness.light : Brightness.dark,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            chooseSearchBar,
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => SearchScreen(),
                        ),
                      );
                    });
                  },
                ),
              ],
            ),
          ],
        ),
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
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
          child: FloatingActionButton.extended(
              backgroundColor: themeColor(),
              onPressed: null,
              label: Row(
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.home,
                        size: 30,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        ShPrefs.instance.setStringValue("page", "1");
                        Navigator.of(context).pushReplacementNamed("/index");
                        onTabCategory(ShPrefs.instance
                            .getStringValue('categorySelected'));
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.category,
                        size: 30,
                      ),
                      onPressed: () {
                        //categories
                        Navigator.of(context)
                            .pushReplacementNamed("/categories");
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.favorite,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed("/subcribedcategories");
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.search,
                        size: 30,
                      ),
                      onPressed: () {
                        _openPopup(context);
                      }),
                ],
              )),
        ),
      ),
      endDrawer: AppDrawer(),
    );
  }

  Widget indexWidget() {
    return Container(
      color: themeColor(),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // color: Colors.black12,
      child: FutureBuilder(
          future: categoryProvider.getCategorySubscribed(),
          builder:
              (BuildContext context, AsyncSnapshot<List<CateItems>> snapshot) {
            if (snapshot.data == null || snapshot.data.isEmpty) {
              return Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 80),
                  child: Row(
                    children: <Widget>[
                      Center(
                        child: Row(
                          children: <Widget>[
                            CircularProgressIndicator(),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Center(
                        child: Text(
                          "... من فضلك إنتظر يتم التحميل",
                          style: TextStyle(
                            fontFamily: 'Jazeera',
                            fontSize: 15,
                            color: themeSwitched ? Colors.white : Colors.indigo,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              if (categorySelected == '') {
                _setDefaultData();
                categorySelected = snapshot.data[0].name;
                //save in shared
                setCat(categorySelected);
              } else {
                setCat(categorySelected);
              }
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 55,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            if (snapshot.hasData) {
                              return drawCategorybyName(
                                  snapshot.data[index].name);
                            } else {
                              return Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 80),
                                  child: Row(
                                    children: <Widget>[
                                      Center(
                                        child: Row(
                                          children: <Widget>[
                                            // CircularProgressIndicator(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          }),
                    ),
                    Container(
                      child: getCategoryDataSelected(categorySelected),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }

  Future<List<CateItems>> pageFetchGetCategorySubscribed(int offset) async {
    page++;
    final List<CateItems> nextDiscList =
        await categoryProvider.getCategorySubscribedP(pageNum: page);
    await Future<List<CateItems>>.delayed(Duration(milliseconds: 30));
    var maxPage = 0;
    String maxPageS =
        await ShPrefs.instance.getStringValue('categorySubscribedPages');
    if (maxPageS != "") {
      maxPage = int.parse(maxPageS);
    }
    return page == maxPage + 1 ? [] : nextDiscList;
  }

  Future<List<CateItems>> pageRefreshGetCategorySubscribed(int offset) async {
    page = 0;
    return pageFetchGetCategorySubscribed(offset);
  }

  Widget drawCategorybyName(String cateName) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              new InkWell(
                onTap: () async {
                  setState(() {
                    Navigator.of(context).pushReplacementNamed("/index");
                  });
                  onTabCategory(cateName);
                  ShPrefs.instance.setStringValue("page", "1");
                },
                child: new Center(
                  child: new Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color:
                              themeSwitched ? Colors.white24 : Colors.indigo),
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    margin: new EdgeInsets.only(left: 10.0),
                    child: new Material(
                      elevation: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      child: Container(
                        color: themeColor(),
                        padding: new EdgeInsets.only(
                            left: 12.0, top: 7.0, bottom: 7.0, right: 12.0),
                        child: new Text(
                          cateName,
                          style: new TextStyle(
                            color: categorySelected == cateName
                                ? Colors.red
                                : themeSwitched
                                    ? Colors.white
                                    : Colors.indigo,
                            fontFamily: 'Jazeera',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getCategoryDataSelected(categorySelected) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      clipBehavior: Clip.hardEdge,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
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
                                  disc.getNewsImage(),
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
          pageFetch: pageFetchGetNewsDataByCategory,
          pageRefresh: pageRefreshGetNewsDataByCategory,
          pullToRefresh: true,
          onError: (dynamic error) => Center(
            child: Text(
              'حدث خطأً أثناء العرض ',
              style: TextStyle(fontFamily: 'Jazeera', color: Colors.red),
            ),
          ),
          onEmpty: Row(
            children: [
              SizedBox(
                width: 130,
              ),
              Icon(
                Icons.hourglass_empty,
                color: Colors.red,
              ),
              Text(
                'لا توجد أخبار حالياً',
                style: TextStyle(fontFamily: 'Jazeera', color: Colors.red),
              ),
            ],
          ),
          // bottomLoader: Center(
          //   child: CircularProgressIndicator(),
          // ),
          // initialLoader: Center(
          //   child: CircularProgressIndicator(),
          // ),
        ),
      ),
    );
  }

  Future<List<NewsItem>> pageFetchGetNewsDataByCategory(int offset) async {
    page++;
    final List<NewsItem> nextDiscList = await _newsProvider
        .getNewsDataByCategoryP(categorySelected, pageNum: page);
    await Future<List<NewsItem>>.delayed(Duration(milliseconds: 30));
    var maxPage = 0;
    String maxPageS = await ShPrefs.instance.getStringValue('indexNewPages');
    if (maxPageS != "") {
      maxPage = int.parse(maxPageS);
    }
    return page == maxPage + 1 ? [] : nextDiscList;
  }

  Future<List<NewsItem>> pageRefreshGetNewsDataByCategory(int offset) async {
    page = 0;
    return pageFetchGetNewsDataByCategory(offset);
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

  _openPopup(context) async {
    // JsonCodec codec = new JsonCodec();
    List<CategorySources> sourceName =
        await categoryProvider.getCategorySourcesSubscribedByTypes(
            await ShPrefs.instance.getStringValue('categorySelected'));
    List sourceOptions = List.generate(
        sourceName.length,
        (index) => {
              "display": sourceName[index].name,
              "value": sourceName[index].name
            });
    List _selectedIndexes = [];

    List _selectedSources = [];

    List _selectedSort = [];

    List _selectedPerPage = [];

    String indexParam = "";
    String sourcesParam = "";
    String sortParam = "";
    String perPageParam = "";
    saveValues() {
      for (int i = 0; i < _selectedIndexes.length; i++) {
        indexParam +=
            "&indexes=${Uri.encodeFull(_selectedIndexes[i].toString())}";
      }
      for (int i = 0; i < _selectedSources.length; i++) {
        sourcesParam +=
            "&sources=${Uri.encodeFull(_selectedSources[i].toString())}";
      }
      for (int i = 0; i < _selectedSort.length; i++) {
        sortParam += "&sort_on=${Uri.encodeFull(_selectedSort[i].toString())}";
      }
      for (int i = 0; i < _selectedPerPage.length; i++) {
        perPageParam +=
            "&per_page=${Uri.encodeFull(_selectedPerPage[i].toString())}";
      }
      ShPrefs.instance.setStringValue('indexes', indexParam);
      ShPrefs.instance.setStringValue('sources', sourcesParam);
      ShPrefs.instance.setStringValue("selectsort", sortParam);
      ShPrefs.instance.setStringValue("perpage", perPageParam);
      ShPrefs.instance.setStringValue("page", "1");
    }

    bool _turnUnread =
        (await ShPrefs.instance.getStringValue("show_unread") != null ||
                await ShPrefs.instance.getStringValue("show_unread") != "")
            ? toBoolean(await ShPrefs.instance.getStringValue("show_unread"))
            : true;

    DateTime _startDate = DateTime.now().subtract(Duration(days: 1));
    DateTime _endDate = DateTime.now();
    _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: _startDate, // Refer step 1
          firstDate: new DateTime(_endDate.year, _endDate.month - 3,
              _endDate.day, _endDate.hour, _endDate.minute),
          lastDate: new DateTime(_endDate.year, _endDate.month,
              _endDate.day + 1, _endDate.hour, _endDate.minute));
      // compileDateTime();
      if (picked != null && picked != _startDate)
        setState(() {
          _startDate = picked;
        });
    }

    _selectEndDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _endDate, // Refer step 1
        firstDate: new DateTime(_endDate.year, _endDate.month - 3, _endDate.day,
            _endDate.hour, _endDate.minute),
        lastDate: new DateTime(_endDate.year, _endDate.month, _endDate.day + 1,
            _endDate.hour, _endDate.minute),
      );
      // compileDateTime();
      if (picked != null && picked != _endDate)
        setState(() {
          _endDate = picked;
        });
    }

    List<Map<String, String>> indexOptions = [
      {
        "display": "فيس بوك",
        "value": "facebook-posts",
      },
      {
        "display": "تويتر",
        "value": "twitter-tweets",
      },
      {
        "display": "rss قارئ",
        "value": "rss",
      },
      {
        "display": "قناة التليجرام",
        "value": "telegram-channel",
      },
      {
        "display": "قارئ المواقع العام",
        "value": "generic-spiders",
      }
    ];

    List<Map<String, String>> sortOptions = [
      {
        "display": "التاريخ",
        "value": "date",
      },
      {
        "display": "الأكثر مشاهدة",
        "value": "most-viewed",
      },
    ];

    // List<Map<String, String>> perPageOptions = [
    //   {
    //     "display": "عرض 1",
    //     "value": "1",
    //   },
    //   {
    //     "display": "عرض 2",
    //     "value": "2",
    //   },
    //   {
    //     "display": "عرض 3",
    //     "value": "3",
    //   },
    //   {
    //     "display": "عرض 5",
    //     "value": "5",
    //   },
    //   {
    //     "display": "عرض 10",
    //     "value": "10",
    //   },
    //   {
    //     "display": "عرض 20",
    //     "value": "20",
    //   },
    //   {
    //     "display": "عرض 30",
    //     "value": "30",
    //   },
    //   {
    //     "display": "عرض 40",
    //     "value": "40",
    //   },
    //   {
    //     "display": "عرض 50",
    //     "value": "50",
    //   },
    //   {
    //     "display": "عرض 100",
    //     "value": "100",
    //   },
    //   {
    //     "display": "عرض 200",
    //     "value": "200",
    //   },
    //   {
    //     "display": "عرض 500",
    //     "value": "500",
    //   },
    // ];

    removeFilterParameters() {
      ShPrefs.instance.removeValue('sources');
      ShPrefs.instance.removeValue("show_unread");
      ShPrefs.instance.removeValue("startDate");
      ShPrefs.instance.removeValue("endDate");
      ShPrefs.instance.removeValue("indexes");
      ShPrefs.instance.removeValue("selectsort");
      ShPrefs.instance.removeValue("perpage");
      ShPrefs.instance.setStringValue("page", "1");
    }

    setFilterParameters() {
      ShPrefs.instance.setStringValue("perpage", perPageParam);
      ShPrefs.instance.setStringValue("selectsort", sortParam);
      ShPrefs.instance.setStringValue("indexes", indexParam);
      ShPrefs.instance.setStringValue("sources", sourcesParam);
      ShPrefs.instance.setStringValue("show_unread", _turnUnread.toString());
      ShPrefs.instance.setStringValue("startDate",
          DateFormat('yyyy-MM-dd hh:mm').format(_startDate).toString());
      ShPrefs.instance.setStringValue("endDate",
          DateFormat('yyyy-MM-dd hh:mm').format(_endDate).toString());
      ShPrefs.instance.setStringValue("page", "1");
    }

    Alert(
        context: context,
        title: "بحث",
        style: AlertStyle(
          titleStyle: TextStyle(
            color: Colors.indigo,
            fontFamily: 'Jazeera',
            fontSize: 20,
          ),
        ),
        content: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      child: MultiSelectFormField(
                        autovalidate: false,
                        chipBackGroundColor: Colors.indigo,
                        chipLabelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Jazeera',
                            color: Colors.white),
                        dialogTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Jazeera',
                            color: Colors.indigo),
                        checkBoxActiveColor: Colors.indigo,
                        checkBoxCheckColor: Colors.white,
                        dialogShapeBorder: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0))),
                        title: Center(
                          child: Text(
                            "نوع المصدر",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Jazeera',
                                color: Colors.indigo),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.length == 0) {
                            return 'Please select one or more options';
                          }
                          return null;
                        },
                        dataSource: indexOptions,
                        textField: 'display',
                        valueField: 'value',
                        okButtonLabel: 'حفظ',
                        cancelButtonLabel: 'إلغاء',
                        hintWidget: Center(
                          child: Text('قم بإختيار مصدر للبحث',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Jazeera',
                                  color: Colors.indigo)),
                        ),
                        initialValue: _selectedIndexes,
                        onSaved: (value) {
                          if (value == null) return;
                          setState(() {
                            _selectedIndexes = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                      child: MultiSelectFormField(
                        autovalidate: false,
                        chipBackGroundColor: Colors.indigo,
                        chipLabelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Jazeera',
                            color: Colors.white),
                        dialogTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Jazeera',
                            color: Colors.indigo),
                        checkBoxActiveColor: Colors.indigo,
                        checkBoxCheckColor: Colors.white,
                        dialogShapeBorder: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0))),
                        title: Center(
                          child: Text(
                            "المصادر",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Jazeera',
                                color: Colors.indigo),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.length == 0) {
                            return 'Please select one or more options';
                          }
                          return null;
                        },
                        dataSource: sourceOptions,
                        textField: 'display',
                        valueField: 'value',
                        okButtonLabel: 'حفظ',
                        cancelButtonLabel: 'إلغاء',
                        hintWidget: Center(
                          child: Text('حدد عنصر او أكثر للبحث',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Jazeera',
                                  color: Colors.indigo)),
                        ),
                        initialValue: _selectedSources,
                        onSaved: (value) {
                          if (value == null) return;
                          setState(() {
                            _selectedSources = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                      child: MultiSelectFormField(
                        autovalidate: false,
                        chipBackGroundColor: Colors.indigo,
                        chipLabelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Jazeera',
                            color: Colors.white),
                        dialogTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Jazeera',
                            color: Colors.indigo),
                        checkBoxActiveColor: Colors.indigo,
                        checkBoxCheckColor: Colors.white,
                        dialogShapeBorder: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0))),
                        title: Center(
                          child: Text(
                            "ترتيب حسب",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Jazeera',
                                color: Colors.indigo),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.length == 0) {
                            return 'Please select one or more options';
                          }
                          return null;
                        },
                        dataSource: sortOptions,
                        textField: 'display',
                        valueField: 'value',
                        okButtonLabel: 'حفظ',
                        cancelButtonLabel: 'إلغاء',
                        hintWidget: Center(
                          child: Text('قم بتحديد الترتيب حسب',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Jazeera',
                                  color: Colors.indigo)),
                        ),
                        initialValue: _selectedSort,
                        onSaved: (value) {
                          if (value == null) return;
                          setState(() {
                            _selectedSort = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                // Column(
                //   children: <Widget>[
                //     Container(
                //       child: MultiSelectFormField(
                //         autovalidate: false,
                //         chipBackGroundColor: Colors.indigo,
                //         chipLabelStyle: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             fontFamily: 'Jazeera',
                //             color: Colors.white),
                //         dialogTextStyle: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             fontFamily: 'Jazeera',
                //             color: Colors.indigo),
                //         checkBoxActiveColor: Colors.indigo,
                //         checkBoxCheckColor: Colors.white,
                //         dialogShapeBorder: RoundedRectangleBorder(
                //             borderRadius:
                //                 BorderRadius.all(Radius.circular(12.0))),
                //         title: Center(
                //           child: Text(
                //             "عدد الأخبار",
                //             style: TextStyle(
                //                 fontSize: 14,
                //                 fontWeight: FontWeight.bold,
                //                 fontFamily: 'Jazeera',
                //                 color: Colors.indigo),
                //           ),
                //         ),
                //         validator: (value) {
                //           if (value == null || value.length == 0) {
                //             return 'Please select one or more options';
                //           }
                //           return null;
                //         },
                //         dataSource: perPageOptions,
                //         textField: 'display',
                //         valueField: 'value',
                //         okButtonLabel: 'حفظ',
                //         cancelButtonLabel: 'إلغاء',
                //         hintWidget: Center(
                //           child: Text('قم بتحديد  عدد الأخبار للعرض',
                //               style: TextStyle(
                //                   fontSize: 13,
                //                   fontFamily: 'Jazeera',
                //                   color: Colors.indigo)),
                //         ),
                //         initialValue: _selectedPerPage,
                //         onSaved: (value) {
                //           if (value == null) return;
                //           setState(() {
                //             _selectedPerPage = value;
                //
                //           });
                //         },
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 35,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: new MaterialButton(
                            color: Colors.indigo,
                            onPressed: () async {
                              await _selectDate(context);
                              await _selectEndDate(context);
                              // await _selectTime(context);
                            },
                            child: new Text("حدد تاريخ",
                                style: TextStyle(
                                    fontFamily: 'Jazeera',
                                    color: Colors.white,
                                    fontSize: 10))),
                      ),
                    ),
                    SizedBox(width: 25.0),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: 35,
                      child: LiteRollingSwitch(
                        value: _turnUnread,
                        textOn: 'تفعيل',
                        textOff: 'إيقاف',
                        colorOn: Colors.indigo,
                        colorOff: Colors.blueGrey,
                        iconOn: Icons.lightbulb_outline,
                        iconOff: Icons.power_settings_new,
                        onChanged: (bool state) {
                          _turnUnread = state;
                        },
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      "إظهار الغير مقروء فقط",
                      style: TextStyle(
                          fontFamily: 'Jazeera',
                          color: Colors.indigo,
                          fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        buttons: [
          //
          DialogButton(
            color: Colors.red,
            onPressed: () {
              setState(() {
                removeFilterParameters();
                Navigator.pop(context);
                IndexScreen();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/index', (Route<dynamic> route) => false);
              });
            },
            child: Text(
              "إعادة تعيين",
              style: TextStyle(
                  fontFamily: 'Jazeera', color: Colors.white, fontSize: 12),
            ),
          ),
          //
          DialogButton(
            color: Colors.green,
            onPressed: () {
              setState(() {
                saveValues();
                removeFilterParameters();
                setFilterParameters();
                Navigator.pop(context);
                IndexScreen();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/index', (Route<dynamic> route) => false);
              });
            },
            child: Text(
              "تطبيق و بحث",
              style: TextStyle(
                  fontFamily: 'Jazeera', color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
          //
          DialogButton(
            color: Colors.blueAccent,
            onPressed: () {
              setState(() {
                saveValues();
                removeFilterParameters();
                setFilterParameters();
                Navigator.pop(context);
                IndexScreen();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/index', (Route<dynamic> route) => false);
              });
            },
            child: Text(
              "تطبيق",
              style: TextStyle(
                  fontFamily: 'Jazeera', color: Colors.white, fontSize: 15),
            ),
          ),
        ]).show();
  }

  setCat(String catName) async {
    ShPrefs.instance.setStringValue('categorySelected', catName);
  }
}
