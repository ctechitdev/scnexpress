import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double Latitude, double Longitude) async {
    String googleMapURL =
        "https://www.google.com/maps/search/?api=1&query=$Latitude,$Longitude";

    if (await canLaunch(googleMapURL)) {
      await launch(googleMapURL);
    } else {
      throw 'can not open map';
    }
  }
}
