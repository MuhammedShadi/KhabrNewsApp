import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:khbr_app/providers/sh_prefs.dart';
import 'package:khbr_app/providers/user_provider.dart';
import 'dart:io';

final TextEditingController _fNameController = TextEditingController();
final TextEditingController _lNameController = TextEditingController();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final TextEditingController _newPasswordController = TextEditingController();
final TextEditingController _newPasswordControllerConfirm =
    TextEditingController();
var apiUrl = 'https://dev.arapi.host';
var _dio = Dio();
String imageCat = 'assets/images/khbar.png';
String imageCatOff = 'assets/images/khbaroff.png';
UserProvider _userProvider = new UserProvider();

class ProfileScreen extends StatefulWidget {
  static const routName = "/profile";
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userOrganization = " ";
  String name = " ";
  String departments = '';
  String email = '';
  String fName = '';
  String lName = '';
  bool hasDeletePermissions = false;
  bool hasChecked = false;
  void checkUserPermissions() async {
    String userPermission =
        await ShPrefs.instance.getStringValue("userspermissions");
    if (userPermission.contains("delete-own-user")) {
      hasDeletePermissions = true;
    } else {
      hasDeletePermissions = false;
    }
  }

  userProfile() async {
    userOrganization = await ShPrefs.instance.getStringValue('organization');
    name = await ShPrefs.instance.getStringValue('userName');
    departments = await ShPrefs.instance.getStringValue('departments');
    email = await ShPrefs.instance.getStringValue('email');
    fName = await ShPrefs.instance.getStringValue('fname');
    lName = await ShPrefs.instance.getStringValue('lname');
    hasChecked = true;
    setState(() {});
    return userOrganization;
  }

