import 'dart:ui';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:scnexpress/bodys/capture.dart';
import 'package:scnexpress/bodys/prepay_callitem.dart';
import 'package:scnexpress/bodys/prinbill.dart';
import 'package:scnexpress/bodys/show_call_ridder_none_accept.dart';
import 'package:scnexpress/bodys/show_callitem_accept.dart';
import 'package:scnexpress/bodys/show_calltruck_accept.dart';
import 'package:scnexpress/bodys/show_callitem_noaccept.dart';
import 'package:scnexpress/bodys/show_prepayment_calltruck.dart';

import 'package:scnexpress/utility/my_constant.dart';
import 'package:scnexpress/widgets/Show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RiderService extends StatefulWidget {
  const RiderService({Key? key}) : super(key: key);

  @override
  _RiderServiceState createState() => _RiderServiceState();
}

class _RiderServiceState extends State<RiderService> {
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  List<Widget> widgets = [
    showCallRidderNoneAccept(),
    ShowAcceptCallItemRidder(),
    ShowListCalltruckForPayByRidder(),
    showListCallItemNoaccept(),
    showListCallItemAcepted(),
    prepaycallitempage(),
    //printTest(),
    //printBillPage(),
    capTurepage(),
  ];
  int indexWidget = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SCN RIDER',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFFF6F00),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(80),
                ),
                image: const DecorationImage(
                  image: NetworkImage(
                      'http://149.129.55.90/appicon/scnexpress.png'),
                ),
              ),
              child: Text(''),
            ),

            // 123

            buildCalltruckNonAccept(),
            buildCalltruckAccepted(),
            buildPaymentCallTruck(),
            buildCallItemNoAccept(),
            buildCallItemAccepted(),
            buildPaymentCallItem(),
            buildPrintBill(),
            buildLogout(),
          ],
        ),
      ),
      body: widgets[indexWidget],
    );
  }

  Column buildCalltruckNonAccept() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: NetworkImage(
                  'http://149.129.55.90/appicon/listnoacceptcalltruck.jpeg'),
            ),
          ),
          child: ListTile(
            onTap: () {
              setState(() {
                indexWidget = 0;
                Navigator.pop(context);
              });
            },
          ),
        ),
      ],
    );
  }

  Column buildCalltruckAccepted() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: NetworkImage(
                  'http://149.129.55.90/appicon/listacceptcalltruck.jpeg'),
            ),
          ),
          child: ListTile(
            onTap: () {
              setState(() {
                indexWidget = 1;
                Navigator.pop(context);
              });
            },
          ),
        ),
      ],
    );
  }

  Column buildPaymentCallTruck() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: NetworkImage(
                  'http://149.129.55.90/appicon/paymentcalltruck.jpeg'),
            ),
          ),
          child: ListTile(
            onTap: () {
              setState(() {
                indexWidget = 2;
                Navigator.pop(context);
              });
            },
          ),
        ),
      ],
    );
  }

  Column buildCallItemNoAccept() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: NetworkImage(
                  'http://149.129.55.90/appicon/listnoacceptcallitem.jpeg'),
            ),
          ),
          child: ListTile(
            onTap: () {
              setState(() {
                indexWidget = 3;
                Navigator.pop(context);
              });
            },
          ),
        ),
      ],
    );
  }

  Column buildCallItemAccepted() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: NetworkImage(
                  'http://149.129.55.90/appicon/listacceptcallitem.jpeg'),
            ),
          ),
          child: ListTile(
            onTap: () {
              setState(() {
                indexWidget = 4;
                Navigator.pop(context);
              });
            },
          ),
        ),
      ],
    );
  }

  Column buildPaymentCallItem() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: NetworkImage(
                  'http://149.129.55.90/appicon/paymentcallitem.jpeg'),
            ),
          ),
          child: ListTile(
            onTap: () {
              setState(() {
                indexWidget = 5;
                Navigator.pop(context);
              });
            },
          ),
        ),
      ],
    );
  }

  Column buildPrintBill() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            image: const DecorationImage(
              image:
                  NetworkImage('http://149.129.55.90/appicon/printbill.jpeg'),
            ),
          ),
          child: ListTile(
            onTap: () {
              setState(() {
                indexWidget = 6;
                Navigator.pop(context);
              });
            },
          ),
        ),
      ],
    );
  }

  Column buildLogout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: Color(0xFFFF6F00),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            image: const DecorationImage(
              image: NetworkImage('http://149.129.55.90/appicon/logout.png'),
            ),
          ),
          child: ListTile(
            onTap: () async {
              printer.disconnect();
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences.remove('token').then(
                    (value) => Navigator.pushNamedAndRemoveUntil(
                        context, MyConstant.routeAuth, (route) => false),
                  );
            },
          ),
        ),
      ],
    );
  }
}
