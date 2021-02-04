import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './dialogBox.dart';

import '../screens/login_screen.dart';
import '../screens/admin_screens/admin_main_screen.dart';
import '../screens/officer_screens/officer_main_screen.dart';
import '../screens/loading_screen.dart';

class UserManagement {
  FirebaseAuth _auth = FirebaseAuth.instance;
  handleAuth() {
    return StreamBuilder<User>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingScreen();
        } else {
          if (snapshot.hasData) {
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("officers")
                  .doc(snapshot.data.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final userDoc = snapshot.data;
                  final user = userDoc.data();
                  if (user["type"] == "officer") {
                    return OfficerMainScreen(
                      userInfo: user,
                    );
                  } else {
                    return AdminMainScreen(
                      userInfo: user,
                    );
                  }
                } else {
                  return Material(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            );
          }
          return LoginScreen();
        }
      },
    );
  }

  loginAccess(BuildContext ctx) {
    print("IN LOGIN ACCESS");
    var currentUser = FirebaseAuth.instance.currentUser.uid;
    print(currentUser);
    FirebaseFirestore.instance
        .collection("officers")
        .doc(currentUser)
        .get()
        .then((value) {
      print(value["type"]);
      if (value["type"] == "officer") {
        print("IN OFF");
        return OfficerMainScreen();
      } else {
        print("IN admin");
        return AdminMainScreen();
      }
    });
  }

  signIn(String mobNo, String password, BuildContext ctx) async {
    await _auth
        .signInWithEmailAndPassword(email: mobNo, password: password)
        .catchError((authErr) async {
      var errmsg = "An error occured, please check filled information";
      if (authErr.message != null) {
        errmsg = authErr.message
            .toString()
            .replaceAll("email address", "Mobile Number");
      }

      await dialogBox(ctx, "Error", errmsg, Icons.error);
    });
  }

  signOut(BuildContext ctx) {
    print("SignOUT");
    FirebaseAuth.instance.signOut();
  }

  updateLocation(double latitude, double longitude, double accuracy) {
    print("IN FUN");
    // print(latitude.toString() + " " + longitude.toString());
    Map location = {
      "latitude": latitude,
      "longitude": longitude,
      "accuracy": accuracy,
    };
    var currentUser = FirebaseAuth.instance.currentUser.uid;

    FirebaseFirestore.instance
        .collection("officers")
        .doc(currentUser)
        .update({"location": location});
  }

  onDutyDefault() {
    var currentUser = FirebaseAuth.instance.currentUser.uid;

    FirebaseFirestore.instance
        .collection("officers")
        .doc(currentUser)
        .update({"onDuty": false});
  }
}
