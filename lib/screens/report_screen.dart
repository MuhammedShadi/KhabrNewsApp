import 'package:flutter/material.dart';
import 'package:khbr_app/model/report_item.dart';
import 'package:khbr_app/providers/report_provider.dart';
import 'package:khbr_app/screens/reports_details.dart';
import 'package:khbr_app/widgets/app_drawer.dart';

String imageCat = 'assets/images/khbar.png';
ReportProvider _reportProvider = new ReportProvider();
ScrollController _scrollController = ScrollController();
double offset = 0.0;

class ReportScreen extends StatefulWidget {
  static const routName = '/reports';
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  bool themeSwitched = false;
  dynamic themeColor() {
    if (themeSwitched) {
      return Colors.grey[850];
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        brightness: themeSwitched ? Brightness.light : Brightness.dark,
        backgroundColor: themeColor(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "التقارير",
                style: TextStyle(
                  fontFamily: 'Jazeera',
                  // color: Colors.red,
                ),
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
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
                Positioned(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.amberAccent,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("/index");
            }),
      ),
      endDrawer: AppDrawer(),
      backgroundColor: themeColor(),
      body: getReportsData(),
    );
  }

  Widget getReportsData() {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      clipBehavior: Clip.hardEdge,
      child: Container(
        color: Colors.black12,
        child: FutureBuilder(
          future: _reportProvider.getAllReports(),
          builder:
              (BuildContext context, AsyncSnapshot<List<ReportItem>> snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 80, top: 0),
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
                                  themeSwitched ? Colors.white : Colors.indigo,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 80, top: 0),
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
                                  themeSwitched ? Colors.white : Colors.indigo,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Scrollbar(
                controller: _scrollController,
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      height: MediaQuery.of(context).size.height - 80,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: snapshot.data.length,
                        scrollDirection: Axis.vertical,
                        //reverse: true,
                        shrinkWrap: true,
                        addAutomaticKeepAlives: false,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () async {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        ReportsDetails(snapshot.data[index])),
                              );
                            },
                            child: ClipRRect(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Card(
                                  color: themeColor(),
                                  margin: const EdgeInsets.only(
                                      left: 5.0,
                                      right: 5.0,
                                      bottom: 10.0,
                                      top: 0.0),
                                  elevation: 4.0,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: <Widget>[
                                          Stack(
                                            children: <Widget>[
                                              Icon(
                                                Icons.description,
                                                size: 100,
                                                color: themeSwitched
                                                    ? Colors.white
                                                    : Colors.amber,
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                Row(
                                                  // mainAxisAlignment:
                                                  //     MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 8.0),
                                                        child: Container(
                                                          child: Text(
                                                            snapshot.data[index]
                                                                .name,
                                                            style:
                                                                new TextStyle(
                                                              color: themeSwitched
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .indigo,
                                                              fontFamily:
                                                                  'Jazeera',
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            textAlign:
                                                                TextAlign.end,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  // mainAxisAlignment:
                                                  //     MainAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 8.0),
                                                        child: Container(
                                                          child: Text(
                                                            snapshot.data[index]
                                                                .title,
                                                            style:
                                                                new TextStyle(
                                                              color: themeSwitched
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .indigo,
                                                              fontFamily:
                                                                  'Jazeera',
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            textAlign:
                                                                TextAlign.end,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 8.0),
                                                        child: Container(
                                                          child: Text(
                                                            snapshot.data[index]
                                                                .author,
                                                            style:
                                                                new TextStyle(
                                                              color: themeSwitched
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .indigo,
                                                              fontFamily:
                                                                  'Jazeera',
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            textAlign:
                                                                TextAlign.end,
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
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
