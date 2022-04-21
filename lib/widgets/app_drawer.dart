import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khbr_app/screens/about_screen.dart';
import 'package:khbr_app/screens/allNews.dart';
import 'package:khbr_app/screens/choices_categories.dart';
import 'package:khbr_app/screens/contactUs_screen.dart';
import 'package:khbr_app/screens/home.dart';
import 'package:khbr_app/screens/index.dart';
import 'package:khbr_app/screens/profile.dart';
import 'package:khbr_app/screens/report_screen.dart';
import 'package:khbr_app/screens/subscribed_categories.dart';
import 'package:typicons_flutter/typicons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:khbr_app/providers/sh_prefs.dart';

String imageCat = 'assets/images/khbar.png';
String imageCatOff = 'assets/images/khbaroff.png';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool themeSwitched = false;
  bool hasReportPermission = false;
  bool hasChecked = false;
  dynamic themeColor() {
    if (themeSwitched) {
      return Colors.grey[850];
    } else {}
  }

  String name = " ";
  userName() async {
    name = await ShPrefs.instance.getStringValue('userName');
    setState(() {});
    return name;
  }

  void checkUserPermissions() async {
    String userPermission =
        await ShPrefs.instance.getStringValue("permissions");
    if (userPermission.contains("view-report")) {
      setState(() {
        hasReportPermission = true;
      });
    } else {
      setState(() {
        hasReportPermission = false;
      });
    }
    hasChecked = true;
    setState(() {});
  }

  @override
  @mustCallSuper
  // ignore: must_call_super
  void initState() {
    setState(() {
      checkUserPermissions();
      userName();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (hasChecked == false) {
      checkUserPermissions();
      userName();
    }
    return Drawer(
      child: Container(
        color: themeColor(),
        child: Column(
          children: <Widget>[
            AppBar(
              backgroundColor: themeColor(),
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
              title: Center(
                child: Text(
                  ' $name مرحباً بك '.toUpperCase(),
                  style: TextStyle(
                      fontFamily: 'Jazeera', fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
              automaticallyImplyLeading: false,
            ),
            InkWell(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height - 90,
                  child: Column(
                    children: [
                      // createDrawerHeader(),
                      ListTile(
                        leading: Icon(
                          Icons.person,
                          color: themeSwitched ? Colors.white : Colors.indigo,
                        ),
                        title: Text(
                          'حسابي',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Jazeera',
                            color: themeSwitched ? Colors.white : Colors.indigo,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacementNamed(ProfileScreen.routName);
                          // Navigator.pushNamed(context, "/contactus");
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.home,
                          color: themeSwitched ? Colors.white : Colors.indigo,
                        ),
                        title: Text(
                          'الرئيسية',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Jazeera',
                            color: themeSwitched ? Colors.white : Colors.indigo,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacementNamed(IndexScreen.routName);
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.sort,
                          color: themeSwitched ? Colors.white : Colors.indigo,
                        ),
                        title: Text(
                          'التصنيفات',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Jazeera',
                            color: themeSwitched ? Colors.white : Colors.indigo,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => ChoicesCategories()),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.favorite,
                          color: themeSwitched ? Colors.white : Colors.indigo,
                        ),
                        title: Text(
                          'المفضلة',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Jazeera',
                            color: themeSwitched ? Colors.white : Colors.indigo,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed(
                              SubscribedCategoriesScreen.routName);
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.access_alarms_outlined,
                          color: themeSwitched ? Colors.white : Colors.indigo,
                        ),
                        title: Text(
                          'جميع الأخبار',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Jazeera',
                            color: themeSwitched ? Colors.white : Colors.indigo,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacementNamed(AllNewsData.routName);
                        },
                      ),
                      hasReportPermission == true
                          ? ListTile(
                              leading: Icon(
                                Icons.apps_outlined,
                                color: themeSwitched
                                    ? Colors.white
                                    : Colors.indigo,
                              ),
                              title: Text(
                                'التقارير',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontFamily: 'Jazeera',
                                  color: themeSwitched
                                      ? Colors.white
                                      : Colors.indigo,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).pushReplacementNamed(
                                    ReportScreen.routName);
                              },
                            )
                          : Row(),
                      ListTile(
                        leading: Icon(
                          Icons.info,
                          color: themeSwitched ? Colors.white : Colors.indigo,
                        ),
                        title: Text(
                          'عن البرنامج',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Jazeera',
                            color: themeSwitched ? Colors.white : Colors.indigo,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacementNamed(AboutScreen.routName);
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.contact_phone,
                          color: themeSwitched ? Colors.white : Colors.indigo,
                        ),
                        title: Text(
                          'تواصل معنا',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Jazeera',
                            color: themeSwitched ? Colors.white : Colors.indigo,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacementNamed(ContactUsScreen.routName);
                          // Navigator.pushNamed(context, "/contactus");
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: themeSwitched ? Colors.white : Colors.indigo,
                        ),
                        title: Text(
                          'تسجيل خروج',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Jazeera',
                            color: themeSwitched ? Colors.white : Colors.indigo,
                          ),
                        ),
                        onTap: () {
                          logOut(context);
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Typicons.home,
                                  color:
                                      themeSwitched ? Colors.white : Colors.red,
                                  size: 20,
                                ),
                                onPressed: () {
                                  launch('https://khbr.app/index.html');
                                },
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Typicons.social_facebook,
                                  color: themeSwitched
                                      ? Colors.white
                                      : Colors.blueAccent,
                                  size: 20,
                                ),
                                onPressed: () {
                                  launch('https://khbr.app/index.html');
                                },
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Typicons.social_twitter,
                                  color: themeSwitched
                                      ? Colors.white
                                      : Colors.lightBlueAccent,
                                  size: 20,
                                ),
                                onPressed: () {
                                  launch('https://khbr.app/index.html');
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                ' 1.1 إصدار ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Jazeera',
                                  color: themeSwitched
                                      ? Colors.white
                                      : Colors.indigo,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future logOut(BuildContext context) async {
    ShPrefs.instance.removeValue('access_token');
    Navigator.of(context).pushReplacementNamed(HomeScreen.routName);
    Fluttertoast.showToast(
        msg: "تم تسجيل الخروج بنجاح شكراً لك ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Widget createDrawerHeader() {
    return Container(
      height: 70,
      child: DrawerHeader(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(themeSwitched ? imageCatOff : imageCat))),
          child: Stack(children: <Widget>[
            Positioned(
              bottom: 10.0,
              left: 16.0,
              child: Text(
                "$name ".toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Jazeera',
                ),
              ),
            ),
          ])),
    );
  }
}
