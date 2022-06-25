import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scnexpress/models/listbillprint_model.dart';
import 'package:scnexpress/states/show_billlist_print.dart';
import 'package:scnexpress/utility/my_constant.dart';
import 'package:scnexpress/widgets/Show_title.dart';
import 'package:scnexpress/widgets/show_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class printBillPage extends StatefulWidget {
  const printBillPage({Key? key}) : super(key: key);

  @override
  State<printBillPage> createState() => _printBillPageState();
}

class _printBillPageState extends State<printBillPage> {
  bool load = true;
  bool? haveData;
  List<billListSelectPrint> arrayListbill = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showListbill();
  }

  Future<Null> showListbill() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tokenrider = preferences.getString('token')!;

    await Dio()
        .post('${MyConstant.urlapi}/listbill',
            options: Options(headers: <String, String>{
              'authorization': 'Bearer $tokenrider'
            }))
        .then((value) {
      if (value.toString() == 'no item') {
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        for (var item in value.data) {
          billListSelectPrint model = billListSelectPrint.fromMap(item);

          setState(() {
            load = false;
            haveData = true;
            arrayListbill.add(model);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? ShowProgress()
          : haveData!
              ? LayoutBuilder(
                  builder: (context, constraints) => buildListView(constraints),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShowTitle(
                        title: 'ບໍມີລາຍການຊຳລະເງິນ',
                        textStyle: MyConstant().h1Style(),
                      ),
                      ShowTitle(
                          title: 'ກະລຸນາກວດສອບລາຍການຊຳລະເງິນ',
                          textStyle: MyConstant().h2Style())
                    ],
                  ),
                ),
    );
  }

  ListView buildListView(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: arrayListbill.length,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.all(5),
        child: Card(
          color: Color(0xFFe8e8e8),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                width: constraints.maxWidth * 0.3 - 4,
                height: constraints.maxWidth * 0.3,
                child: Container(
                  decoration: new BoxDecoration(
                    color: MyConstant.primary,
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: const Text(
                      'SCN RIDER',
                      style: TextStyle(
                        fontFamily: 'Notosan',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(4),
                width: constraints.maxWidth * 0.7 - 14,
                height: constraints.maxWidth * 0.35,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ເລກບິນ :${arrayListbill[index].inv_id}',
                      style: TextStyle(
                        fontFamily: 'Notosan',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6F00),
                      ),
                    ),
                    Text(
                      'ເລກບິນ :${arrayListbill[index].inv_total}',
                      style: TextStyle(
                        fontFamily: 'Notosan',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6F00),
                      ),
                    ),
                    Text(
                      'ເລກບິນ :${arrayListbill[index].bill_type}',
                      style: TextStyle(
                        fontFamily: 'Notosan',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6F00),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => detailListBillPrint(
                                    billlistModel: arrayListbill[index],
                                  ),
                                ));
                          },
                          icon: Icon(
                            Icons.moped_outlined,
                            size: 36,
                            color: MyConstant.primary,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
