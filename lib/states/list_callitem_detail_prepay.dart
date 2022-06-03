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
          padding: const EdgeInsets.all(8),
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(width: 3, color: MyConstant.dark),
          ),
          child: Column(
            children: [
              ShowTitle(
                title:
                    'ເລກສິນຄ້າ: ${arrayIemCallDetailListModel[index].bill_code}',
                textStyle: MyConstant().h2Style(),
              ),
              ShowTitle(
                title:
                    'ຊື່ສິນຄ້າ: ${arrayIemCallDetailListModel[index].mtl_name}',
                textStyle: MyConstant().h2Style(),
              ),
              ShowTitle(
                title:
                    'ນ້ຳໜັກ: ${arrayIemCallDetailListModel[index].mtl_weight}',
                textStyle: MyConstant().h2Style(),
              ),
              ShowTitle(
                title: 'ຂະໜາດ: ${arrayIemCallDetailListModel[index].mtl_size}',
                textStyle: MyConstant().h2Style(),
              ),
              ShowTitle(
                title:
                    'ຈຳນວນ: ${arrayIemCallDetailListModel[index].mtl_am.toString()}',
                textStyle: MyConstant().h2Style(),
              ),
              ShowTitle(
                title:
                    'ລາຄາ: ${arrayIemCallDetailListModel[index].mtl_total_price} ${arrayIemCallDetailListModel[index].ccy}',
                textStyle: MyConstant().h2Style(),
              ),
              ShowTitle(
                title:
                    'ວັນທີລົງທະບຽນ: ${arrayIemCallDetailListModel[index].create_date}',
                textStyle: MyConstant().h2Style(),
              ),
            ],
          )),
    );
  }
}
