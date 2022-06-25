import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scnexpress/models/list_callitem_prepay_model.dart';
import 'package:scnexpress/states/list_callitem_detail_prepay.dart';
import 'package:scnexpress/utility/my_constant.dart';
import 'package:scnexpress/widgets/Show_title.dart';
import 'package:scnexpress/widgets/show_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class prepaycallitempage extends StatefulWidget {
  const prepaycallitempage({Key? key}) : super(key: key);

  @override
  State<prepaycallitempage> createState() => _prepaycallitempageState();
}

class _prepaycallitempageState extends State<prepaycallitempage> {
  bool load = true;
  bool? haveData;
  List<listCallItemPrepayModel> arraylistcallitemprepay = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showlistCallItemPrepayment();
  }

  Future<Null> showlistCallItemPrepayment() async {
    if (arraylistcallitemprepay.length != 0) {
      arraylistcallitemprepay.clear();
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tokenrider = preferences.getString('token')!;
    print('this test data');
    await Dio()
        .post('${MyConstant.urlapi}/showlistcallitemprepay',
            options: Options(headers: <String, String>{
              'authorization': 'Bearer $tokenrider'
            }))
        .then((value) {
      if (value.toString() == 'no data show') {
        setState(() {
          load = false;
          haveData = false;
        });
        print('$value');
      } else {
        for (var item in value.data) {
          listCallItemPrepayModel model = listCallItemPrepayModel.fromMap(item);
          setState(() {
            load = false;
            haveData = true;
            arraylistcallitemprepay.add(model);
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
                        title: 'ບໍມີລາຍການເພື່ອຊຳລະເອີ້ນສິນຄ້າ',
                        textStyle: MyConstant().h1Style(),
                      ),
                      ShowTitle(
                          title: 'ກະລູນາກວດສອບລາຍການກວດສອບເອີ້ນສິນຄ້າ',
                          textStyle: MyConstant().h2Style())
                    ],
                  ),
                ),
    );
  }

  ListView buildListView(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: arraylistcallitemprepay.length,
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
                height: constraints.maxWidth * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ບິນເລກທີ: ${arraylistcallitemprepay[index].inv_id}',
                      style: TextStyle(
                        fontFamily: 'Notosan',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6F00),
                      ),
                    ),
                    Text(
                      'ລາຄາ: ${arraylistcallitemprepay[index].inv_total.toString()}',
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
                                        builder: (context) =>
                                            listCallItemDetailPrepay(
                                          invoiceParentID:
                                              arraylistcallitemprepay[index],
                                        ),
                                      ))
                                  .then(
                                      (value) => showlistCallItemPrepayment());
                            },
                            icon: Icon(
                              Icons.moped_outlined,
                              size: 36,
                              color: MyConstant.primary,
                            )),
                      ],
                    ),
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
