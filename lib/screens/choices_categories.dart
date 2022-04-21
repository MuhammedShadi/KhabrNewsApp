import 'package:flutter/material.dart';
import 'package:khbr_app/model/category.dart';
import 'package:khbr_app/model/category_item.dart';
import 'package:khbr_app/model/category_sources.dart';
import 'package:khbr_app/providers/category_provider.dart';
import 'package:khbr_app/providers/login_provider.dart';
import 'package:khbr_app/widgets/app_drawer.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:khbr_app/providers/sh_prefs.dart';

String imageCat = 'assets/images/khbar.png';
String imageCatOff = 'assets/images/khbaroff.png';
CategoryProvider categoryProvider = new CategoryProvider();
ScrollController _scrollController = ScrollController();
int page;

class ChoicesCategories extends StatefulWidget {
  static const routName = "/categories";
  @override
  _ChoicesCategoriesState createState() => _ChoicesCategoriesState();
}

class _ChoicesCategoriesState extends State<ChoicesCategories> {
  PaginationViewType paginationViewType;
  GlobalKey<PaginationViewState> key;
  LoginProvider loginProvider = new LoginProvider();
  TextEditingController _searchController = TextEditingController();
  List<Category> categories;
  bool themeSwitched = false;
  bool isSearching = false;
  bool searchResult = false;
  Future resultLoaded;
  dynamic themeColor() {
    if (themeSwitched) {
      return Colors.grey[850];
    } else {}
  }

