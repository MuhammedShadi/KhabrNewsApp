import 'package:flutter/material.dart';
import 'package:khbr_app/model/category_sources.dart';
import 'package:khbr_app/model/news_item.dart';
import 'package:khbr_app/providers/news_provider.dart';
import 'package:khbr_app/screens/index.dart';
import 'package:khbr_app/screens/news_details.dart';
import 'package:khbr_app/screens/subscribed_categories.dart';
import 'package:url_launcher/url_launcher.dart';

NewsProvider _newsProvider = new NewsProvider();

class SearchScreen extends StatefulWidget {
  static const routName = '/search';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool themeSwitched = false;
  bool searchChecked = false;
  bool searchTextResult = false;
  var textValue = "";
  dynamic themeColor() {
    if (themeSwitched) {
      return Colors.grey[850];
    } else {}
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  _onSearchChanged() {
    setState(() {});
  }

  Widget chooseSearchBar = Center(
    child: Text(
      " بحث تفصيلي",
      style: TextStyle(fontFamily: 'Jazeera'),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor(),
        elevation: 0,
        brightness: themeSwitched ? Brightness.light : Brightness.dark,
        title: chooseSearchBar,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            setState(() {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => IndexScreen()),
              );
            });
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                color: Colors.indigo.shade200,
                child: new Card(
                  child: new ListTile(
                    leading: new IconButton(
                      icon: new Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          searchTextResult = true;
                          searchChecked = false;
                          textValue = _searchController.text;
                          _searchController.clear();
                        });
                        // onSearchTextChanged('');
                      },
                    ),
                    title: new TextField(
                      controller: _searchController,
                      decoration: new InputDecoration(
                          hintText: 'بحث', border: InputBorder.none),
                      onTap: () {
                        //indexWedget();
                        setState(() {
                          // searchChecked = true;
                          searchTextResult = true;
                          categoriesSourcesSubscribedWidgetByName(
                              _searchController.text);
                        });
                      },
                    ),
                    trailing: new IconButton(
                      icon: new Icon(Icons.cancel),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          searchChecked = false;
                          searchTextResult = false;
                        });
                        // onSearchTextChanged('');
                      },
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  searchTextResult == true || _searchController.text.isNotEmpty
                      ? SingleChildScrollView(
                          child: categoriesSourcesSubscribedWidgetByName(
                              _searchController.text))
                      : Text(
                          "لا توجد عناصر نتيجة البحث",
                          style: TextStyle(fontFamily: 'Jazeera'),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget categoriesSourcesSubscribedWidgetByName(sourceName) {
    return SingleChildScrollView(
      child: FutureBuilder(
          future: categoryProvider
              .getCategorySourcesSubscribedBySourceName(sourceName),
          builder: (BuildContext context,
              AsyncSnapshot<List<CategorySources>> snapshot) {
            if (snapshot.data == null || snapshot.data.isEmpty) {
              return Center(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 80),
                    child: Center(
                      child: Row(
                        children: <Widget>[
                          CircularProgressIndicator(),
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
                  ),
                ),
              );
            } else {
              return Scrollbar(
                // isAlwaysShown: true,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height - 160,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          scrollDirection: Axis.vertical,
                          // ignore: missing_return
                          itemBuilder: (BuildContext context, int index) {
                            if (snapshot.hasData) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          getCategorySelectedBySource(
                                              snapshot.data[index].name,
                                              snapshot.data[index].id),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    new Card(
                                      child: new ListTile(
                                        leading:
                                            snapshot.data[index].getNewsImage(),
                                        title: Text(
                                          snapshot.data[index].name,
                                          style: new TextStyle(
                                            color: Colors.indigo,
                                            fontFamily: 'Jazeera',
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        trailing: new IconButton(
                                            icon: snapshot.data[index]
                                                .getNewsIcon(),
                                            onPressed: () {},
                                            color: Colors.indigo),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }

  Widget getCategorySelectedBySource(String sourceName, String sourceId) {
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
      body: FutureBuilder(
        future: _newsProvider.getNewsDataBySourceBySearch(sourceId, true),
        builder:
            (BuildContext context, AsyncSnapshot<List<NewsItem>> snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 80, top: 150),
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
                            color:
                                themeSwitched ? Colors.indigo : Colors.indigo,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          if (snapshot.data.isEmpty) {
            return Center(
              child: Text(
                "... لا توجد بيانات حالياً للعرض",
                style: TextStyle(
                  fontFamily: 'Jazeera',
                  fontSize: 15,
                  color: themeSwitched ? Colors.indigo : Colors.indigo,
                ),
              ),
            );
          } else {
            return Column(
              children: <Widget>[
                Container(
                  color: themeColor(),
                  height: MediaQuery.of(context).size.height - 80,
                  child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () async {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                    NewsScreenDetails(snapshot.data[index])),
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
                                        snapshot.data[index].getNewsImage(),
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
                                          splashColor: Colors
                                              .white, // inkwell onPress colour
                                          child: SizedBox(
                                            width: 18,
                                            height:
                                                18, //customisable size of 'button'
                                            child: snapshot.data[index]
                                                .getNewsIcon(),
                                          ),
                                          onTap:
                                              () {}, // or use onPressed: () {}
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
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                child: Text(
                                                  snapshot.data[index].title,
                                                  style: new TextStyle(
                                                    color: themeSwitched
                                                        ? Colors.white
                                                        : Colors.indigo,
                                                    fontFamily: 'Jazeera',
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: snapshot
                                                      .data[index]
                                                      .getNewsTextAlign(),
                                                  textDirection: snapshot
                                                      .data[index]
                                                      .getNewsTextDirection(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Icon(
                                            Icons.date_range,
                                            color: themeSwitched
                                                ? Colors.white
                                                : Colors.indigo,
                                            size: 10,
                                          ),
                                          Text(
                                            snapshot.data[index].getNewsDate(),
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
                                            color: themeSwitched
                                                ? Colors.white
                                                : Colors.indigo,
                                            size: 10,
                                          ),
                                          Text(
                                            snapshot.data[index].getNewsTime(),
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
                                            color: themeSwitched
                                                ? Colors.white
                                                : Colors.indigo,
                                            size: 10,
                                          ),
                                          InkWell(
                                            child: Text(
                                              snapshot.data[index]
                                                  .getNewsUserName(),
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
                                              if (await canLaunch(
                                                  snapshot.data[index].url)) {
                                                await launch(
                                                    snapshot.data[index].url);
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
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
