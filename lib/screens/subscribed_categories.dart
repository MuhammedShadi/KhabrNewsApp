import 'package:flutter/material.dart';
import 'package:khbr_app/model/category.dart';
import 'package:khbr_app/model/category_item.dart';
import 'package:khbr_app/model/category_sources.dart';
import 'package:khbr_app/model/news_item.dart';
import 'package:khbr_app/providers/category_provider.dart';
import 'package:khbr_app/providers/login_provider.dart';
import 'package:khbr_app/providers/news_provider.dart';
import 'package:khbr_app/screens/news_details.dart';
import 'package:khbr_app/widgets/app_drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:khbr_app/providers/sh_prefs.dart';

String imageCat = 'assets/images/khbar.png';
String imageCatOff = 'assets/images/khbaroff.png';
CategoryProvider categoryProvider = new CategoryProvider();
LoginProvider loginProvider = new LoginProvider();
NewsProvider _newsProvider = new NewsProvider();
ScrollController _scrollController = ScrollController();
final sortOnSelected = TextEditingController();
int page;

class SubscribedCategoriesScreen extends StatefulWidget {
  static const routName = "/subcribedcategories";
  @override
  _SubscribedCategoriesScreenState createState() =>
      _SubscribedCategoriesScreenState();
}

class _SubscribedCategoriesScreenState
    extends State<SubscribedCategoriesScreen> {
  PaginationViewType paginationViewType;
  GlobalKey<PaginationViewState> key;
  LoginProvider loginProvider = new LoginProvider();
  List<Category> categories;
  bool themeSwitched = false;
  bool isSearching = false;
  bool searchResult = false;
  TextEditingController _searchController = TextEditingController();

  List<String> isChecked = [];

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
                      width: 130,
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            icon: Icon(Icons.search, color: Colors.white),
                            hintText: "بحث",
                            hintStyle: TextStyle(color: Colors.white)),
                        cursorColor: Colors.white,
                        onTap: () {},
                        onChanged: (text) {
                          text = text.toLowerCase();
                        },
                      ),
                    )
                  : Text(
                      "المفضلة",
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
      body: searchResult == true
          ? Container(
              color: themeColor(),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Container(
                  child: FutureBuilder(
                    future: categoryProvider
                        .getCategorySubscribedByName(_searchController.text),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<CateItems>> snapshot) {
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
                                // Navigator.push(
                                //   context,
                                //   new MaterialPageRoute(
                                //     builder: (context) =>
                                //         GetCategorySourcesSubscribed(
                                //             snapshot.data[index]),
                                //   ),
                                // );
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
                                        color: themeSwitched
                                            ? Colors.white
                                            : Colors.red,
                                        onPressed: () {
                                          //Get News By categoryName
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      getCategorySelectedByCategory(
                                                          snapshot.data[index]
                                                              .name)));
                                        },
                                      ),
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
          : getCategoriesSubscribedNames(),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
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
                    ),
                    onPressed: () {
                      //categories
                      Navigator.of(context).pushReplacementNamed("/categories");
                    }),
                IconButton(
                    icon: Icon(
                      Icons.favorite,
                      size: 30,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed("/subcribedcategories");
                    }),
              ],
            )),
      ),
      endDrawer: AppDrawer(),
      // bottomNavigationBar: TabsScreen(_cateSources),
    );
  }

  Widget getCategorySelectedByCategory(String categoryName) {
    Future<List<NewsItem>> pageFetch(int offset) async {
      page++;
      final List<NewsItem> nextDiscList = await _newsProvider
          .getNewsDataByCategoryP(categoryName, pageNum: page);
      await Future<List<NewsItem>>.delayed(Duration(milliseconds: 30));
      var maxPage = 0;
      String maxPageS = await ShPrefs.instance.getStringValue('indexNewPages');
      if (maxPageS != "") {
        maxPage = int.parse(maxPageS);
      }
      return page == maxPage + 1 ? [] : nextDiscList;
    }

    Future<List<NewsItem>> pageRefresh(int offset) async {
      page = 0;
      return pageFetch(offset);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor(),
        title: Center(
          child: Text(
            categoryName,
            style: TextStyle(fontFamily: 'Jazeera'),
          ),
        ),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        clipBehavior: Clip.hardEdge,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: themeColor(),
          child: PaginationView<NewsItem>(
            paginationViewType: PaginationViewType.listView,
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
                                              textAlign:
                                                  disc.getNewsTextAlign(),
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
      ),
    );
  }

  Widget getCategorySourcesSubscribed2(String categoryName) {
    List<String> isChecked = [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor(),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed("/subcribedcategories");
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
      body: Container(
        color: themeColor(),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder(
          future: categoryProvider
              .getCategorySourcesSubscribedByTypes(categoryName),
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
                              color: themeSwitched ? Colors.red : Colors.indigo,
                            ),
                          ),
                        ),
                      ],
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
                            icon: Icon(Icons.delete),
                            color: themeSwitched ? Colors.white : Colors.red,
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                isChecked.remove(
                                    snapshot.data[index].name.toUpperCase());
                                categoryProvider.unsubscribeSource(
                                    snapshot.data[index].id,
                                    snapshot.data[index].name.toUpperCase());
                              });
                            },
                          ),
                          onTap: () async {
                            await ShPrefs.instance.setStringValue(
                                'sourceId', snapshot.data[index].id);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    getCategorySelectedBySource2(
                                        snapshot.data[index].name,
                                        snapshot.data[index].id),
                              ),
                            );
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
    );
  }

  Widget getCategoriesSubscribedNames() {
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
                                getCategorySourcesSubscribed2(disc.name),
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
                                getCategorySourcesSubscribed2(disc.name),
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
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              getCategorySelectedByCategory(
                                                  disc.name)));
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

  Future<List<CateItems>> pageFetch(int offset) async {
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

  Future<List<CateItems>> pageRefresh(int offset) async {
    page = 0;
    return pageFetch(offset);
  }

  Widget getCategorySelectedBySource2(String sourceName, String sourceId) {
    PaginationViewType paginationViewType;
    GlobalKey<PaginationViewState> key;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor(),
        title: Center(
          child: Text(
            sourceName,
            style: TextStyle(fontFamily: 'Jazeera'),
          ),
        ),
      ),
      body: PaginationView<NewsItem>(
        key: key,
        paginationViewType: paginationViewType,
        itemBuilder: (BuildContext context, NewsItem disc, int index) =>
            InkWell(
          onTap: () async {
            Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => NewsScreenDetails(disc)),
            );
          },
          child: ClipRRect(
            child: Card(
              color: themeColor(),
              margin: const EdgeInsets.only(
                  left: 5.0, right: 5.0, bottom: 10.0, top: 0.0),
              elevation: 4.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        borderRadius: BorderRadius.all(Radius.circular(5)),
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
                            splashColor: Colors.white, // inkwell onPress colour
                            child: SizedBox(
                              width: 18,
                              height: 18, //customisable size of 'button'
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Text(
                                    disc.title,
                                    style: new TextStyle(
                                      color: themeSwitched
                                          ? Colors.white
                                          : Colors.indigo,
                                      fontFamily: 'Jazeera',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: disc.getNewsTextAlign(),
                                    textDirection: disc.getNewsTextDirection(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Icon(
                              Icons.date_range,
                              color:
                                  themeSwitched ? Colors.white : Colors.indigo,
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
                            SizedBox(width: 5),
                            Icon(
                              Icons.access_time,
                              color:
                                  themeSwitched ? Colors.white : Colors.indigo,
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
                            SizedBox(width: 10),
                            Icon(
                              Icons.web,
                              color:
                                  themeSwitched ? Colors.white : Colors.indigo,
                              size: 10,
                            ),
                            InkWell(
                              child: Text(
                                disc.getNewsUserName(),
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
        pageFetch: pageFetch1,
        pageRefresh: pageRefresh1,
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
    );
  }

  Future<List<NewsItem>> pageFetch1(int offset) async {
    print('aaa');
    page++;
    print(page);
    final List<NewsItem> nextDiscList =
        await _newsProvider.getNewsDataBySourceP(true, pageNum: page);
    await Future<List<NewsItem>>.delayed(Duration(milliseconds: 30));
    var maxPage = 0;
    String maxPageS = await ShPrefs.instance.getStringValue('newsPagesNum');
    if (maxPageS != "") {
      maxPage = int.parse(maxPageS);
    }
    return page == maxPage + 1 ? [] : nextDiscList;
  }

  Future<List<NewsItem>> pageRefresh1(int offset) async {
    page = 0;
    return pageFetch1(offset);
  }
}
