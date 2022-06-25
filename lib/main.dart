import 'package:flutter/material.dart';
import 'package:scnexpress/states/authen.dart';
import 'package:scnexpress/states/check_call_recieve.dart';
import 'package:scnexpress/states/config_printer.dart';
import 'package:scnexpress/states/create_account.dart';
import 'package:scnexpress/states/merchant_service.dart';
import 'package:scnexpress/states/rider_service.dart';
import 'package:scnexpress/states/staff_service.dart';
import 'package:scnexpress/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/createAccount': (BuildContext context) => CreateAccount(),
  '/riderService': (BuildContext context) => RiderService(),
  '/staffServie': (BuildContext context) => StaffService(),
  '/merchantService': (BuildContext context) => MerchantService(),
  '/checkRecieve': (BuildContext context) => checkRecieve(),
  '/configprinter': (BuildContext context) => configPrinterPage(),
};

String? initialRoute;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? token = preferences.getString('token');
  String? printername = preferences.getString('printer_name');
  String? printeraddress = preferences.getString('printer_address');

  print('printer name  $printername');
  print('printer address  $printername');

  if (printername?.isEmpty ?? true) {
    initialRoute = MyConstant.routPrinterConfig;
    runApp(MyApp());
  } else if (printername?.isEmpty ?? true) {
    initialRoute = MyConstant.routeRiderService;
    runApp(MyApp());
  } else {
    initialRoute = MyConstant.routeAuth;
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MaterialColor materialColor =
        MaterialColor(0xFFFF6F00, MyConstant.mapMaterialColor);
    return MaterialApp(
      title: MyConstant.appName,
      routes: map,
      initialRoute: initialRoute,
      theme: ThemeData(primarySwatch: materialColor),
    );
  }
}
