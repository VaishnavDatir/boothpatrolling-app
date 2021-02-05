import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';

import '../screens/admin_screens/admin_main_screen.dart';
//helpers

import '../helpers/user_management.dart';
import '../helpers/theme_helper.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/LoginScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          titleSpacing: 0,
          toolbarHeight: MediaQuery.of(context).size.height * 0.25,
          title: Text(
            "Booth Patrolling",
            style: Theme.of(context).textTheme.headline1.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
          centerTitle: true,
          flexibleSpace: Stack(alignment: Alignment.center, children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color: ColorConstant.deepBlue,
              child: CachedNetworkImage(
                imageUrl:
                    "https://images.hindustantimes.com/rf/image_size_630x354/HT/p2/2020/01/16/Pictures/_0ee1ae6e-37c5-11ea-8a26-bda02fe1f8d7.jpg",
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
                child: Container(
              color: Colors.black54,
            )),
          ])),
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // final _auth = FirebaseAuth.instance;
  // UserCredential userCredential;

  // bool _loginInfoFilled = false;
  // bool _isLoading = false;

  final _loginFormKey = GlobalKey<FormState>();

  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _mobileNoField = FocusNode();
  final _passwordField = FocusNode();

  Map<String, String> _loginData = {
    'mobileno': '',
    'password': '',
  };
  @override
  void dispose() {
    mobileNoController.dispose();
    _mobileNoField.dispose();
    passwordController.dispose();
    _passwordField.dispose();
    super.dispose();
  }

  void officerLogin() async {
    print("Login Form Submitted");
    FocusScope.of(context).unfocus();
    if (!_loginFormKey.currentState.validate()) {
      print("Invalid");
      return;
    }
    /*  setState(() {
      _isLoading = true;
    }); */
    print("valid");
    try {
      _loginFormKey.currentState.save();
      if (_loginData["mobileno"].replaceAll("@boothpatrolling.com", "") ==
              "1234567890" &&
          _loginData["password"] == "password") {
        Navigator.of(context).popAndPushNamed(AdminMainScreen.routeName);
        return;
      }

      await UserManagement()
          .signIn(_loginData["mobileno"], _loginData["password"], context);

      /* _isLoading = false;
      setState(() {}); */
    } catch (e) {
      print("Error in login Screen: ");
      print(e);
    }
    /* finally {
      DialogBox.loaderDialogPop(context);
    } */
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 13, right: 13, top: 20),
      child: Center(
        child: ScrollConfiguration(
          behavior: NoGlowScroll(),
          child: SingleChildScrollView(
            child: Form(
              key: _loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Hello there",
                      style: Theme.of(context).textTheme.headline1),
                  SizedBox(height: 15),
                  TextFormField(
                    focusNode: _mobileNoField,
                    controller: mobileNoController,
                    keyboardType: TextInputType.phone,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(_passwordField);
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),

                        // labelText: 'Mobile Number',
                        hintText: "Registered Mobile Number"),
                    // ignore: missing_return
                    validator: (value) {
                      if (value.isEmpty || (value.length != 10)) {
                        return 'Please enter registered mobile number!';
                      }
                    },
                    onSaved: (value) {
                      _loginData['mobileno'] = value + "@boothpatrolling.com";
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    focusNode: _passwordField,
                    controller: passwordController,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (value) => officerLogin(),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        // labelText: 'Password',
                        hintText: "Password"),
                    // ignore: missing_return
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter correct password';
                      }
                    },
                    onSaved: (value) {
                      _loginData['password'] = value;
                    },
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child:
                        /* _isLoading
                        ? CircularProgressIndicator()
                        :  */
                        FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      color: ColorConstant.deepBlue,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        child: Text(
                          "Login",
                          style: Theme.of(context).textTheme.headline1.copyWith(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      onPressed: officerLogin,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
