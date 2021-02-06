import 'package:flutter/material.dart';

import '../helpers/theme_helper.dart';
import '../helpers/screen_transition.dart';

import '../screens/feedback_screen.dart';
import '../screens/about_screen.dart';

class HelpScreen extends StatelessWidget {
  static const routeName = '/HelpScreen';
  final Map<String, dynamic> userInfo;
  HelpScreen({this.userInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        titleSpacing: 0,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: ColorConstant.deepBlue),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Help",
          style: Theme.of(context)
              .textTheme
              .headline1
              .copyWith(color: ColorConstant.deepBlue, fontSize: 20),
        ),
      ),
      body: ListView(
        children: [
          Hero(
            tag: "AppLogo",
            child: Image.asset(
              "assets/images/logo2Black.png",
              height: 150,
            ),
          ),
          Divider(),
          ListTile(
            onTap: () {
              // Navigator.of(context).pushNamed(AboutScreen.routeName);
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: HelpScreen(), enterPage: AboutScreen()));
            },
            leading: Icon(
              Icons.info,
              color: Colors.black,
            ),
            title: Text(
              "About application",
              style: Theme.of(context)
                  .textTheme
                  .headline2
                  .copyWith(fontSize: 17, color: Colors.black),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.feedback,
              color: Colors.black,
            ),
            title: Text(
              "FeedBack",
              style: Theme.of(context)
                  .textTheme
                  .headline2
                  .copyWith(fontSize: 17, color: Colors.black),
            ),
            onTap: () async {
              // await Navigator.of(context)
              //     .push(MaterialPageRoute(builder: (BuildContext context) {
              //   return FeedbackScreen(
              //     userInfo: userInfo,
              //   );
              // }));
              await Navigator.of(context).push(EnterExitRoute(
                  exitPage: HelpScreen(),
                  enterPage: FeedbackScreen(
                    userInfo: userInfo,
                  )));
            },
          )
        ],
      ),
    );
  }
}
