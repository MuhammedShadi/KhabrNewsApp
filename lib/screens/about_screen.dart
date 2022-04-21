import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khbr_app/providers/telegram_accounts_provider.dart';
import 'package:khbr_app/screens/index.dart';
import 'package:khbr_app/widgets/app_drawer.dart';

TelegramAccountProvider _telegramAccountProvider =
    new TelegramAccountProvider();

class AboutScreen extends StatelessWidget {
  static const routName = "/about";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "عن البرنامج",
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
                "تطبيق خبر ما هو ؟!",
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'Lalezar',
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Divider(color: Theme.of(context).primaryColor),
            Container(
              margin: const EdgeInsets.only(top: 10),
              //width: double.infinity,
              child: Text(
                "تطبيق خبر هو تطبيق لمتابعة الأخبار على مستوى العالم لحظة بلحظة ",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Lalezar',
                  color: Theme.of(context).primaryColor,
                  textBaseline: TextBaseline.ideographic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Divider(color: Theme.of(context).primaryColor),
          ],
        ),
      ),
      floatingActionButton: IconButton(
        icon: Icon(Icons.phone),
        onPressed: () async {
          _telegramAccountProvider.getAllTelegramAccounts();
        },
      ),
    );
  }
}
