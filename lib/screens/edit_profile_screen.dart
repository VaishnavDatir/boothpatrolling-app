import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';

import '../model/logger_info.dart';

import '../helpers/theme_helper.dart';
import '../helpers/dialogBox.dart';
import '../helpers/screen_transition.dart';

import '../widgets/officer_form_widget.dart';

import '../screens/edit_password.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/EditProfileScreen';
  final Map<String, dynamic> userInfos;
  EditProfileScreen({this.userInfos});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _isLoading = false;
  final _editOfficerFormKey = GlobalKey<FormState>();
  LoggerInfo editUser = LoggerInfo();

  File _officerImg;

  void _pickedImg(File img) {
    _officerImg = img;
  }

  _svaeAndEditInfo() async {
    FocusScope.of(context).unfocus();
    if (!_editOfficerFormKey.currentState.validate()) {
      print("Edit officer info Invalid");
      return;
    }
    // setState(() {
    //   _isLoading = true;
    // });
    DialogBox().showLoaderDialog(context);
    try {
      _editOfficerFormKey.currentState.save();

      await FirebaseFirestore.instance
          .collection("officers")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update({
        "name": editUser.loggerName,
        "mobileno": editUser.loggerMobNo,
        "stationCode": editUser.loggerStationCode,
        "dob": editUser.loggerDob,
      });
      if (_officerImg != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child("officer_imgs")
            .child(FirebaseAuth.instance.currentUser.uid + ".jpg");
        await ref.putFile(_officerImg);

        String oiu = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection("officers")
            .doc(FirebaseAuth.instance.currentUser.uid)
            .update({"officerImgURL": oiu});
      }
      Fluttertoast.showToast(
        msg: "Information successfully updated",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green[700],
        textColor: Colors.white,
        fontSize: 14,
      );
    } on FirebaseException catch (err) {
      DialogBox().loaderDialogPop(context);
      print("firestore error:");
      print(err);
      DialogBox().dialogBox(context, "Error", err.message, Icons.error);
    } catch (error) {
      DialogBox().loaderDialogPop(context);

      print("main error");
      print(error);
    }
    DialogBox().loaderDialogPop(context);

    // setState(() {
    //   _isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "Edit Profile",
          style: Theme.of(context)
              .textTheme
              .headline1
              .copyWith(color: Colors.white, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.only(top: 10.0, right: 15, left: 15, bottom: 20.0),
        child: Column(
          children: [
            OfficerForm(
                _editOfficerFormKey, widget.userInfos, editUser, _pickedImg),
            SizedBox(height: 15),
            _isLoading
                ? CircularProgressIndicator()
                : Wrap(
                    spacing: 30,
                    alignment: WrapAlignment.center,
                    children: [
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(SlideLRRoute(page: EditPasswordScreen()));
                        },
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: ColorConstant.deepBlue,
                              width: 1,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Change password",
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .copyWith(
                                      color: ColorConstant.deepBlue,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                      FlatButton(
                        onPressed: _svaeAndEditInfo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                        color: ColorConstant.deepBlue,
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          child: Text(
                            "Save",
                            maxLines: 1,
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
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
