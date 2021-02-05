import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../helpers/theme_helper.dart';
import '../../helpers/dialogBox.dart';

import '../../model/logger_info.dart';

import '../../widgets/officer_form_widget.dart';

class AddOfficer extends StatefulWidget {
  static const routeName = '/AddOfficer';
  final Map<String, dynamic> userInfo;
  AddOfficer({this.userInfo});
  @override
  _AddOfficerState createState() => _AddOfficerState();
}

class _AddOfficerState extends State<AddOfficer> {
  // final _auth = FirebaseAuth.instance;

  UserCredential userCredential;

  bool _personalInfoFilled = false;
  bool _isLoading = false;

  String _officerType = "officer";
  File _officerImg;

  final _addOfficerFormKey = GlobalKey<FormState>();
  LoggerInfo addUser = LoggerInfo();

  void _pickedImg(File img) {
    _officerImg = img;
  }

  FirebaseApp app;

  _saveAndSubmitInformation() async {
    FocusScope.of(context).unfocus();
    if (!_addOfficerFormKey.currentState.validate()) {
      print("ADD officer info Invalid");
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });
      app = await Firebase.initializeApp(
          name: 'Secondary', options: Firebase.app().options);
      try {
        _addOfficerFormKey.currentState.save();
        userCredential = await FirebaseAuth.instanceFor(app: app)
            .createUserWithEmailAndPassword(
          email: addUser.loggerMobNo + "@boothpatrolling.com",
          password: addUser.loggerDob.toString().replaceAll("-", ""),
        );
        await FirebaseFirestore.instance
            .collection("officers")
            .doc(userCredential.user.uid)
            .set({
          "name": addUser.loggerName,
          "mobileno": addUser.loggerMobNo,
          "stationCode": addUser.loggerStationCode,
          "dob": addUser.loggerDob,
          "type": _officerType,
          "uid": userCredential.user.uid,
          "addedBy": widget.userInfo["uid"],
          "officerImgURL": "",
          "onDuty": false
        });
        if (_officerImg != null) {
          // final ref = FirebaseStorage.instance
          //     .ref()
          //     .child("officer_imgs")
          //     .child(userCredential.user.uid + ".jpg");
          // await ref.putFile(addUser.loggerImg);
          // print("img uploaded for " + userCredential.user.uid.toString());

          // String oiu = await ref.getDownloadURL();
          // await FirebaseFirestore.instance
          //     .collection("officers")
          //     .doc(userCredential.user.uid)
          //     .update({"officerImgURL": oiu});

          print("There is image");
/* 
          final ref = await FirebaseStorage.instance
              .ref()
              .child("officer_imgs")
              .child(userCredential.user.uid + ".jpg");
          await ref.putFile(addUser.loggerImg);
          print("img uploaded for " + userCredential.user.uid.toString());

          String oiu = await ref.getDownloadURL();
          await FirebaseFirestore.instance
              .collection("officers")
              .doc(userCredential.user.uid)
              .update({"officerImgURL": oiu}); */

          final ref = FirebaseStorage.instance
              .ref()
              .child("officer_imgs")
              .child(userCredential.user.uid + ".jpg");
          await ref.putFile(_officerImg);

          String oiu = await ref.getDownloadURL();
          await FirebaseFirestore.instance
              .collection("officers")
              .doc(userCredential.user.uid)
              .update({"officerImgURL": oiu});
          print("Img Complete");
        }
        Fluttertoast.showToast(
          msg: "${addUser.loggerName} successfully added",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green[700],
          textColor: Colors.white,
          fontSize: 14,
        );
      } catch (e) {
        print("Firebase secondary try:");
        print(e);
        throw (e);
      } finally {
        await app.delete();
      }

      setState(() {
        _personalInfoFilled = true;
        _isLoading = false;
      });
    } on FirebaseAuthException catch (err) {
      setState(() {
        _personalInfoFilled = false;
        _isLoading = false;
      });
      var errmsg = "An error occured, please check filled information";

      if (err.message != null) {
        errmsg =
            err.message.toString().replaceAll("email address", "Mobile Number");
      }
      DialogBox().dialogBox(context, "Error", errmsg, Icons.error);
    } catch (err) {
      print("ADD OFFICER ERROR: $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "Add officer",
          style: Theme.of(context)
              .textTheme
              .headline1
              .copyWith(color: Colors.white, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.only(top: 10.0, right: 15, left: 15),
        child: Column(
          children: [
            OfficerForm(_addOfficerFormKey, null, addUser, _pickedImg),
            SizedBox(height: 15),
            ListTile(
              title: Text(
                "Officer Type",
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(color: Colors.black, fontSize: 18),
              ),
              trailing: DropdownButton(
                value: _officerType,
                items: [
                  DropdownMenuItem(value: "officer", child: Text("Officer")),
                  DropdownMenuItem(value: "admin", child: Text("Admin"))
                ],
                onChanged: (value) {
                  setState(() {
                    _officerType = value;
                  });
                },
              ),
            ),
            _isLoading
                ? CircularProgressIndicator()
                : _personalInfoFilled
                    ? LoginInfoCardWidget(
                        officerName: addUser.loggerName.toString(),
                        officerMobileNo: addUser.loggerMobNo..toString(),
                        officerDOB: addUser.loggerDob..toString())
                    : FlatButton(
                        minWidth: double.infinity,
                        onPressed: _saveAndSubmitInformation,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1.0),
                        ),
                        color: ColorConstant.deepBlue,
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          child: Text(
                            "Save",
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
        ),
      ),
    );
  }
}

class LoginInfoCardWidget extends StatelessWidget {
  final String officerName;
  final String officerMobileNo;
  final String officerDOB;
  LoginInfoCardWidget(
      {@required this.officerName,
      @required this.officerMobileNo,
      @required this.officerDOB});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          children: [
            Text(
              "Login Information",
              style: Theme.of(context).textTheme.headline1.copyWith(
                  color: ColorConstant.deepBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 15),
            Wrap(
              children: [
                Text(
                  "Mobile Number:",
                  style: Theme.of(context).textTheme.headline1.copyWith(
                      color: ColorConstant.deepBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 25,
                ),
                Text(
                  officerMobileNo.toString(),
                  style: Theme.of(context).textTheme.headline1.copyWith(
                      color: ColorConstant.deepBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Wrap(
              children: [
                Text(
                  "Password:",
                  style: Theme.of(context).textTheme.headline1.copyWith(
                      color: ColorConstant.deepBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 25,
                ),
                Text(
                  officerDOB.toString().replaceAll("-", ""),
                  style: Theme.of(context).textTheme.headline1.copyWith(
                      color: ColorConstant.deepBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                print("share");
                final RenderBox box = context.findRenderObject();
                final String message =
                    "Hello $officerName,\nYour account has been created on Booth Patrolling\n\n";
                final String loginInfo =
                    "The login information is as follows:\nMobile No.: $officerMobileNo\nPassword: ${officerDOB.toString().replaceAll("-", "")}";
                final String endmsg =
                    "\n\nPlease visit the Booth Patrolling app and complete your profile.";
                Share.share(message + loginInfo + endmsg,
                    subject: "Booth Patrolling Login Info",
                    sharePositionOrigin:
                        box.localToGlobal(Offset.zero) & box.size);
              },
            )
          ],
        ),
      ),
    );
  }
}
