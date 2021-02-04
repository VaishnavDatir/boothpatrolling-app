import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../helpers/theme_helper.dart';
import '../helpers/dialogBox.dart';

class EditPasswordScreen extends StatefulWidget {
  static const routeName = '/ChangePassword';

  @override
  _EditPasswordScreenState createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  bool _isLoading = false;

  final _passwordChangeFormKey = GlobalKey<FormState>();

  final _password = TextEditingController();

  final _focusPassword = FocusNode();

  final _conformPassword = TextEditingController();

  final _focusConformPassword = FocusNode();

  @override
  Widget build(BuildContext context) {
    _changePassword() async {
      FocusScope.of(context).unfocus();
      if (!_passwordChangeFormKey.currentState.validate()) {
        return;
      }
      if (_password.text != _conformPassword.text) {
        dialogBox(
            context, "Password Error", "Password does not match", Icons.error);
        _password.text = "";
        _conformPassword.text = "";
        FocusScope.of(context).requestFocus(_focusPassword);
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        User currentUser = FirebaseAuth.instance.currentUser;
        await currentUser.updatePassword(_conformPassword.text.toString());
        Fluttertoast.showToast(
          msg: "Password has been successfully changed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green[700],
          textColor: Colors.white,
          fontSize: 14,
        );
        _password.text = "";
        _conformPassword.text = "";
      } on FirebaseException catch (err) {
        dialogBox(context, "Password Error", err.message, Icons.error);
        _password.text = "";
        _conformPassword.text = "";
      } catch (er) {
        print("Password Change Error:");
        print(er);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "Change Password",
          style: Theme.of(context)
              .textTheme
              .headline1
              .copyWith(color: Colors.white, fontSize: 20),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 10.0, right: 15, left: 15),
          child: Form(
            key: _passwordChangeFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Fill the following details",
                    style: Theme.of(context).textTheme.headline2.copyWith(
                        color: ColorConstant.deepBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _password,
                  focusNode: _focusPassword,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "New Password"),
                  validator: (value) {
                    if (value.isEmpty || value.length < 6) {
                      return 'Please enter password with atleast 6 characters';
                    }
                    return null;
                  },
                  onFieldSubmitted: (value) => FocusScope.of(context)
                      .requestFocus(_focusConformPassword),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _conformPassword,
                  focusNode: _focusConformPassword,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Confirm Password"),
                  validator: (value) {
                    if (value.isEmpty || value.length < 6) {
                      return 'Please enter password with atleast 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                _isLoading
                    ? CircularProgressIndicator()
                    : Align(
                        alignment: Alignment.centerRight,
                        child: FlatButton(
                          onPressed: _changePassword,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          color: ColorConstant.deepBlue,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            child: Text(
                              "Change the password",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .copyWith(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
