import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import '../helpers/theme_helper.dart';

class AboutScreen extends StatefulWidget {
  static const routeName = '/AboutScreen';

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Widget _infoTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(
        icon,
        size: 32,
        color: ColorConstant.deepBlue,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline1.copyWith(
            color: ColorConstant.deepBlue,
            fontSize: 18,
            fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle ?? 'Not set',
          style: Theme.of(context).textTheme.headline2.copyWith(
                color: Colors.black,
                fontSize: 16,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: ColorConstant.deepBlue),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "About",
          style: Theme.of(context)
              .textTheme
              .headline1
              .copyWith(color: ColorConstant.deepBlue, fontSize: 20),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Hero(
            tag: "AppLogo",
            child: Image.asset(
              "assets/images/logo2Black.png",
              height: 150,
            ),
          ),
          _infoTile(Icons.adb, 'App name', _packageInfo.appName),
          _infoTile(Icons.inbox, 'Package name', _packageInfo.packageName),
          _infoTile(Icons.android, 'App version', _packageInfo.version),
          _infoTile(Icons.build, 'Build number', _packageInfo.buildNumber),
        ],
      ),
    );
  }
}
