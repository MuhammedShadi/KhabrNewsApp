import 'package:flutter/material.dart';
import 'package:khbr_app/screens/login.dart';
import 'package:khbr_app/screens/signUp.dart';
import 'login.dart';

class HomeScreen extends StatefulWidget {
  static const routName = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15),
        color: Theme.of(context).primaryColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'مرحباً بك في تطبيق خبر ',
              style: TextStyle(
                  fontSize: 30, color: Colors.white, fontFamily: 'Jazeera'),
            ),
            Text(
              ' الخبر لحد عندك',
              style: TextStyle(
                  fontSize: 25, color: Colors.white, fontFamily: 'Jazeera'),
            ),
            SizedBox(height: 20),
            // ignore: deprecated_member_use
            FlatButton(
              child: Text(
                "تسجيل دخول",
                style: TextStyle(fontSize: 20, fontFamily: 'Jazeera'),
              ),
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white, width: 2),
              ),
              padding: const EdgeInsets.all(10),
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(LoginScreen.routeName);
              },
            ),
            SizedBox(height: 10),
            // ignore: deprecated_member_use
            FlatButton(
              child: Text(
                "تسجيل عضوية جديدة",
                style: TextStyle(fontSize: 20, fontFamily: 'Jazeera'),
              ),
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white, width: 2),
              ),
              padding: const EdgeInsets.all(5),
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(SignUpScreen.routeName);
              },
            ),
            SizedBox(height: 5),
            // FlatButton(
            //   child: Container(
            //     width: 140,
            //     height: 30,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         Container(
            //             decoration: BoxDecoration(
            //               color: Colors.blueAccent,
            //               border: Border.all(
            //                 color: Colors.white,
            //                 width: 1.0,
            //               ),
            //               borderRadius: BorderRadius.circular(5),
            //             ),
            //             child: Icon(Typicons.social_facebook, size: 30)),
            //         SizedBox(width: 10),
            //         Text(
            //           "Facebook",
            //           style: TextStyle(
            //               fontWeight: FontWeight.bold,
            //               fontSize: 20,
            //               fontFamily: 'Jazeera'),
            //         ),
            //       ],
            //     ),
            //   ),
            //   shape: OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(10),
            //     borderSide: BorderSide(color: Colors.white, width: 2),
            //   ),
            //   padding: const EdgeInsets.all(5),
            //   textColor: Colors.white,
            //   onPressed: () {
            //     authenticate();
            //     //facebookTest();
            //     // _login();
            //     //fetchFiles();
            //     // getFacebookAccess();
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
