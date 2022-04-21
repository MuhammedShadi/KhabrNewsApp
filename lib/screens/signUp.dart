import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khbr_app/model/create_user.dart';
import 'package:khbr_app/providers/category_provider.dart';
import 'package:khbr_app/providers/login_provider.dart';
import 'package:khbr_app/providers/signUp_provider.dart';
import 'package:khbr_app/screens/choices_categories.dart';
import 'package:khbr_app/screens/home.dart';
import 'package:khbr_app/widgets/tabs_screen.dart';

SignUpProvider _signUpProvider = new SignUpProvider();
LoginProvider _loginProvider = new LoginProvider();
CategoryProvider _categoryProvider = new CategoryProvider();

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signUp';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  Map<String, String> _authData = {
    'fName': '',
    'lName': '',
    'email': '',
    'userName': '',
    'password': '',
  };

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _obscureTextConfirm = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Center(
          child: new Text(
            'تسجيل عضوية جديدة ',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 20, fontFamily: 'Jazeera'),
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routName);
            }),
      ),
      // endDrawer: AppDrawer(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            color: Theme.of(context).primaryColor,
            width: double.infinity,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.person_add_alt,
                        size: 60,
                        color: Colors.white,
                      ),
                      Text(
                        'الإسم',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Jazeera'),
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                          controller: _firstNameController,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontSize: 18, color: Colors.black),
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            hintText: 'الإسم الأول',
                            prefixIcon: Icon(
                              Icons.border_color,
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
                          validator: (value) {
                            if (value.isEmpty ||
                                value.contains('@') ||
                                value.contains('123')) {
                              return 'من فضلك أدخل بيانات صحيحة';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _authData['fName'] = value;
                          }),
                      SizedBox(height: 5),
                      TextFormField(
                          controller: _lastNameController,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontSize: 18, color: Colors.black),
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            hintText: 'الإسم الثاني',
                            prefixIcon: Icon(
                              Icons.border_color,
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
                          validator: (value) {
                            if (value.isEmpty ||
                                value.contains('@') ||
                                value.contains('123')) {
                              return 'من فضلك أدخل بيانات صحيحة';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _authData['lName'] = value;
                          }),
                      SizedBox(height: 5),
                      Text(
                        'المعلومات الشخصية',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Jazeera'),
                      ),
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
                            hintText: 'البريد الإلكتروني',
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
                            _authData['email'] = value;
                          }),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: _userNameController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: 'إسم المُستخدم',
                          prefixIcon: Icon(
                            Icons.border_color,
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
                          _authData['username'] = value;
                        },
                        validator: (value) {
                          if (value.isEmpty ||
                              value.contains('@') ||
                              value.contains('123')) {
                            return 'من فضلك أدخل بيانات صحيحة';
                          }
                          return null;
                        },
                      ),
                      Text(
                        'كلمة المرور',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Jazeera'),
                      ),
                      TextFormField(
                          obscureText: _obscureText,
                          controller: _passwordController,
                          validator: (value) {
                            if (value.isEmpty || value.length < 5) {
                              return 'كلمة مرور صغيرة ';
                            }
                            return null;
                          },
                          style: TextStyle(fontSize: 18, color: Colors.black),
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            prefixIcon: _obscureText
                                ? IconButton(
                                    icon: Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: Colors.indigo,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = false;
                                      });
                                    },
                                  )
                                : IconButton(
                                    icon: Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.indigo,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = true;
                                      });
                                    },
                                  ),
                            contentPadding: const EdgeInsets.all(5),
                            hintText: 'كلمة المرور',
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
                            _authData['password'] = value;
                          }),
                      SizedBox(height: 5),
                      TextFormField(
                        obscureText: _obscureTextConfirm,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'كلمة مرور غير متطابقة';
                          }
                          return null;
                        },
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          prefixIcon: _obscureTextConfirm
                              ? IconButton(
                                  icon: Icon(
                                    Icons.remove_red_eye_outlined,
                                    color: Colors.indigo,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureTextConfirm = false;
                                    });
                                  },
                                )
                              : IconButton(
                                  icon: Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.indigo,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureTextConfirm = true;
                                    });
                                  },
                                ),
                          contentPadding: const EdgeInsets.all(5),
                          hintText: 'تأكيد كلمة المرور',
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
                      SizedBox(height: 5),
                      // ignore: deprecated_member_use
                      FlatButton(
                        child: Text(
                          " تسجيل عضوية جديدة",
                          style: TextStyle(fontSize: 20, fontFamily: 'Jazeera'),
                        ),
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        padding: const EdgeInsets.all(5),
                        textColor: Colors.white,
                        onPressed: () async {
                          NewUser _newsUer = new NewUser(
                              _firstNameController.text,
                              _lastNameController.text,
                              _userNameController.text,
                              _emailController.text,
                              _passwordController.text);
                          bool resp =
                              await _signUpProvider.signUpUser(_newsUer);
                          if (resp == true) {
                            Future.delayed(const Duration(milliseconds: 2500),
                                () async {
                              bool loginResp =
                                  await _loginProvider.loginFirstTime(
                                      _userNameController.text,
                                      _passwordController.text);
                              if (loginResp == true) {
                                Future.delayed(
                                    const Duration(milliseconds: 3500),
                                    () async {
                                  Fluttertoast.showToast(
                                      msg:
                                          "لابد من الإشتراك في بعض المصادر حتى تظهر لك الأخبار اضغط على التصنيفات",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 3,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                });
                                List checkCate = await _categoryProvider
                                    .getCategorySubscribed();
                                if (checkCate.length == 0) {
                                  Navigator.of(context).pushReplacementNamed(
                                      ChoicesCategories.routName);
                                } else {
                                  Navigator.of(context).pushReplacementNamed(
                                      TabsScreen.routName);
                                }
                              }
                            });
                          } else {}
                          _submit();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
  }
}
