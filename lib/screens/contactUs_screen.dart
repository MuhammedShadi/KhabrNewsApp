import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khbr_app/screens/index.dart';
import 'package:khbr_app/widgets/app_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

String imageCat = 'assets/images/khbar.png';

class ContactUsScreen extends StatelessWidget {
  static const routName = "/contactus";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "تواصل معنا",
            style: TextStyle(fontFamily: 'Jazeera'),
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(IndexScreen.routName);
            }),
      ),
      endDrawer: AppDrawer(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 80),
              child: Text(
                "يسعدنا تواصلك معنا ",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Lalezar',
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  //width: double.infinity,
                  child: SingleChildScrollView(
                    child: CircleAvatar(
                      backgroundColor: Colors.white70,
                      minRadius: 60.0,
                      child: CircleAvatar(
                        radius: 100.0,
                        backgroundImage: AssetImage(imageCat),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: InkWell(
                          onTap: () {
                            launch('https://khbr.app/index.html');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  launch('https://khbr.app/index.html');
                                },
                                icon: Icon(
                                  Icons.web_outlined,
                                  color: Colors.indigo,
                                  size: 40,
                                ),
                              ),
                              SizedBox(width: 30),
                              Text(
                                "الموقع الإلكتروني",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'Lalezar',
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        margin: EdgeInsets.fromLTRB(20, 8, 8, 16),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 90,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.indigo,
                              width: 2,
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
