import 'package:flutter/material.dart';

import '../helpers/theme_helper.dart';
import '../helpers/user_managemet.dart';

import '../widgets/userImag_widget.dart';

import '../screens/admin_screens/add_officer_screen.dart';
import '../screens/admin_screens/list_all_officers.dart';

import '../screens/edit_profile_screen.dart';

import '../screens/feedback_screen.dart';

class AppDrawer extends StatelessWidget {
  final Map<String, dynamic> userInfo;
  AppDrawer({this.userInfo});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
        child: ScrollConfiguration(
          behavior: NoGlowScroll(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                DrawerUserInfo(
                  userName: userInfo["name"],
                  userType: userInfo["type"],
                  userImgUrl: userInfo["officerImgURL"],
                ),
                if (userInfo['type'] == "admin") AdminDrawerContent(userInfo),
                DrawerEditProfile(
                  userInfo: userInfo,
                ),
                DrawerLogout(),
                ListTile(
                  leading: Icon(
                    Icons.feedback,
                    color: Colors.black,
                  ),
                  title: Text(
                    "Feedback",
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        .copyWith(fontSize: 17, color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .popAndPushNamed(FeedbackScreen.routeName);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerEditProfile extends StatelessWidget {
  final Map<String, dynamic> userInfo;
  DrawerEditProfile({this.userInfo});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
            leading: Icon(
              Icons.edit,
              color: Colors.black,
            ),
            title: Text(
              "Edit Profile",
              style: Theme.of(context)
                  .textTheme
                  .headline2
                  .copyWith(fontSize: 17, color: Colors.black),
            ),
            onTap: () async {
              Navigator.pop(context);
              // Navigator.of(context).pushNamed(
              //     EditProfileScreen.routeName,
              //     arguments: {"userInfo": userInfo});
              await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return EditProfileScreen(
                  userInfos: userInfo,
                );
              }));
            }),
      ],
    );
  }
}

class DrawerLogout extends StatelessWidget {
  const DrawerLogout({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.black,
            ),
            title: Text(
              "Logout",
              style: Theme.of(context)
                  .textTheme
                  .headline2
                  .copyWith(fontSize: 17, color: Colors.black),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Row(
                    children: [
                      Icon(Icons.logout),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Logout",
                          style: Theme.of(context).textTheme.headline1.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  content: SingleChildScrollView(
                    child: Container(
                      child: Text(
                        "Do you want to logout?",
                        style: Theme.of(context)
                            .textTheme
                            .headline1
                            .copyWith(fontSize: 17, color: Colors.black),
                      ),
                    ),
                  ),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text(
                          "No",
                          style: Theme.of(context).textTheme.headline1.copyWith(
                              fontSize: 17,
                              color: ColorConstant.deepBlue,
                              fontWeight: FontWeight.w500),
                        )),
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          UserManagement().signOut(context);
                        },
                        child: Text(
                          "Yes",
                          style: Theme.of(context).textTheme.headline1.copyWith(
                              fontSize: 17,
                              color: ColorConstant.deepBlue,
                              fontWeight: FontWeight.w500),
                        )),
                  ],
                ),
              );
            }),
      ],
    );
  }
}

class AdminDrawerContent extends StatelessWidget {
  final Map<String, dynamic> userInfo;
  AdminDrawerContent(this.userInfo);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
            leading: Icon(
              Icons.person_add,
              color: Colors.black,
            ),
            title: Text(
              "Add officer",
              style: Theme.of(context)
                  .textTheme
                  .headline2
                  .copyWith(fontSize: 17, color: Colors.black),
            ),
            onTap: () async {
              Navigator.pop(context);
              // Navigator.of(context).pushNamed(AddOfficer.routeName);
              await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return AddOfficer(
                  userInfo: userInfo,
                );
              }));
            }),
        ListTile(
          onTap: () async {
            Navigator.of(context).pop();
            await Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return ListAllOfficersScreen(
                currentUserInfo: userInfo,
              );
            }));
          },
          leading: Icon(
            Icons.list,
            color: Colors.black,
          ),
          title: Text(
            "List of officers",
            style: Theme.of(context)
                .textTheme
                .headline1
                .copyWith(fontSize: 17, color: Colors.black),
          ),
        ),
      ],
    );
  }
}

class DrawerUserInfo extends StatelessWidget {
  final String userName;
  final String userType;
  final String userImgUrl;

  DrawerUserInfo(
      {@required this.userName, @required this.userType, this.userImgUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      color: ColorConstant.deepBlue,
      padding: EdgeInsets.fromLTRB(
          15, MediaQuery.of(context).padding.top + 8, 15, 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserImgWidget(
            imgUrl: userImgUrl.toString(),
            size: 75,
          ),
          SizedBox(height: 10),
          Text(
            userName,
            style: Theme.of(context).textTheme.headline2.copyWith(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: 1),
          ),
          // SizedBox(height: 4),
          Text(
            userType,
            style: Theme.of(context).textTheme.headline2.copyWith(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
