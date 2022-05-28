import 'package:flutter/material.dart';
import 'package:scnexpress/bodys/Show_payment.dart';
import 'package:scnexpress/bodys/show_call_item.dart';
import 'package:scnexpress/bodys/show_call_ridder_none_accept.dart';
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
  List<Widget> widgets = [
    showCallRidderNoneAccept(),
    ShowAcceptCallItemRidder(),
    ShowListCalltruckForPayByRidder(),
    showListCallItemNoaccept(),
    ShowPayment()
  ];
  int indexWidget = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SCN Ridder'),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            buildSignOut(),
            Column(
              children: [
                UserAccountsDrawerHeader(accountName: null, accountEmail: null),
                requestCallRidder(),
                requestCallRidderAccept(),
                paymentCallridder(),
                callItemTohome(),
                checkItemCalltoHome(),
                payCallitemRidder(),
                printBill(),
              ],
            ),
          ],
        ),
      ),
      body: widgets[indexWidget],
    );
  }

  ListTile requestCallRidder() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 0;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.moped_outlined),
      title: ShowTitle(
        title: 'ລາຍການເອີ້ນລົດ',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'ລາຍການເອີ້ນລົດທີ່ບໍ່ໄດ້ຮັບ',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }

  ListTile requestCallRidderAccept() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 1;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.ballot_outlined),
      title: ShowTitle(
        title: 'ກວດສອບສິນຄ້າເອີ້ນລົດ',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'ກວດສອບລາຍລະອຽດບິນທີ່ເອີ້ນຮັບລົດ',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }

  ListTile paymentCallridder() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 2;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.payments_outlined),
      title: ShowTitle(
        title: 'ຊຳລະເງິນສົດເອີ້ນລົດ',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'ຊຳລະຄ່າຂົນສົ່ງ ແລະ ບໍລິການຮັບເຄື່ອງ',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }

  ListTile callItemTohome() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 3;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.account_balance_outlined),
      title: ShowTitle(
        title: 'ລາຍການສົ່ງສິນຄ້າ',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'ສະແດງລາຍການສົ່ງສິນຄ້າທີ່ບໍ່ໄດ້ກົດຮັບ',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }

  ListTile checkItemCalltoHome() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 3;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.home_work_outlined),
      title: ShowTitle(
        title: 'ກວດຄ່າສົງສິນຄ້າຮອດບ້ານ',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'ສະແດງລາຍການຄ່າສົງສິນຄ້າຮອດບ້ານ',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }

  ListTile payCallitemRidder() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 3;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.payments_sharp),
      title: ShowTitle(
        title: 'ກວດຄ່າສົງສິນຄ້າຮອດບ້ານ',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'ສະແດງລາຍການຄ່າສົງສິນຄ້າຮອດບ້ານ',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }

  ListTile printBill() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 3;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.local_print_shop_outlined),
      title: ShowTitle(
        title: 'ພິນບິນ',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'ພິນບິນເອີ້ນລົດ ແລະ ສົ່ງສິນຄ້າ',
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
          tileColor: MyConstant.primary,
          leading: Icon(
            Icons.exit_to_app,
            size: 36,
            color: Colors.white,
          ),
          title: ShowTitle(
            title: 'ອອກລະບົບ',
            textStyle: MyConstant().h2WhiteStyle(),
          ),
          subtitle: ShowTitle(
            title: 'ອອກລະບົບ',
            textStyle: MyConstant().h3WhiteStyle(),
          ),
        ),
      ],
    );
  }
}
