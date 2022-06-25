import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scnexpress/models/list_callitem_prepay_model.dart';
import 'package:scnexpress/models/show_callitemdetail_list.dart';
import 'package:scnexpress/utility/my_constant.dart';
import 'package:scnexpress/widgets/Show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class listCallItemDetailPrepay extends StatefulWidget {
  final listCallItemPrepayModel invoiceParentID;
  const listCallItemDetailPrepay({Key? key, required this.invoiceParentID})
      : super(key: key);

  @override
  State<listCallItemDetailPrepay> createState() =>
      _listCallItemDetailPrepayState();
}

class _listCallItemDetailPrepayState extends State<listCallItemDetailPrepay> {
  listCallItemPrepayModel? invoiceRefModel;
  bool load = true;
  bool? haveData;
  List<showCallItemdetaillistModel> arrayIemCallDetailListModel = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    invoiceRefModel = widget.invoiceParentID;
    showCallItemListDetail();
  }

  Future<Null> showCallItemListDetail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tokenrider = preferences.getString('token')!;

    await Dio()
        .post('${MyConstant.urlapi}/showacceptitemdetaillist',
            data: {"invoiceheader": "${invoiceRefModel!.inv_id}"},
            options: Options(headers: <String, String>{
              'authorization': 'Bearer $tokenrider'
            }))
        .then((value) {
      if (value.toString() == 'no item') {
        load = false;
        haveData = false;
      } else {
        for (var item in value.data) {
          showCallItemdetaillistModel model =
              showCallItemdetaillistModel.fromMap(item);
          setState(() {
            load = false;
            haveData = true;
            arrayIemCallDetailListModel.add(model);
          });
        }
      }
    });
  }

  Future<Null> payCallitem() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tokenrider = preferences.getString('token')!;

    Dio().post('${MyConstant.urlapi}/paycashitemcall',
        data: {"billinvoice": "${invoiceRefModel!.inv_id}"},
        options: Options(
            headers: <String, String>{'authorization': 'Bearer $tokenrider'}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ລາຍການຊຳລະເອີ້ນສິນຄ້າ'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.only(top: 8),
              child: Text('ຫົວບິນ: ${invoiceRefModel!.inv_id}'),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => buildListView(constraints),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                payCallitem();
                Navigator.pop(context);
              },
              child: Text('ຊຳລະເງິນຄ່່າເອີ້ນເຄື່ອງ'))
        ],
      ),
    );
  }

  ListView buildListView(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: arrayIemCallDetailListModel.length,
      itemBuilder: (context, index) => Container(
        height: constraints.maxWidth * 0.7,
        child: Card(
          color: Color(0xFFe8e8e8),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                width: constraints.maxWidth * 0.35,
                height: constraints.maxWidth * 0.35,
                child: Container(
                  decoration: new BoxDecoration(
                    color: MyConstant.primary,
                    borderRadius: new BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(
                          'http://149.129.55.90/appicon/payment.jpeg'),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(4),
                width: constraints.maxWidth * 0.7 - 26,
                height: constraints.maxWidth * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ເລກສິນຄ້າ: ${arrayIemCallDetailListModel[index].bill_code}',
                      style: TextStyle(
                        fontFamily: 'Notosan',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6F00),
                      ),
                    ),
                    Text(
                      'ຊື່ສິນຄ້າ: ${arrayIemCallDetailListModel[index].mtl_name}',
                      style: TextStyle(
                        fontFamily: 'Notosan',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6F00),
                      ),
                    ),
                    Text(
                      'ນ້ຳໜັກ: ${arrayIemCallDetailListModel[index].mtl_weight}',
                      style: TextStyle(
                        fontFamily: 'Notosan',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6F00),
                      ),
                    ),
                    Text(
                      'ຂະໜາດ: ${arrayIemCallDetailListModel[index].mtl_size}',
                      style: TextStyle(
                        fontFamily: 'Notosan',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6F00),
                      ),
                    ),
                    Text(
                      'ຈຳນວນ: ${arrayIemCallDetailListModel[index].mtl_am.toString()}',
                      style: TextStyle(
                        fontFamily: 'Notosan',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6F00),
                      ),
                    ),
                    Text(
                      'ລາຄາ: ${arrayIemCallDetailListModel[index].mtl_total_price} ${arrayIemCallDetailListModel[index].ccy}',
                      style: TextStyle(
                        fontFamily: 'Notosan',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6F00),
                      ),
                    ),
                    Text(
                      'ວັນທີລົງທະບຽນ: ${arrayIemCallDetailListModel[index].create_date}',
                      style: TextStyle(
                        fontFamily: 'Notosan',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6F00),
                      ),
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
