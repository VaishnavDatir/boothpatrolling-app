import 'package:url_launcher/url_launcher.dart';

class UrlLauncher {
  callOfficer(String mobileno) async {
    String url = "tel:$mobileno";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
