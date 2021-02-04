import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

//HELPERS
import './helpers/theme_helper.dart';
import './helpers/user_managemet.dart';

//SCREENS
import './screens/login_screen.dart';
import './screens/edit_profile_screen.dart';
import './screens/edit_password.dart';
import './screens/loading_screen.dart';
import 'screens/feedback_screen.dart';

//Officer screens
import './screens/officer_screens/officer_main_screen.dart';

//Admin screens
import './screens/admin_screens/admin_main_screen.dart';
import './screens/admin_screens/add_officer_screen.dart';
import './screens/admin_screens/list_all_officers.dart';
import './screens/admin_screens/officer_detail_screen.dart';

import './widgets/app_retain_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    statusBarColor: Colors.transparent,
    // systemNavigationBarColor: ColorConstant.deepBlue,
    // systemNavigationBarIconBrightness: Brightness.light,
  ));
  await Firebase.initializeApp();
  runApp(MyApp());
  print("Application Started " + DateTime.now().toString());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booth Patrolling',
      theme: AppTheme().lightTheme,
      // home: StreamBuilder(
      //   stream: FirebaseAuth.instance.authStateChanges(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {}
      //     return LoginScreen();
      //   },
      // ),
      home: _wrapWithBanner(AppRetainWidget(
        child: UserManagement().handleAuth(),
      )),
      // UserManagement().handleAuth(),
      routes: {
        LoginScreen.routeName: (ctx) => LoginScreen(),
        OfficerMainScreen.routeName: (ctx) => OfficerMainScreen(),
        AdminMainScreen.routeName: (ctx) => AdminMainScreen(),
        AddOfficer.routeName: (ctx) => AddOfficer(),
        LoadingScreen.routeName: (ctx) => LoadingScreen(),
        EditProfileScreen.routeName: (ctx) => EditProfileScreen(),
        EditPasswordScreen.routeName: (ctx) => EditPasswordScreen(),
        ListAllOfficersScreen.routeName: (ctx) => ListAllOfficersScreen(),
        FeedbackScreen.routeName: (ctx) => FeedbackScreen(),
        OfficerDetailScreen.routeName: (ctx) => OfficerDetailScreen(),
      },
    );
  }
}

Widget _wrapWithBanner(Widget child) {
  return Banner(
    child: child,
    location: BannerLocation.bottomEnd,
    message: 'BETA',
    color: Colors.green,
    textStyle: TextStyle(
        fontWeight: FontWeight.w700, fontSize: 12.0, letterSpacing: 1.0),
    textDirection: TextDirection.ltr,
  );
}