  bool themeSwitched = false;
  dynamic themeColor() {
    if (themeSwitched) {
      return Colors.grey[850];
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    if (hasChecked == false) {
      userProfile();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor(),
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
        title: new Center(
          child: new Text(
            '$nameالحساب الشخصي ',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 20, fontFamily: 'Jazeera'),
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("/index");
            }),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: themeSwitched
                    ? [Colors.grey[850], Colors.black87]
                    : [Colors.indigo, Colors.indigoAccent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.5, 0.9],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    hasDeletePermissions == true
                        ? CircleAvatar(
                            backgroundColor: Colors.white70,
                            minRadius: 40.0,
                            child: CircleAvatar(
                              radius: 30.0,
                              backgroundImage: AssetImage(
                                  themeSwitched ? imageCatOff : imageCat),
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.white70,
                            minRadius: 60.0,
                            child: CircleAvatar(
                              radius: 55.0,
                              backgroundImage: AssetImage(
                                  themeSwitched ? imageCatOff : imageCat),
                            ),
                          ),
                  ],
                ),
                Text(
                  '$name',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Jazeera',
                  ),
                ),
                Text(
                  '$departments'.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Jazeera',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 0.2),
          Container(
            color: themeColor(),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: themeSwitched ? Colors.grey[850] : Colors.indigo,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SetPassWord()),
                        );
                      },
                      child: ListTile(
                        title: Text(
                          'تغيير كلمة المرور',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: 'Jazeera',
                          ),
                        ),
                        subtitle: Icon(
                          Icons.cached,
                          size: 34,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                // Expanded(
                //   child: Container(
                //     color:
                //         themeSwitched ? Colors.grey[850] : Colors.indigoAccent,
                //     child: InkWell(
                //       onTap: () {
                //         showModalBottomSheet(
                //             context: context,
                //             builder: ((build) => imageBottomSheet()));
                //       },
                //       child: ListTile(
                //         title: Text(
                //           'تغيير صورة الحساب',
                //           textAlign: TextAlign.center,
                //           style: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             fontSize: 20,
                //             color: Colors.white,
                //             fontFamily: 'Jazeera',
                //           ),
                //         ),
                //         subtitle: Icon(
                //           Icons.add_a_photo_outlined,
                //           size: 34,
                //           color: Colors.white,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            color: themeColor(),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'الإسم الأول',
                    style: TextStyle(
                      color: themeSwitched ? Colors.white : Colors.indigo,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Jazeera',
                    ),
                    textAlign: TextAlign.end,
                  ),
                  trailing: Icon(Icons.person,
                      color: themeSwitched ? Colors.white : Colors.indigo,
                      size: 40),
                  subtitle: Text(
                    '$fName',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: themeSwitched ? Colors.white : Colors.black,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
                ListTile(
                  title: Text(
                    'الإسم الثاني',
                    style: TextStyle(
                      color: themeSwitched ? Colors.white : Colors.indigo,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Jazeera',
                    ),
                    textAlign: TextAlign.end,
                  ),
                  trailing: Icon(Icons.perm_contact_cal,
                      color: themeSwitched ? Colors.white : Colors.indigo,
                      size: 40),
                  subtitle: Text(
                    '$lName',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: themeSwitched ? Colors.white : Colors.black,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
                ListTile(
                  title: Text(
                    'البريد الإلكتروني',
                    style: TextStyle(
                      color: themeSwitched ? Colors.white : Colors.indigo,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Jazeera',
                    ),
                    textAlign: TextAlign.end,
                  ),
                  trailing: Icon(Icons.mail,
                      color: themeSwitched ? Colors.white : Colors.indigo,
                      size: 40),
                  subtitle: Text(
                    '$email',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: themeSwitched ? Colors.white : Colors.black,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
                hasDeletePermissions == true
                    ? SizedBox(height: 0)
                    : SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    hasDeletePermissions == true
                        ? Expanded(
                            child: MaterialButton(
                              onPressed: () {
                                _userProvider.deleteUserAccount(name, true);
                              },
                              child: Text(
                                "مسح الحساب",
                                style: TextStyle(
                                  fontFamily: 'Jazeera',
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                              color:
                                  themeSwitched ? Colors.black : Colors.indigo,
                            ),
                          )
                        : Row(),
                    SizedBox(width: 3),
                    hasDeletePermissions == true
                        ? Expanded(
                            child: MaterialButton(
                              onPressed: () {
                                _userProvider.deleteUserAccount(name, false);
                              },
                              child: Text(
                                "وقف الحساب ",
                                style: TextStyle(
                                  fontFamily: 'Jazeera',
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                              color:
                                  themeSwitched ? Colors.black : Colors.indigo,
                            ),
                          )
                        : Row(),
                    hasDeletePermissions == true
                        ? SizedBox(width: 3)
                        : SizedBox(width: 0),
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserProfileDataUpdate()),
                          );
                        },
                        child: Text(
                          "تعديل الحساب ",
                          style: TextStyle(
                            fontFamily: 'Jazeera',
                            fontSize: 15,
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
          )
        ],
      ),
    );
  }

  Widget imageBottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Text(
            "قم بتحميل صورة",
            style: TextStyle(
              color: themeSwitched ? Colors.black : Colors.indigo,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Jazeera',
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ignore: deprecated_member_use
              FlatButton.icon(
                icon: Icon(
                  Icons.camera,
                  color: themeSwitched ? Colors.black : Colors.indigo,
                ),
                onPressed: () {
                  // takePhoto(ImageSource.camera);
                  // saveImage(_imageFile.path);
                },
                label: Text(
                  "من الكاميرا",
                  style: TextStyle(
                    color: themeSwitched ? Colors.black : Colors.indigo,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Jazeera',
                  ),
                ),
              ),
              SizedBox(width: 40),
              // ignore: deprecated_member_use
              FlatButton.icon(
                icon: Icon(
                  Icons.image,
                  color: themeSwitched ? Colors.black : Colors.indigo,
                ),
                onPressed: () {
                  // takePhoto(ImageSource.gallery);
                  // saveImage(_imageFile.path);
                },
                label: Text(
                  "من الاستوديو",
                  style: TextStyle(
                    color: themeSwitched ? Colors.black : Colors.indigo,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Jazeera',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UserProfileDataUpdate extends StatefulWidget {
  @override
  _UserProfileDataUpdateState createState() => _UserProfileDataUpdateState();
}

class _UserProfileDataUpdateState extends State<UserProfileDataUpdate> {
  String name = " ";
  bool themeSwitched = false;
  bool hasChecked = false;
  dynamic themeColor() {
    if (themeSwitched) {
      return Colors.grey[850];
    } else {}
  }

  getUserData() async {
    name = await ShPrefs.instance.getStringValue('userName');
    setState(() {});
    hasChecked = true;
  }

  @override
  @mustCallSuper
  // ignore: must_call_super
  void initState() {
    setState(() {
      getUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (hasChecked == false) {
      getUserData();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor(),
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
        title: new Center(
          child: new Text(
            '$name تعديل الحساب الشخصي ',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 20, fontFamily: 'Jazeera'),
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(ProfileScreen.routName);
            }),
      ),
      body: updateUserInfo(),
    );
  }

  Widget updateUserInfo() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(10),
        color:
            themeSwitched ? Colors.grey[850] : Theme.of(context).primaryColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
                child: Text(
              '$name  :إسم المستخدم '.toUpperCase(),
              style: TextStyle(
                  fontSize: 20, fontFamily: 'Jazeera', color: Colors.white),
            )),
            SizedBox(height: 10),
            TextFormField(
              controller: _fNameController,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 18, color: Colors.black),
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                prefixIcon: Icon(
                  Icons.border_color,
                  color: Colors.indigo,
                ),
                hintText: 'إسم اول جديد',
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
              controller: _lNameController,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 18, color: Colors.black),
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                prefixIcon: Icon(
                  Icons.border_color,
                  color: Colors.indigo,
                ),
                hintText: 'إسم ثاني جديد',
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
                controller: _emailController,
                style: TextStyle(fontSize: 18, color: Colors.black),
                textAlign: TextAlign.right,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'بريد غير صحيح';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: ' بريد إلكتروني جديد',
                  prefixIcon: Icon(
                    Icons.mail,
                    color: Colors.indigo,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onSaved: (value) {
                  // _authData['email'] = value;
                }),
            SizedBox(height: 10),
            // ignore: deprecated_member_use
            FlatButton(
              child: Text(
                "حفظ وإرسال",
                style: TextStyle(fontSize: 20, fontFamily: 'Jazeera'),
                textAlign: TextAlign.center,
              ),
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white, width: 2),
              ),
              padding: const EdgeInsets.all(10),
              textColor: Colors.white,
              onPressed: () async {
                var fName = _fNameController.text;
                var lName = _lNameController.text;
                var email = _emailController.text;
                // var dep = _departementsController.text;
                if (fName.length < 4)
                  Fluttertoast.showToast(
                      msg: "لا يمكن إستخدام إسم اقل من 4 أحرف",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                else if (lName.length < 4)
                  Fluttertoast.showToast(
                      msg: "لابد من إستخدام كلمة مرور أكبر من 4 رموز",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                else if (email.length < 4)
                  Fluttertoast.showToast(
                      msg: "لابد من إستخدام كلمة مرور أكبر من 4 رموز",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                else {
                  updateUserData(name, fName, lName, email);
                }
              },
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  updateUserData(
      String userName, String fName, String lName, String email) async {
    try {
      Dio dio = await getApiLogin();
      Response response = await dio.put(
          apiUrl +
              '/users/$userName?first_name=$fName&last_name=$lName&email=$email',
          options: Options(headers: {
            "accept": "application/json",
            "Authorization":
                "Bearer ${await ShPrefs.instance.getStringValue('access_token')}",
          }));

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "تم تغيير كلمة المرور بنجاح قم بتسجيل الدخول مرة أخرى",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        setState(() async {
          await ShPrefs.instance.setStringValue('email', email);
          await ShPrefs.instance.setStringValue('fname', fName);
          await ShPrefs.instance.setStringValue('lname', lName);
          Navigator.of(context).pushReplacementNamed(ProfileScreen.routName);
          _fNameController.clear();
          _lNameController.clear();
          _emailController.clear();
        });
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
        Fluttertoast.showToast(
            msg:
                "يجب أن تتكون كلمة المرور من 8 أحرف على الأقل ، ويجب أن تحتوي كلمة المرور على رقم واحد على الأقل ، ويجب أن تحتوي كلمة المرور على رمز واحد على الأقل من! # ٪ & '() * +، -.، -. / \\ ^ _ `{|} ~ @ ، يجب أن تحتوي كلمة المرور على حرف واحد كبير على الأقل (az) ، ويجب أن تحتوي كلمة المرور على حرف صغير واحد على الأقل (az)",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "من فضلك تأكد من إسم المستخدم و كلمة المرور",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (e.response.statusCode == 404) {
        Fluttertoast.showToast(
            msg: " إسم المستخدم غير موجود ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }
}

class SetPassWord extends StatefulWidget {
  @override
  _SetPassWordState createState() => _SetPassWordState();
}

class _SetPassWordState extends State<SetPassWord> {
  bool themeSwitched = false;
  bool _oldObscureText = true;
  bool _newObscureText = true;
  bool _newObscureTextConfirm = true;
  String name = '';
  bool hasChecked = false;
  dynamic themeColor() {
    if (themeSwitched) {
      return Colors.grey[850];
    } else {}
  }

  getUserData() async {
    name = await ShPrefs.instance.getStringValue('userName');
    setState(() {});
    hasChecked = true;
  }

  @override
  Widget build(BuildContext context) {
    if (hasChecked == false) {
      getUserData();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor(),
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
        title: new Center(
          child: new Text(
            ' $name  الحساب الشخصي ',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 20, fontFamily: 'Jazeera'),
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(ProfileScreen.routName);
            }),
      ),
      body: reSetUserPassWord(),
    );
  }

  Widget reSetUserPassWord() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(10),
        color:
            themeSwitched ? Colors.grey[850] : Theme.of(context).primaryColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                'تغيير كلمة المرور',
                style: TextStyle(
                    color: Colors.white, fontSize: 20, fontFamily: 'Jazeera'),
              ),
            ),
            Center(
              child: Text(
                '${name.toUpperCase()}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Jazeera'),
              ),
            ),
            SizedBox(height: 40),
            TextFormField(
              controller: _passwordController,
              obscureText: _oldObscureText,
              style: TextStyle(fontSize: 18, color: Colors.black),
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                hintText: 'أدخل  كلمة المرور القديمة',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: _oldObscureText
                    ? IconButton(
                        icon: Icon(
                          Icons.remove_red_eye_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          print('true:$_oldObscureText');
                          setState(() {
                            _oldObscureText = false;
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
                            print('false:$_oldObscureText');
                            _oldObscureText = true;
                          });
                        },
                      ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
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
            TextFormField(
              controller: _newPasswordController,
              obscureText: _newObscureText,
              style: TextStyle(fontSize: 18, color: Colors.black),
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                hintText: 'أدخل  كلمة المرور الجديدة',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: _newObscureText
                    ? IconButton(
                        icon: Icon(
                          Icons.remove_red_eye_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _newObscureText = false;
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
                            _newObscureText = true;
                          });
                        },
                      ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
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
            TextFormField(
              controller: _newPasswordControllerConfirm,
              obscureText: _newObscureTextConfirm,
              validator: (value) {
                if (value != _newPasswordController.text) {
                  return 'كلمة مرور غير متطابقة';
                }
                return null;
              },
              style: TextStyle(fontSize: 18, color: Colors.black),
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                hintText: 'تأكيد كلمة المرورالجديدة',
                prefixIcon: _newObscureTextConfirm
                    ? IconButton(
                        icon: Icon(
                          Icons.remove_red_eye_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _newObscureTextConfirm = false;
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
                            _newObscureTextConfirm = true;
                          });
                        },
                      ),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
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
                var oldassword = _passwordController.text;
                var newpassword = _newPasswordController.text;

                if (newpassword.length < 4)
                  Fluttertoast.showToast(
                      msg: "لابد من إستخدام كلمة مرور أكبر من 4 رموز",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                else if (oldassword.length < 4)
                  Fluttertoast.showToast(
                      msg: "لابد من إستخدام كلمة مرور أكبر من 4 رموز",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                else {
                  _userProvider.reSetPassword(oldassword, newpassword);
                  _newPasswordController.clear();
                  _passwordController.clear();
                  _newPasswordControllerConfirm.clear();
                }
              },
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

Future<Dio> getApiLogin() async {
  _dio.interceptors.clear();
  _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options) async {
        options.headers["Accept"] = 'application/json';
        return options;
      },
      onResponse: (Response response) {
        return response; // continue
      },
      onError: (DioError error) async {}));
  return _dio;
}
