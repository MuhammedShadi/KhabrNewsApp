import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khbr_app/providers/category_provider.dart';
import 'package:khbr_app/providers/login_provider.dart';
import 'package:khbr_app/screens/choices_categories.dart';
import 'package:khbr_app/screens/home.dart';
import 'package:khbr_app/screens/index.dart';
import 'package:khbr_app/screens/reSetPassword.dart';

CategoryProvider _categoryProvider = new CategoryProvider();

class LoginScreen extends StatefulWidget {
  static const routeName = '/model.login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginProvider newLoginProvider = new LoginProvider();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var url = 'https://dev.arapi.host/' + 'auth/access-tokens';
  bool isObscureTextValue = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Center(
          child: new Text(
            'تسجيل دخول  ',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 30, fontFamily: 'Jazeera'),
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routName);
            }),
      ),
      // endDrawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          color: Theme.of(context).primaryColor,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.indigo,
                ),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              ),
              Text(
                'الإسم',
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: Colors.white, fontSize: 20, fontFamily: 'Jazeera'),
              ),
              TextFormField(
                controller: _usernameController,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 18, color: Colors.black),
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  prefixIcon: Icon(
                    Icons.border_color,
                    color: Theme.of(context).primaryColor,
                  ),
                  hintText: 'إسم المُستخدم',
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty ||
                      value.contains('@') ||
                      value.contains('123')) {
                    return 'من فضلك أدخل بيانات صحيحة';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text(
                'كلمة المرور',
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: Colors.white, fontSize: 20, fontFamily: 'Jazeera'),
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: isObscureTextValue,
                style: TextStyle(fontSize: 18, color: Colors.black),
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  prefixIcon: isObscureTextValue
                      ? IconButton(
                          icon: Icon(
                            Icons.remove_red_eye_outlined,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              isObscureTextValue = false;
                            });
                          },
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              isObscureTextValue = true;
                            });
                          },
                        ),
                  contentPadding: const EdgeInsets.all(10),
                  hintText: 'كلمة المرور',
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty || value.length < 5) {
                    return 'كلمة المرور غير صحيحة';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              GestureDetector(
                child: Text(
                  "نسيت كلمة المرور ؟",
                  style: TextStyle(
                      fontFamily: 'Jazeera', fontSize: 20, color: Colors.white),
                  textAlign: TextAlign.right,
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(ReSetPassWord.routeName);
                },
              ),
              SizedBox(height: 10),
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
                padding: const EdgeInsets.all(5),
                textColor: Colors.white,
                onPressed: () async {
                  var username = _usernameController.text;
                  var password = _passwordController.text;
                  if (username.length < 4)
                    Fluttertoast.showToast(
                        msg: "لا يمكن إستخدام إسم اقل من 4 أحرف",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  else if (password.length < 4)
                    Fluttertoast.showToast(
                        msg: "لابد من إستخدام كلمة مرور أكبر من 4 رموز",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  else {
                    bool loginResponse = await newLoginProvider.loginFirstTime(
                        username, password);
                    if (loginResponse == true) {
                      List checkCate =
                          await _categoryProvider.getCategorySubscribed();
                      if (checkCate.length == 0) {
                        Fluttertoast.showToast(
                            msg:
                                "لابد من الإشتراك في بعض المصادر حتى تظهر لك الأخبار اضغط على التصنيفات",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.of(context)
                            .pushReplacementNamed(ChoicesCategories.routName);
                      } else {
                        Navigator.of(context)
                            .pushReplacementNamed(IndexScreen.routName);
                      }
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
