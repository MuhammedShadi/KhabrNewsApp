import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khbr_app/providers/user_provider.dart';
import 'package:khbr_app/screens/login.dart';

final TextEditingController _usernameController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

UserProvider _userProvider = new UserProvider();

class ReSetPassWord extends StatefulWidget {
  static const routeName = '/reset';
  @override
  _ReSetPassWordState createState() => _ReSetPassWordState();
}

class _ReSetPassWordState extends State<ReSetPassWord> {
  bool isObscureTextValue = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Center(
          child: new Text(
            'تطبيق خبر ',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 30, fontFamily: 'Jazeera'),
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
            }),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        color: Theme.of(context).primaryColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _usernameController,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 18, color: Colors.black),
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.border_color,
                  color: Colors.indigo,
                ),
                contentPadding: const EdgeInsets.all(10),
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
            TextFormField(
              controller: _passwordController,
              obscureText: isObscureTextValue,
              style: TextStyle(fontSize: 18, color: Colors.black),
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                hintText: 'كلمة المرور',
                filled: true,
                fillColor: Colors.white,
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
            // ignore: deprecated_member_use
            FlatButton(
              child: Text(
                "حفظ وإرسال",
                style: TextStyle(fontSize: 20, fontFamily: 'Jazeera'),
              ),
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white, width: 2),
              ),
              padding: const EdgeInsets.all(10),
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
                  _userProvider.changeUserPassword(username, password);
                }
              },
            ),
            SizedBox(height: 10),
            GestureDetector(
              child: Text(
                "لديك عضوية بالفعل ؟",
                style: TextStyle(
                    fontSize: 20, color: Colors.white, fontFamily: 'Jazeera'),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(LoginScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
