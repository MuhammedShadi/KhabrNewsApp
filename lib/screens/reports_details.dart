import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:khbr_app/model/report_item.dart';
import 'package:khbr_app/providers/report_provider.dart';
import 'package:khbr_app/screens/report_screen.dart';
import 'package:khbr_app/widgets/app_drawer.dart';

ReportProvider _reportProvider = new ReportProvider();
File file;

class ReportsDetails extends StatefulWidget {
  static const routName = '/reportItem';
  final ReportItem _reportItem;
  ReportsDetails(this._reportItem);
  @override
  _ReportsDetailsState createState() => _ReportsDetailsState();
}

class _ReportsDetailsState extends State<ReportsDetails> {
  String pdfassest = "assets/pdf/test.pdf";
  PDFDocument _doc;
  bool themeSwitched = false;
  bool _loading = false;
  bool isInit = true;

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
                widget._reportItem.name,
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
              Navigator.of(context).pushReplacementNamed(ReportScreen.routName);
            }),
      ),
      endDrawer: AppDrawer(),
      backgroundColor: themeColor(),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: isInit
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    widget._reportItem.title,
                                    style: TextStyle(
                                      fontFamily: 'Jazeera',
                                      fontSize: 20,
                                      color: themeSwitched
                                          ? Colors.white
                                          : Colors.indigo,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ],
                              ),
                              SizedBox(width: 70.0),
                              Column(
                                children: [
                                  Text(
                                    widget._reportItem.description,
                                    style: TextStyle(
                                      fontFamily: 'Jazeera',
                                      fontSize: 20,
                                      color: themeSwitched
                                          ? Colors.white
                                          : Colors.indigo,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ],
                              ),
                              SizedBox(width: 30.0),
                              Column(
                                children: [
                                  Text(
                                    widget._reportItem.name,
                                    style: TextStyle(
                                      fontFamily: 'Jazeera',
                                      fontSize: 20,
                                      color: themeSwitched
                                          ? Colors.white
                                          : Colors.indigo,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 90),
                          Center(
                            child: Icon(
                              Icons.description,
                              size: 300,
                              color:
                                  themeSwitched ? Colors.white : Colors.indigo,
                            ),
                          ),
                        ],
                      )
                    : _loading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : PDFViewer(document: _doc),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: MaterialButton(
                      onPressed: () {
                        loadFromURL();
                      },
                      child: Text(
                        "عرض التقرير",
                        style: TextStyle(
                          fontFamily: 'Jazeera',
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      color: themeSwitched ? Colors.black : Colors.indigo,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: MaterialButton(
                      onPressed: () {
                        _reportProvider.deleteReport(
                            widget._reportItem.id, widget._reportItem.name);
                        Navigator.of(context)
                            .pushReplacementNamed(ReportScreen.routName);
                      },
                      child: Text(
                        "مسح التقرير",
                        style: TextStyle(
                          fontFamily: 'Jazeera',
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      color: themeSwitched ? Colors.black : Colors.indigo,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  loadFromURL() async {
    setState(() {
      isInit = false;
      _loading = true;
    });
    file = await _reportProvider
        .postReportSelf(widget._reportItem.mostRecentVersion["self"]);
    _doc = await PDFDocument.fromFile(file);
    setState(() {
      _loading = false;
    });
  }
}
