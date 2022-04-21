import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khbr_app/model/news_item.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;
import 'package:flutter_tts/flutter_tts.dart';

String imageCat = 'assets/images/khbar.png';
FlutterTts flutterTts;
bool isPlaying = false;

class NewsScreenDetails extends StatefulWidget {
  static const routName = '/newsdetails';
  final NewsItem _newsItem;
  NewsScreenDetails(this._newsItem);

  @override
  _NewsScreenDetailsState createState() => _NewsScreenDetailsState();
}

class _NewsScreenDetailsState extends State<NewsScreenDetails> {
  final ScrollController _scrollController = ScrollController();
  bool themeSwitched = false;
  double fontSize = 14;

  dynamic themeColor() {
    if (themeSwitched) {
      return Colors.grey[850];
    } else {}
  }

  dynamic fontSizeMax() {
    setState(() {
      fontSize += 2;
    });
  }

  dynamic fontSizeMin() {
    setState(() {
      fontSize -= 2;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeTts();
  }

  initializeTts() {
    flutterTts = FlutterTts();
    flutterTts.setStartHandler(() {
      setState(() {
        isPlaying = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
    });

    flutterTts.setErrorHandler((err) {
      setState(() {
        isPlaying = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  void setTtsLanguage() async {
    await flutterTts.setLanguage("en-US");
  }

  void speechSettings1() {
    flutterTts.setVoice("en-us-x-sfg#male_1-local");
    flutterTts.setPitch(1.5);
    flutterTts.setSpeechRate(.9);
  }

  void speechSettings2() {
    flutterTts.setVoice("en-us-x-sfg#male_2-local");
    flutterTts.setPitch(1);
    flutterTts.setSpeechRate(0.5);
  }

  Future _speak(String text) async {
    if (text != null && text.isNotEmpty) {
      var result = await flutterTts.speak(text);
      if (result == 1)
        setState(() {
          isPlaying = true;
        });
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1)
      setState(() {
        isPlaying = false;
      });
  }

  Widget buildSectionTitle(BuildContext context, String text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: widget._newsItem.title == null
          ? Text(
              widget._newsItem.getAllNewsUserTitle(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Jazeera',
                color: themeSwitched ? Colors.white : Colors.indigo,
                fontWeight: FontWeight.w600,
              ),
              textDirection: widget._newsItem.getNewsTextDirection(),
            )
          : Text(
              widget._newsItem.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Jazeera',
                color: themeSwitched ? Colors.white : Colors.indigo,
                fontWeight: FontWeight.w600,
              ),
              textDirection: widget._newsItem.getNewsTextDirection(),
            ),
    );
  }

  Widget buildContainer(Widget child) {
    return Container(
      height: MediaQuery.of(context).size.height - 90,
      width: MediaQuery.of(context).size.width,
      child: child,
    );
  }

  _nextPage(BuildContext context) async {
    Navigator.of(context).pushReplacementNamed("/index");
  }

  @override
  Widget build(BuildContext context) {
    if (widget._newsItem.index == 'rss') {
      return rssBuild(context);
    }
    if (widget._newsItem.index == 'twitter_tweets' ||
        widget._newsItem.index == 'twitter-stream') {
      return twitterBuild(context);
    }
    if (widget._newsItem.index == 'facebook_posts' ||
        widget._newsItem.index == 'facebook') {
      return facebookBuild(context);
    }
    if (widget._newsItem.index == 'telegram-channel' ||
        widget._newsItem.index == 'telegram_posts') {
      return telegramBuild(context);
    } else {
      return rssBuild(context);
    }
  }

  double _scale = 1.0;
  double _previousScale;
  Widget rssBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor(),
        elevation: 0,
        brightness: themeSwitched ? Brightness.light : Brightness.dark,
        actions: [
          Row(
            children: [
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
          ),
        ],
        title: Center(
          child: Text(
            widget._newsItem.title,
            style: TextStyle(
                fontFamily: 'Jazeera', color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Dismissible(
        key: Key(widget._newsItem.index),
        direction: DismissDirection.startToEnd,
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            _nextPage(context);
          }
        },
        child: Container(
          color: themeColor(),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              buildContainer(
                ListView.builder(
                    controller: _scrollController,
                    itemBuilder: (ctx, index) => Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Container(
                                      height: 220,
                                      width: double.infinity,
                                      child: Container(
                                        padding: EdgeInsets.only(top: 5),
                                        child: ClipRRect(
                                          child: Image.network(
                                            widget._newsItem.index == "rss"
                                                ? widget._newsItem.topImg ==
                                                        null
                                                    ? widget._newsItem
                                                        .getNewsImage()
                                                    : widget._newsItem
                                                        .getAllNewsUserImage()
                                                : widget._newsItem
                                                    .getAllNewsUserImage(),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: buildSectionTitle(
                                          context, widget._newsItem.title),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.web,
                                                    color: themeSwitched
                                                        ? Colors.white
                                                        : Colors.indigo,
                                                    size: 10,
                                                  ),
                                                  InkWell(
                                                    child: Text(
                                                      widget._newsItem
                                                          .getNewsUserName(),
                                                      style: new TextStyle(
                                                        color: themeSwitched
                                                            ? Colors.white
                                                            : Colors.indigo,
                                                        fontFamily: 'Jazeera',
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    onTap: () async {
                                                      if (await canLaunch(widget
                                                          ._newsItem.url)) {
                                                        await launch(widget
                                                            ._newsItem.url);
                                                      }
                                                    },
                                                  ),
                                                  SizedBox(
                                                    width: 1,
                                                  ),
                                                  Icon(
                                                    Icons.date_range,
                                                    color: themeSwitched
                                                        ? Colors.white
                                                        : Colors.indigo,
                                                    size: 10,
                                                  ),
                                                  Text(
                                                    widget._newsItem
                                                        .getNewsDate(),
                                                    style: new TextStyle(
                                                      color: themeSwitched
                                                          ? Colors.white
                                                          : Colors.indigo,
                                                      fontFamily: 'Jazeera',
                                                      fontSize: 10,
                                                    ),
                                                    textAlign: TextAlign.center,
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
                                                    widget._newsItem
                                                        .getNewsTime(),
                                                    style: new TextStyle(
                                                      color: themeSwitched
                                                          ? Colors.white
                                                          : Colors.indigo,
                                                      fontFamily: 'Jazeera',
                                                      fontSize: 10,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  IconButton(
                                                      icon: Icon(
                                                        Icons.zoom_out,
                                                        color: themeSwitched
                                                            ? Colors.white
                                                            : Colors.indigo,
                                                        size: 20,
                                                      ),
                                                      onPressed: () {
                                                        fontSizeMin();
                                                      }),
                                                  IconButton(
                                                      icon: Icon(
                                                        Icons.zoom_in,
                                                        color: themeSwitched
                                                            ? Colors.white
                                                            : Colors.indigo,
                                                        size: 20,
                                                      ),
                                                      onPressed: () {
                                                        fontSizeMax();
                                                      }),
                                                  widget._newsItem
                                                              .getNewsTextDirection() ==
                                                          TextDirection.rtl
                                                      ? Row()
                                                      : IconButton(
                                                          icon: Icon(
                                                            isPlaying
                                                                ? Icons.stop
                                                                : Icons
                                                                    .record_voice_over_sharp,
                                                            color: themeSwitched
                                                                ? Colors.white
                                                                : Colors.indigo,
                                                            size: 20,
                                                          ),
                                                          onPressed: () {
                                                            //
                                                            isPlaying
                                                                ? _stop()
                                                                : _speak(widget
                                                                    ._newsItem
                                                                    .text);
                                                          }),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onScaleStart:
                                          (ScaleStartDetails details) {
                                        _previousScale = _scale;
                                      },
                                      onScaleUpdate:
                                          (ScaleUpdateDetails details) {
                                        setState(() {
                                          _scale =
                                              _previousScale * details.scale;
                                        });
                                      },
                                      onScaleEnd: (ScaleEndDetails details) {
                                        _previousScale = null;
                                      },
                                      child: Transform(
                                        transform: Matrix4.diagonal3(Vector3(
                                            _scale.clamp(1.0, 5.0),
                                            _scale.clamp(1.0, 5.0),
                                            _scale.clamp(1.0, 5.0))),
                                        alignment: FractionalOffset.center,
                                        child: Text(
                                          widget._newsItem.text,
                                          style: TextStyle(
                                            fontFamily: 'Jazeera',
                                            color: themeSwitched
                                                ? Colors.white
                                                : Colors.indigo,
                                            fontWeight: FontWeight.w600,
                                            fontSize: fontSize,
                                          ),
                                          textAlign: widget._newsItem
                                              .getNewsTextAlign(),
                                          textDirection: widget._newsItem
                                              .getNewsTextDirection(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    shareToSocialMedia(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                    itemCount: 1 //selectNews.ingredients.length,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget twitterBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor(),
        elevation: 0,
        brightness: themeSwitched ? Brightness.light : Brightness.dark,
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
        title: Center(
          child: Text(
            widget._newsItem.getNewsUserName(),
            style: TextStyle(
                fontFamily: 'Jazeera', color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Dismissible(
        key: new ValueKey("dismiss_key"),
        direction: DismissDirection.startToEnd,
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            _nextPage(context);
          }
        },
        child: Container(
          color: themeColor(),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              buildContainer(
                ListView.builder(
                    itemBuilder: (ctx, index) => Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Container(
                                      height: 220,
                                      width: double.infinity,
                                      child: Container(
                                        padding: EdgeInsets.only(top: 5),
                                        child: ClipRRect(
                                          child: Image.network(
                                            widget._newsItem.topImg == null
                                                ? widget._newsItem
                                                    .getNewsImage()
                                                : widget._newsItem
                                                    .getAllNewsUserImage(),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: buildSectionTitle(
                                          context, widget._newsItem.title),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.web,
                                                    color: themeSwitched
                                                        ? Colors.white
                                                        : Colors.indigo,
                                                    size: 10,
                                                  ),
                                                  InkWell(
                                                    child: Text(
                                                      widget._newsItem
                                                          .getNewsUserName(),
                                                      style: new TextStyle(
                                                        color: themeSwitched
                                                            ? Colors.white
                                                            : Colors.indigo,
                                                        fontFamily: 'Jazeera',
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    onTap: () async {
                                                      if (await canLaunch(widget
                                                          ._newsItem.url)) {
                                                        await launch(widget
                                                            ._newsItem.url);
                                                      }
                                                    },
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Icon(
                                                    Icons.date_range,
                                                    color: themeSwitched
                                                        ? Colors.white
                                                        : Colors.indigo,
                                                    size: 10,
                                                  ),
                                                  Text(
                                                    widget._newsItem
                                                        .getNewsDate(),
                                                    style: new TextStyle(
                                                      color: themeSwitched
                                                          ? Colors.white
                                                          : Colors.indigo,
                                                      fontFamily: 'Jazeera',
                                                      fontSize: 10,
                                                    ),
                                                    textAlign: TextAlign.center,
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
                                                    widget._newsItem
                                                        .getNewsTime(),
                                                    style: new TextStyle(
                                                      color: themeSwitched
                                                          ? Colors.white
                                                          : Colors.indigo,
                                                      fontFamily: 'Jazeera',
                                                      fontSize: 10,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(width: 10),
                                                  IconButton(
                                                      icon: Icon(
                                                        Icons.zoom_out,
                                                        color: themeSwitched
                                                            ? Colors.white
                                                            : Colors.indigo,
                                                        size: 20,
                                                      ),
                                                      onPressed: () {
                                                        fontSizeMin();
                                                      }),
                                                  IconButton(
                                                      icon: Icon(
                                                        Icons.zoom_in,
                                                        color: themeSwitched
                                                            ? Colors.white
                                                            : Colors.indigo,
                                                        size: 20,
                                                      ),
                                                      onPressed: () {
                                                        fontSizeMax();
                                                      }),
                                                  widget._newsItem
                                                              .getNewsTextDirection() ==
                                                          TextDirection.rtl
                                                      ? Row()
                                                      : IconButton(
                                                          icon: Icon(
                                                            isPlaying
                                                                ? Icons.stop
                                                                : Icons
                                                                    .record_voice_over_sharp,
                                                            color: themeSwitched
                                                                ? Colors.white
                                                                : Colors.indigo,
                                                            size: 20,
                                                          ),
                                                          onPressed: () {
                                                            //
                                                            isPlaying
                                                                ? _stop()
                                                                : _speak(widget
                                                                    ._newsItem
                                                                    .text);
                                                          }),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onScaleStart:
                                          (ScaleStartDetails details) {
                                        _previousScale = _scale;
                                      },
                                      onScaleUpdate:
                                          (ScaleUpdateDetails details) {
                                        setState(() {
                                          _scale =
                                              _previousScale * details.scale;
                                        });
                                      },
                                      onScaleEnd: (ScaleEndDetails details) {
                                        _previousScale = null;
                                      },
                                      child: Transform(
                                        transform: Matrix4.diagonal3(Vector3(
                                            _scale.clamp(1.0, 5.0),
                                            _scale.clamp(1.0, 5.0),
                                            _scale.clamp(1.0, 5.0))),
                                        alignment: FractionalOffset.center,
                                        child: Text(
                                          widget._newsItem.text,
                                          style: TextStyle(
                                            fontFamily: 'Jazeera',
                                            color: themeSwitched
                                                ? Colors.white
                                                : Colors.indigo,
                                            fontSize: fontSize,
                                          ),
                                          textAlign: TextAlign.right,
                                          textDirection: widget._newsItem
                                              .getNewsTextDirection(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    shareToSocialMedia(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                    itemCount: 1 //selectNews.ingredients.length,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget facebookBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor(),
        elevation: 0,
        brightness: themeSwitched ? Brightness.light : Brightness.dark,
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
        title: Center(
          child: widget._newsItem.title == null
              ? Text(
                  widget._newsItem.getAllNewsUserTitle(),
                  style: TextStyle(
                      fontFamily: 'Jazeera', color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                  textDirection: widget._newsItem.getNewsTextDirection(),
                )
              : Text(
                  widget._newsItem.title,
                  style: TextStyle(
                      fontFamily: 'Jazeera', color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                  textDirection: widget._newsItem.getNewsTextDirection(),
                ),
        ),
      ),
      body: Dismissible(
        key: new ValueKey("dismiss_key"),
        direction: DismissDirection.startToEnd,
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            _nextPage(context);
          }
        },
        child: Container(
          color: themeColor(),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              buildContainer(
                ListView.builder(
                    controller: _scrollController,
                    itemBuilder: (ctx, index) => Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Container(
                                      height: 220,
                                      width: double.infinity,
                                      child: Container(
                                        padding: EdgeInsets.only(top: 5),
                                        child: ClipRRect(
                                          child: Image.network(
                                            widget._newsItem.profileImageUrlHttps ==
                                                        null &&
                                                    widget._newsItem.topImg ==
                                                        null
                                                ? widget._newsItem
                                                    .getNewsImage()
                                                : widget._newsItem
                                                    .getAllNewsUserImage(),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: buildSectionTitle(
                                          context, widget._newsItem.title),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.web,
                                                    color: themeSwitched
                                                        ? Colors.white
                                                        : Colors.indigo,
                                                    size: 10,
                                                  ),
                                                  InkWell(
                                                    child: widget._newsItem
                                                                .userName ==
                                                            null
                                                        ? Text(
                                                            widget._newsItem
                                                                .getNewsUserName(),
                                                            style:
                                                                new TextStyle(
                                                              color: themeSwitched
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .indigo,
                                                              fontFamily:
                                                                  'Jazeera',
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                            textDirection: widget
                                                                ._newsItem
                                                                .getNewsTextDirection(),
                                                          )
                                                        : Text(
                                                            widget._newsItem
                                                                .getAllNewsUserName(),
                                                            style:
                                                                new TextStyle(
                                                              color: themeSwitched
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .indigo,
                                                              fontFamily:
                                                                  'Jazeera',
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                            textDirection: widget
                                                                ._newsItem
                                                                .getNewsTextDirection(),
                                                          ),
                                                    onTap: () async {
                                                      if (await canLaunch(widget
                                                          ._newsItem.url)) {
                                                        await launch(widget
                                                            ._newsItem.url);
                                                      }
                                                    },
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Icon(
                                                    Icons.date_range,
                                                    color: themeSwitched
                                                        ? Colors.white
                                                        : Colors.indigo,
                                                    size: 10,
                                                  ),
                                                  Text(
                                                    widget._newsItem
                                                        .getNewsDate(),
                                                    style: new TextStyle(
                                                      color: themeSwitched
                                                          ? Colors.white
                                                          : Colors.indigo,
                                                      fontFamily: 'Jazeera',
                                                      fontSize: 10,
                                                    ),
                                                    textAlign: TextAlign.center,
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
                                                    widget._newsItem
                                                        .getNewsTime(),
                                                    style: new TextStyle(
                                                      color: themeSwitched
                                                          ? Colors.white
                                                          : Colors.indigo,
                                                      fontFamily: 'Jazeera',
                                                      fontSize: 10,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(width: 10),
                                                  IconButton(
                                                      icon: Icon(
                                                        Icons.zoom_out,
                                                        color: themeSwitched
                                                            ? Colors.white
                                                            : Colors.indigo,
                                                        size: 20,
                                                      ),
                                                      onPressed: () {
                                                        fontSizeMin();
                                                      }),
                                                  IconButton(
                                                      icon: Icon(
                                                        Icons.zoom_in,
                                                        color: themeSwitched
                                                            ? Colors.white
                                                            : Colors.indigo,
                                                        size: 20,
                                                      ),
                                                      onPressed: () {
                                                        fontSizeMax();
                                                      }),
                                                  widget._newsItem
                                                              .getNewsTextDirection() ==
                                                          TextDirection.rtl
                                                      ? Row()
                                                      : IconButton(
                                                          icon: Icon(
                                                            isPlaying
                                                                ? Icons.stop
                                                                : Icons
                                                                    .record_voice_over_sharp,
                                                            color: themeSwitched
                                                                ? Colors.white
                                                                : Colors.indigo,
                                                            size: 20,
                                                          ),
                                                          onPressed: () {
                                                            //
                                                            isPlaying
                                                                ? _stop()
                                                                : _speak(widget
                                                                    ._newsItem
                                                                    .text);
                                                          }),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onScaleStart:
                                          (ScaleStartDetails details) {
                                        _previousScale = _scale;
                                      },
                                      onScaleUpdate:
                                          (ScaleUpdateDetails details) {
                                        setState(() {
                                          _scale =
                                              _previousScale * details.scale;
                                        });
                                      },
                                      onScaleEnd: (ScaleEndDetails details) {
                                        _previousScale = null;
                                      },
                                      child: Transform(
                                        transform: Matrix4.diagonal3(Vector3(
                                            _scale.clamp(1.0, 5.0),
                                            _scale.clamp(1.0, 5.0),
                                            _scale.clamp(1.0, 5.0))),
                                        alignment: FractionalOffset.center,
                                        child: Text(
                                          widget._newsItem.text,
                                          style: TextStyle(
                                            fontFamily: 'Jazeera',
                                            color: themeSwitched
                                                ? Colors.white
                                                : Colors.indigo,
                                            fontSize: fontSize,
                                          ),
                                          textAlign: TextAlign.right,
                                          textDirection: widget._newsItem
                                              .getNewsTextDirection(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    shareToSocialMedia(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                    itemCount: 1 //selectNews.ingredients.length,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget telegramBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor(),
        elevation: 0,
        brightness: themeSwitched ? Brightness.light : Brightness.dark,
        actions: [
          Row(
            children: [
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
          ),
        ],
        title: Center(
          child: Text(
            widget._newsItem.title,
            style: TextStyle(
                fontFamily: 'Jazeera', color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Dismissible(
        key: Key(widget._newsItem.index),
        direction: DismissDirection.startToEnd,
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            _nextPage(context);
          }
        },
        child: Container(
          color: themeColor(),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              buildContainer(
                ListView.builder(
                    controller: _scrollController,
                    itemBuilder: (ctx, index) => Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Container(
                                      height: 220,
                                      width: double.infinity,
                                      child: Container(
                                        padding: EdgeInsets.only(top: 5),
                                        child: ClipRRect(
                                          child: Image.network(
                                            widget._newsItem.getNewsImage(),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: buildSectionTitle(
                                          context, widget._newsItem.title),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.web,
                                                    color: themeSwitched
                                                        ? Colors.white
                                                        : Colors.indigo,
                                                    size: 10,
                                                  ),
                                                  InkWell(
                                                    child: Text(
                                                      widget._newsItem
                                                          .getNewsUserName(),
                                                      style: new TextStyle(
                                                        color: themeSwitched
                                                            ? Colors.white
                                                            : Colors.indigo,
                                                        fontFamily: 'Jazeera',
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    onTap: () async {
                                                      if (await canLaunch(widget
                                                          ._newsItem.url)) {
                                                        await launch(widget
                                                            ._newsItem.url);
                                                      }
                                                    },
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Icon(
                                                    Icons.date_range,
                                                    color: themeSwitched
                                                        ? Colors.white
                                                        : Colors.indigo,
                                                    size: 10,
                                                  ),
                                                  Text(
                                                    widget._newsItem
                                                        .getNewsDate(),
                                                    style: new TextStyle(
                                                      color: themeSwitched
                                                          ? Colors.white
                                                          : Colors.indigo,
                                                      fontFamily: 'Jazeera',
                                                      fontSize: 10,
                                                    ),
                                                    textAlign: TextAlign.center,
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
                                                    widget._newsItem
                                                        .getNewsTime(),
                                                    style: new TextStyle(
                                                      color: themeSwitched
                                                          ? Colors.white
                                                          : Colors.indigo,
                                                      fontFamily: 'Jazeera',
                                                      fontSize: 10,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(width: 10),
                                                  IconButton(
                                                      icon: Icon(
                                                        Icons.zoom_out,
                                                        color: themeSwitched
                                                            ? Colors.white
                                                            : Colors.indigo,
                                                        size: 20,
                                                      ),
                                                      onPressed: () {
                                                        fontSizeMin();
                                                      }),
                                                  IconButton(
                                                      icon: Icon(
                                                        Icons.zoom_in,
                                                        color: themeSwitched
                                                            ? Colors.white
                                                            : Colors.indigo,
                                                        size: 20,
                                                      ),
                                                      onPressed: () {
                                                        fontSizeMax();
                                                      }),
                                                  widget._newsItem
                                                              .getNewsTextDirection() ==
                                                          TextDirection.rtl
                                                      ? Row()
                                                      : IconButton(
                                                          icon: Icon(
                                                            isPlaying
                                                                ? Icons.stop
                                                                : Icons
                                                                    .record_voice_over_sharp,
                                                            color: themeSwitched
                                                                ? Colors.white
                                                                : Colors.indigo,
                                                            size: 20,
                                                          ),
                                                          onPressed: () {
                                                            //
                                                            isPlaying
                                                                ? _stop()
                                                                : _speak(widget
                                                                    ._newsItem
                                                                    .text);
                                                          }),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onScaleStart:
                                          (ScaleStartDetails details) {
                                        _previousScale = _scale;
                                      },
                                      onScaleUpdate:
                                          (ScaleUpdateDetails details) {
                                        setState(() {
                                          _scale =
                                              _previousScale * details.scale;
                                        });
                                      },
                                      onScaleEnd: (ScaleEndDetails details) {
                                        _previousScale = null;
                                      },
                                      child: Transform(
                                        transform: Matrix4.diagonal3(Vector3(
                                            _scale.clamp(1.0, 5.0),
                                            _scale.clamp(1.0, 5.0),
                                            _scale.clamp(1.0, 5.0))),
                                        alignment: FractionalOffset.center,
                                        child: Text(
                                          widget._newsItem.text,
                                          style: TextStyle(
                                            fontFamily: 'Jazeera',
                                            color: themeSwitched
                                                ? Colors.white
                                                : Colors.indigo,
                                            fontWeight: FontWeight.w600,
                                            fontSize: fontSize,
                                          ),
                                          textAlign: widget._newsItem
                                              .getNewsTextAlign(),
                                          textDirection: widget._newsItem
                                              .getNewsTextDirection(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    shareToSocialMedia(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                    itemCount: 1 //selectNews.ingredients.length,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget shareToSocialMedia() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.share,
                color: themeSwitched ? Colors.red : Colors.red,
                size: 20,
              ),
              onPressed: () async {
                final RenderBox box = context.findRenderObject();
                // Share.shareFiles();
                await Share.share(
                    "تم النشر بواسطة تطبيق خبر للتحميل اضغط هنا .." +
                        widget._newsItem.title +
                        widget._newsItem.url,
                    subject: widget._newsItem.title +
                        widget._newsItem.getNewsImage(),
                    sharePositionOrigin:
                        box.localToGlobal(Offset.zero) & box.size);
                // await Share.image(
                //     path: 'file://$filePath/s.jpg',
                //     title: "share it!",
                //     text: "share flutter",
                //     mimeType: ShareType.TYPE_IMAGE)
                //     .share(sharePositionOrigin: cardRect);
              },
            ),
          ],
        ),
        Column(
          children: <Widget>[
            Text("شارك الخبر",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Jazeera',
                  color: themeSwitched ? Colors.white : Colors.indigo,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      ],
    );
  }
}