  @override
  void initState() {
    page = 0;
    paginationViewType = PaginationViewType.gridView;
    key = GlobalKey<PaginationViewState>();
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  _onSearchChanged() {
    setState(() {
      searchResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor(),
        elevation: 0,
        brightness: themeSwitched ? Brightness.light : Brightness.dark,
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: isSearching == true
                  ? Container(
                      width: 120,
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            icon: Icon(Icons.search, color: Colors.white),
                            hintText: "بحث التصنيفات",
                            hintStyle: TextStyle(color: Colors.white)),
                        cursorColor: Colors.white,
                        onChanged: (text) {
                          text = text.toLowerCase();
                        },
                      ),
                    )
                  : Text(
                      "التصنيفات",
                      style: TextStyle(fontFamily: 'Jazeera'),
                    ),
            ),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                isSearching == true
                    ? IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () {
                          setState(() {
                            isSearching = false;
                            searchResult = false;
                            _searchController.clear();
                            Navigator.of(context)
                                .pushReplacementNamed("/categories");
                          });
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            isSearching = true;
                          });
                        },
                      ),
              ],
            ),
            Row(
              children: [
                (paginationViewType == PaginationViewType.listView)
                    ? IconButton(
                        icon: Icon(Icons.grid_on),
                        onPressed: () => setState(() =>
                            paginationViewType = PaginationViewType.gridView),
                      )
                    : IconButton(
                        icon: Icon(Icons.list),
                        onPressed: () => setState(() =>
                            paginationViewType = PaginationViewType.listView),
                      ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () => key.currentState.refresh(),
                ),
              ],
            ),
          ],
        ),
      ),
      body: searchResult
          ? Container(
              color: themeColor(),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Container(
                  child: FutureBuilder(
                    future: categoryProvider
                        .getCategoryChoicesByName(_searchController.text),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<CateItems>> snapshot) {
                      if (snapshot.data == null) {
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
                                      color: themeSwitched
                                          ? Colors.white
                                          : Colors.indigo,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return GridView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 0,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => SearchChoicesSources(
                                        snapshot.data[index]),
                                  ),
                                );
                              },
                              child: Column(
                                children: <Widget>[
                                  Card(
                                    semanticContainer: true,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: themeSwitched
                                        ? Image.asset(
                                            imageCatOff,
                                            fit: BoxFit.fill,
                                            height: 130,
                                          )
                                        : Image.asset(
                                            imageCat,
                                            fit: BoxFit.fill,
                                            height: 130,
                                          ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 5,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .center, //Center Column contents vertically,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center, //Center Column contents horizontally,
                                    children: <Widget>[
                                      Icon(
                                        Icons.assignment,
                                        color: themeSwitched
                                            ? Colors.white
                                            : Colors.red,
                                        size: 20,
                                      ),
                                      SizedBox(width: 20),
                                      Text(
                                        snapshot.data[index].name,
                                        style: TextStyle(
                                          fontFamily: 'Jazeera',
                                          fontSize: 15,
                                          color: themeSwitched
                                              ? Colors.white
                                              : Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            )
          : getCategoriesChoicesNames(),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              boxShadow: [
                BoxShadow(
                  color: themeSwitched
                      ? Colors.white.withOpacity(0.5)
                      : Colors.white.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ]),
          child: FloatingActionButton.extended(
              backgroundColor: themeColor(),
              onPressed: null,
              label: Row(
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.home,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed("/index");
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.category,
                        size: 30,
                        color: Colors.red,
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
                ],
              )),
        ),
      ),
      endDrawer: AppDrawer(),
    );
  }

  Widget getCategoriesChoicesNames() {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      clipBehavior: Clip.hardEdge,
      child: Container(
        color: themeColor(),
        child: PaginationView<CateItems>(
          key: key,
          paginationViewType: paginationViewType,
          itemBuilder: (BuildContext context, CateItems disc, int index) =>
              (paginationViewType == PaginationViewType.listView)
                  ? InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) =>
                                getCategorySourcesChoices(disc.name),
                          ),
                        );
                      },
                      child: Card(
                        color: themeColor(),
                        margin: const EdgeInsets.only(
                            left: 5.0, right: 5.0, bottom: 10.0, top: 3.0),
                        elevation: 4.0,
                        child: Column(
                          children: [
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.rss_feed,
                                  size: 40,
                                  color: themeSwitched
                                      ? Colors.white
                                      : Colors.redAccent,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Row(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Container(
                                                child: Text(
                                                  disc.name,
                                                  style: new TextStyle(
                                                    color: themeSwitched
                                                        ? Colors.white
                                                        : Colors.indigo,
                                                    fontFamily: 'Jazeera',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.end,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: () async {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) =>
                                getCategorySourcesChoices(disc.name),
                          ),
                        );
                      },
                      child: Column(
                        children: <Widget>[
                          Card(
                            color: themeColor(),
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: themeSwitched
                                ? Image.asset(
                                    imageCatOff,
                                    fit: BoxFit.fill,
                                    height: 130,
                                  )
                                : Image.asset(
                                    imageCat,
                                    fit: BoxFit.fill,
                                    height: 130,
                                  ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 2,
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment
                                .center, //Center Column contents vertically,
                            crossAxisAlignment: CrossAxisAlignment
                                .center, //Center Column contents horizontally,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.category),
                                color:
                                    themeSwitched ? Colors.white : Colors.red,
                                onPressed: () {
                                  //Get News By categoryName
                                  // Navigator.push(
                                  //     context,
                                  //     new MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             getCategorySelectedByCategory(
                                  //                 disc.name)));
                                },
                              ),
                              Text(
                                disc.name,
                                style: TextStyle(
                                  fontFamily: 'Jazeera',
                                  fontSize: 15,
                                  color:
                                      themeSwitched ? Colors.white : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
          pageFetch: pageFetch,
          pageRefresh: pageRefresh,
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

  Widget getCategorySourcesChoices(String categoryName) {
    List<String> isChecked = [];
    bool themeSwitched = false;
    bool searchResult = false;
    TextEditingController _searchControllerSource = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor(),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("/categories");
            }),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                categoryName,
                style: TextStyle(fontFamily: 'Jazeera'),
              ),
            ),
          ],
        ),
      ),
      body: searchResult == true
          ? Container(
              color: themeColor(),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Container(
                  child: FutureBuilder(
                    future: categoryProvider.getCategorySourcesChoicesByTypes(
                        categoryName, _searchControllerSource.text),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<CategorySources>> snapshot) {
                      if (snapshot.data == null) {
                        return Container(
                          child: Center(
                            child: Text(
                              "... من فضلك إنتظر يتم التحميل",
                              style: TextStyle(
                                fontFamily: 'Jazeera',
                                fontSize: 15,
                                color: themeSwitched
                                    ? Colors.white
                                    : Colors.indigo,
                              ),
                            ),
                          ),
                        );
                      } else if (snapshot.data.isEmpty) {
                        return Container(
                          child: Center(
                            child: Text(
                              "... لا توجد مفضلات حالياً ",
                              style: TextStyle(
                                fontFamily: 'Jazeera',
                                fontSize: 15,
                                color: themeSwitched
                                    ? Colors.white
                                    : Colors.indigo,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          controller: _scrollController,
                          //shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              color: themeColor(),
                              //color: Colors.redAccent.shade100,
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    leading:
                                        snapshot.data[index].getNewsImage(),
                                    title: Center(
                                      child: Text(
                                        snapshot.data[index].name.toUpperCase(),
                                        style: TextStyle(
                                          fontFamily: 'Jazeera',
                                          fontSize: 15,
                                          color: themeSwitched
                                              ? Colors.white
                                              : Colors.indigo,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                      color: themeSwitched
                                          ? Colors.white
                                          : Colors.red,
                                      onPressed: () {
                                        setState(() {
                                          isChecked.remove(snapshot
                                              .data[index].name
                                              .toUpperCase());
                                          categoryProvider.unsubscribeSource(
                                              snapshot.data[index].id,
                                              snapshot.data[index].name
                                                  .toUpperCase());
                                        });
                                      },
                                    ),
                                    onTap: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         getCategorySelectedBySource(
                                      //             snapshot.data[index].name,
                                      //             snapshot.data[index].id),
                                      //   ),
                                      // );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            )
          : Container(
              color: themeColor(),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder(
                future: categoryProvider.getCategorySourcesChoicesByTypes(
                    categoryName, 'types'),
                builder: (BuildContext context,
                    AsyncSnapshot<List<CategorySources>> snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 80, top: 200),
                        child: Center(
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
                                    color: themeSwitched
                                        ? Colors.red
                                        : Colors.indigo,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.data.isEmpty) {
                    return Container(
                      child: Center(
                        child: Text(
                          "... لا توجد مفضلات حالياً في قائمة $categoryName ",
                          style: TextStyle(
                            fontFamily: 'Jazeera',
                            fontSize: 15,
                            color: themeSwitched ? Colors.white : Colors.indigo,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      controller: _scrollController,
                      //shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          color: themeColor(),
                          //color: Colors.redAccent.shade100,
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                leading: snapshot.data[index].getNewsImage(),
                                title: Center(
                                  child: Text(
                                    snapshot.data[index].name.toUpperCase(),
                                    style: TextStyle(
                                      fontFamily: 'Jazeera',
                                      fontSize: 15,
                                      color: themeSwitched
                                          ? Colors.white
                                          : Colors.indigo,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.favorite_border),
                                  color:
                                      themeSwitched ? Colors.white : Colors.red,
                                  onPressed: () {
                                    setState(() {
                                      isChecked.remove(snapshot.data[index].name
                                          .toUpperCase());
                                      categoryProvider.subscribeSource(
                                          snapshot.data[index].id,
                                          snapshot.data[index].name
                                              .toUpperCase());
                                    });
                                  },
                                ),
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         getCategorySelectedBySource(
                                  //             snapshot.data[index].name,
                                  //             snapshot.data[index].id),
                                  //   ),
                                  // );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _openPopup(context);
        },
        tooltip: 'بحث',
        label: Icon(Icons.filter_list),
        backgroundColor: themeColor(),
      ),
    );
  }

  Future<List<CateItems>> pageFetch(int offset) async {
    page++;
    final List<CateItems> nextDiscList =
        await categoryProvider.getCategoryChoicesP(pageNum: page);
    await Future<List<CateItems>>.delayed(Duration(milliseconds: 30));
    var maxPage = 0;
    String maxPageS =
        await ShPrefs.instance.getStringValue('categoryChoicesPages');
    if (maxPageS != "") {
      maxPage = int.parse(maxPageS);
    }
    return page == maxPage + 1 ? [] : nextDiscList;
  }

  Future<List<CateItems>> pageRefresh(int offset) async {
    page = 0;

    return pageFetch(offset);
  }

  _openPopup(context) async {
    List _selectedIndexes = [];
    String indexParam = "";
    saveValues() {
      for (int i = 0; i < _selectedIndexes.length; i++) {
        indexParam +=
            "&types=${Uri.encodeFull(_selectedIndexes[i].toString())}";
      }
      ShPrefs.instance.setStringValue('types', indexParam);
    }

    List<Map<String, String>> indexOptions = [
      {
        "display": "فيس بوك",
        "value": "facebook",
      },
      {
        "display": "تويتر",
        "value": "twitter-stream",
      },
      {
        "display": "rss قارئ",
        "value": "rss",
      },
      {
        "display": "قارئ المواقع العام",
        "value": "generic-spider",
      }
    ];
    removeFilterParameters() {
      ShPrefs.instance.removeValue("types");
    }

    setFilterParameters() {
      ShPrefs.instance.setStringValue('types', indexParam);
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
                Container(
                  child: MultiSelectFormField(
                    autovalidate: false,
                    chipBackGroundColor: Colors.deepOrange,
                    chipLabelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Jazeera',
                        color: Colors.white),
                    dialogTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Jazeera',
                        color: Colors.indigo),
                    checkBoxActiveColor: Colors.deepOrange,
                    checkBoxCheckColor: Colors.white,
                    dialogShapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0))),
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
                        print(_selectedIndexes);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        buttons: [
          DialogButton(
            color: Colors.red,
            onPressed: () {
              setState(() {
                removeFilterParameters();
                Navigator.pop(context);
              });
            },
            child: Text(
              "إعادة تعيين",
              style: TextStyle(
                  fontFamily: 'Jazeera', color: Colors.white, fontSize: 13),
            ),
          ),
          DialogButton(
            color: Colors.green,
            onPressed: () {
              setState(() {
                saveValues();
                removeFilterParameters();
                setFilterParameters();
                Navigator.pop(context);
              });
            },
            child: Text(
              "تطبيق و بحث",
              style: TextStyle(
                  fontFamily: 'Jazeera', color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ]).show();
  }
}

//Screen To view All Categories of search
class SearchChoicesSources extends StatefulWidget {
  final CateItems cateItems;
  SearchChoicesSources(this.cateItems);

  @override
  _ChoicesSources createState() => _ChoicesSources();
}

class _ChoicesSources extends State<SearchChoicesSources> {
  TextEditingController _searchControllerSource = TextEditingController();
  List<String> isChecked = [];
  bool themeSwitched = false;
  bool isSearching = false;
  bool searchResult = false;
  dynamic themeColor() {
    if (themeSwitched) {
      return Colors.grey[850];
    } else {}
  }

  @override
  void initState() {
    super.initState();
    _searchControllerSource.addListener(_onSearchChanged);
  }

  _onSearchChanged() {
    setState(() {
      searchResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor(),
        elevation: 0,
        brightness: themeSwitched ? Brightness.light : Brightness.dark,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("/categories");
            }),
        actions: [
          IconButton(
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
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: isSearching == true
                  ? Container(
                      width: 200,
                      child: TextField(
                        controller: _searchControllerSource,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            icon: Icon(Icons.search, color: Colors.white),
                            hintText: "بحث في ${widget.cateItems.name}",
                            hintStyle: TextStyle(color: Colors.white)),
                        cursorColor: Colors.white,
                        onTap: () {},
                        onChanged: (text) {
                          text = text.toLowerCase();
                        },
                      ),
                    )
                  : Text(
                      widget.cateItems.name,
                      style: TextStyle(fontFamily: 'Jazeera'),
                    ),
            ),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                isSearching == true
                    ? IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () {
                          setState(() {
                            isSearching = false;
                          });
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            isSearching = true;
                          });
                        },
                      ),
              ],
            ),
          ],
        ),
      ),
      body: searchResult == true
          ? Container(
              color: themeColor(),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Container(
                  child: FutureBuilder(
                    future:
                        categoryProvider.getCategorySourcesChoicesByTypesByName(
                            widget.cateItems.name,
                            _searchControllerSource.text),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<CategorySources>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                                      color: themeSwitched
                                          ? Colors.white
                                          : Colors.indigo,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      if (snapshot.data == null) {
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
                                      color: themeSwitched
                                          ? Colors.white
                                          : Colors.indigo,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          //shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              color: themeColor(),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    leading:
                                        snapshot.data[index].getNewsImage(),
                                    title: Center(
                                      child: Text(
                                        snapshot.data[index].name.toUpperCase(),
                                        style: TextStyle(
                                          fontFamily: 'Jazeera',
                                          fontSize: 15,
                                          color: themeSwitched
                                              ? Colors.white
                                              : Colors.indigo,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    trailing: SizedBox(
                                      width: 40,
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.favorite_border,
                                            size: 30,
                                          ),
                                          color: themeSwitched
                                              ? Colors.white
                                              : Colors.red,
                                          onPressed: () {
                                            setState(() {
                                              isChecked.add(snapshot
                                                  .data[index].name
                                                  .toUpperCase());
                                              categoryProvider.subscribeSource(
                                                  snapshot.data[index].id,
                                                  snapshot.data[index].name
                                                      .toUpperCase());
                                            });
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            )
          : Container(
              color: themeColor(),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Container(
                  child: FutureBuilder(
                    future: categoryProvider.getCategorySourcesChoicesByTypes(
                        widget.cateItems.name, 'types'),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<CategorySources>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                                      color: themeSwitched
                                          ? Colors.white
                                          : Colors.indigo,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      if (snapshot.data == null) {
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
                                      color: themeSwitched
                                          ? Colors.white
                                          : Colors.indigo,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (snapshot.data.isEmpty) {
                        return Container(
                          child: Center(
                            child: Text(
                              "... تم الإشتراك في جميع المصادر الخاصة ب${widget.cateItems.name}",
                              style: TextStyle(
                                fontFamily: 'Jazeera',
                                fontSize: 15,
                                color: themeSwitched
                                    ? Colors.indigo
                                    : Colors.indigo,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          //shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              color: themeColor(),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    leading:
                                        snapshot.data[index].getNewsImage(),
                                    title: Center(
                                      child: Text(
                                        snapshot.data[index].name.toUpperCase(),
                                        style: TextStyle(
                                          fontFamily: 'Jazeera',
                                          fontSize: 15,
                                          color: themeSwitched
                                              ? Colors.white
                                              : Colors.indigo,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    trailing: SizedBox(
                                      width: 40,
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.favorite_border,
                                            size: 30,
                                          ),
                                          color: themeSwitched
                                              ? Colors.white
                                              : Colors.red,
                                          onPressed: () {
                                            setState(() {
                                              isChecked.add(snapshot
                                                  .data[index].name
                                                  .toUpperCase());
                                              categoryProvider.subscribeSource(
                                                  snapshot.data[index].id,
                                                  snapshot.data[index].name
                                                      .toUpperCase());
                                            });
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _openPopup(context);
        },
        tooltip: 'بحث',
        label: Icon(Icons.filter_list),
        backgroundColor: themeColor(),
      ),
      endDrawer: AppDrawer(),
    );
  }

  _openPopup(context) async {
    List _selectedIndexes = [];
    String indexParam = "";
    saveValues() {
      for (int i = 0; i < _selectedIndexes.length; i++) {
        indexParam +=
            "&types=${Uri.encodeFull(_selectedIndexes[i].toString())}";
      }
      ShPrefs.instance.setStringValue('types', indexParam);
    }

    List<Map<String, String>> indexOptions = [
      {
        "display": "فيس بوك",
        "value": "facebook",
      },
      {
        "display": "تويتر",
        "value": "twitter-stream",
      },
      {
        "display": "rss قارئ",
        "value": "rss",
      },
      {
        "display": "قارئ المواقع العام",
        "value": "generic-spider",
      }
    ];
    removeFilterParameters() {
      ShPrefs.instance.removeValue("types");
    }

    setFilterParameters() {
      ShPrefs.instance.setStringValue('types', indexParam);
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
                Container(
                  child: MultiSelectFormField(
                    autovalidate: false,
                    chipBackGroundColor: Colors.deepOrange,
                    chipLabelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Jazeera',
                        color: Colors.white),
                    dialogTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Jazeera',
                        color: Colors.indigo),
                    checkBoxActiveColor: Colors.deepOrange,
                    checkBoxCheckColor: Colors.white,
                    dialogShapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0))),
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
                        print(_selectedIndexes);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        buttons: [
          DialogButton(
            color: Colors.red,
            onPressed: () {
              setState(() {
                removeFilterParameters();
                Navigator.pop(context);
              });
            },
            child: Text(
              "إعادة تعيين",
              style: TextStyle(
                  fontFamily: 'Jazeera', color: Colors.white, fontSize: 13),
            ),
          ),
          DialogButton(
            color: Colors.green,
            onPressed: () {
              setState(() {
                saveValues();
                removeFilterParameters();
                setFilterParameters();
                Navigator.pop(context);
              });
            },
            child: Text(
              "تطبيق و بحث",
              style: TextStyle(
                  fontFamily: 'Jazeera', color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ]).show();
  }
}
