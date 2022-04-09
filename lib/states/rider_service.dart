import 'package:flutter/material.dart';
import 'package:scnexpress/bodys/Show_payment.dart';
import 'package:scnexpress/bodys/show_call_item.dart';
import 'package:scnexpress/bodys/show_call_truck.dart';
import 'package:scnexpress/bodys/show_dashboard.dart';
import 'package:scnexpress/utility/my_constant.dart';
import 'package:scnexpress/widgets/Show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RiderService extends StatefulWidget {
  const RiderService({Key? key}) : super(key: key);

  @override
  _RiderServiceState createState() => _RiderServiceState();
}

class _RiderServiceState extends State<RiderService> {
  List<Widget> widgets = [
    ShowDashboard(),
    ShowCallTruck(),
    ShowCallItem(),
    ShowPayment()
  ];
  int indexWidget = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Rider'),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            buildSignOut(),
            Column(
              children: [
                UserAccountsDrawerHeader(accountName: null, accountEmail: null),
                dashboard(),
                orderRecive(),
                orderSenditem(),
                payment(),
              ],
            ),
          ],
        ),
      ),
      body: widgets[indexWidget],
    );
  }

  ListTile dashboard() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 0;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.filter_1_outlined),
      title: ShowTitle(
        title: 'Dashboard',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'sumary detail',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }

  ListTile orderRecive() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 1;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.filter_1_outlined),
      title: ShowTitle(
        title: 'Call Truck',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'sumary Call Truck',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }

  ListTile orderSenditem() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 2;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.filter_1_outlined),
      title: ShowTitle(
        title: 'Call Item',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'Show Call Item',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }

  ListTile payment() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 3;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.filter_1_outlined),
      title: ShowTitle(
        title: 'Payment',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'List Payment',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }

  Column buildSignOut() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
          onTap: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.clear().then(
                  (value) => Navigator.pushNamedAndRemoveUntil(
                      context, MyConstant.routeAuth, (route) => false),
                );
          },
          tileColor: Colors.orange.shade900,
          leading: Icon(
            Icons.exit_to_app,
            size: 36,
            color: Colors.white,
          ),
          title: ShowTitle(
            title: 'Sign Out',
            textStyle: MyConstant().h2WhiteStyle(),
          ),
          subtitle: ShowTitle(
            title: 'Sign Out And To Login',
            textStyle: MyConstant().h3WhiteStyle(),
          ),
        ),
      ],
    );
  }
}
