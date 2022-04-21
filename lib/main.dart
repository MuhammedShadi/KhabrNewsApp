import 'package:flutter/material.dart';
import 'package:khbr_app/model/category_item.dart';
import 'package:khbr_app/model/news_item.dart';
import 'package:khbr_app/model/report_item.dart';
import 'package:khbr_app/screens/about_screen.dart';
import 'package:khbr_app/screens/allNews.dart';
import 'package:khbr_app/screens/choices_categories.dart';
import 'package:khbr_app/screens/contactUs_screen.dart';
import 'package:khbr_app/screens/home.dart';
import 'package:khbr_app/screens/index.dart';
import 'package:khbr_app/screens/login.dart';
import 'package:khbr_app/screens/news_details.dart';
import 'package:khbr_app/screens/profile.dart';
import 'package:khbr_app/screens/report_screen.dart';
import 'package:khbr_app/screens/reports_details.dart';
import 'package:khbr_app/screens/reSetPassword.dart';
import 'package:khbr_app/screens/search_screen.dart';
import 'package:khbr_app/screens/signUp.dart';
import 'package:khbr_app/screens/subscribed_categories.dart';
import 'package:khbr_app/widgets/tabs_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

List<CateItems> cateItems = [];
NewsItem _newsItem;
ReportItem _reportItem;
String imageCat = 'assets/images/khbar.png';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  Widget splashScreen() {
    return new SplashScreen(
      seconds: 3,
      navigateAfterSeconds: sharedPreferences.getString('access_token') == null
          ? HomeScreen()
          : IndexScreen(),
      title: new Text(
        'أهلاً و سهلاً بك في تطبيق خبر',
        style:
            TextStyle(fontFamily: 'Jazeera', color: Colors.white, fontSize: 20),
      ),
      loadingText: Text("من فضلك إنتظر",
          style: TextStyle(
              fontFamily: 'Jazeera', color: Colors.white, fontSize: 20)),
      // image: new Image.asset(
      //   imageCat,
      //   fit: BoxFit.cover,
      // ),
      gradientBackground: new LinearGradient(
          colors: [Colors.deepPurple, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight),
      // backgroundColor: Colors.indigo,
      styleTextUnderTheLoader: new TextStyle(),
      // photoSize: 100.0,
      loaderColor: Colors.white,
    );
  }

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: splashScreen(),
      //initialRoute: '/',
      routes: {
        //'/': (ctx) => HomeScreen(),
        LoginScreen.routeName: (ctx) => LoginScreen(),
        SignUpScreen.routeName: (ctx) => SignUpScreen(),
        HomeScreen.routName: (ctx) => HomeScreen(),
        NewsScreenDetails.routName: (ctx) => NewsScreenDetails(_newsItem),
        SubscribedCategoriesScreen.routName: (ctx) =>
            SubscribedCategoriesScreen(),
        TabsScreen.routName: (ctx) => TabsScreen(),
        AboutScreen.routName: (ctx) => AboutScreen(),
        IndexScreen.routName: (ctx) => IndexScreen(),
        ContactUsScreen.routName: (ctx) => ContactUsScreen(),
        ReportScreen.routName: (ctx) => ReportScreen(),
        ReportsDetails.routName: (ctx) => ReportsDetails(_reportItem),
        ChoicesCategories.routName: (ctx) => ChoicesCategories(),
        ReSetPassWord.routeName: (ctx) => ReSetPassWord(),
        ProfileScreen.routName: (ctx) => ProfileScreen(),
        AllNewsData.routName: (ctx) => AllNewsData(),
        SearchScreen.routName: (ctx) => SearchScreen(),
      },
    ),
  );
}
