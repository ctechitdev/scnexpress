import 'package:flutter/material.dart';
import 'package:scnexpress/states/authen.dart';
import 'package:scnexpress/states/check_call_recieve.dart';
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
};

String? initialRoute;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? token = preferences.getString('token');
  print('data is : $token');

  if (token?.isEmpty ?? true) {
    initialRoute = MyConstant.routeAuth;
    runApp(MyApp());
  } else {
    initialRoute = MyConstant.routeRiderService;
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyConstant.appName,
      routes: map,
      initialRoute: initialRoute,
    );
  }
}
