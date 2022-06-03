import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scnexpress/models/list_callitem_detail_model.dart';
import 'package:scnexpress/models/list_callitem_noaccept_model.dart';
import 'package:scnexpress/utility/my_constant.dart';
import 'package:scnexpress/widgets/Show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListCallItemNoRidderAccept extends StatefulWidget {
  final listCallItemNoAcceptModel listcallitemnoacceptModel;
  const ListCallItemNoRidderAccept(
      {Key? key, required this.listcallitemnoacceptModel})
      : super(key: key);

  @override
  State<ListCallItemNoRidderAccept> createState() =>
      _ListCallItemNoRidderAcceptState();
}

class _ListCallItemNoRidderAcceptState
    extends State<ListCallItemNoRidderAccept> {
  listCallItemNoAcceptModel? listItemcallNoacceptModel;

  bool load = true;
  bool? haveData;
  List<callItemToHomeDetailListModel> arrayCallItemList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listItemcallNoacceptModel = widget.listcallitemnoacceptModel;
    listCallItemDetail();
  }

  Future<Null> listCallItemDetail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tokenrider = preferences.getString('token')!;

    await Dio()
        .post('${MyConstant.urlapi}/showlistcallitemdetail',
            data: {"billinvoice": "${listItemcallNoacceptModel!.inv_id}"},
            options: Options(headers: <String, String>{
              'authorization': 'Bearer $tokenrider'
            }))
        .then((value) {
      if (value.toString() == 'null') {
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        for (var item in value.data) {
          callItemToHomeDetailListModel model =
              callItemToHomeDetailListModel.fromMap(item);
          setState(() {
            load = false;
            haveData = true;
            arrayCallItemList.add(model);
          });
        }
      }
    });
  }

  Future<Null> recieveCalItemOrder() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tokenrider = preferences.getString('token')!;

    await Dio()
        .post('${MyConstant.urlapi}/acceptcallitem',
            data: {"billinvoice": "${listItemcallNoacceptModel!.inv_id}"},
            options: Options(headers: <String, String>{
              'authorization': 'Bearer $tokenrider'
            }))
        .then((value) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ລາຍການເອີ້ນສົ່ງສົນຄ້າຮອດເຮືອນ'),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Container(
                      margin: EdgeInsets.only(top: 3),
                      padding: EdgeInsets.all(4),
                      child: Text(
                          'ຫົວບິນ: ${listItemcallNoacceptModel!.inv_id}'))),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => buildListView(constraints),
              ),
            ),
            ElevatedButton(
                onPressed: () => recieveCalItemOrder(),
                child: Text('ຮັບລາຍການເອີ້ນເຄື່ອງ'))
          ],
        ),
      ),
    );
  }

  ListView buildListView(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: arrayCallItemList.length,
      itemBuilder: (context, index) => Container(
        padding: EdgeInsets.all(4),
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            border: Border.all(width: 3, color: MyConstant.dark)),
        child: Column(
          children: [
            ShowTitle(
                title: 'ເລກບິນ: ${arrayCallItemList[index].bill_code}',
                textStyle: MyConstant().h2Style()),
            ShowTitle(
                title: 'ຊື່ສິນຄ້າ: ${arrayCallItemList[index].mtl_name}',
                textStyle: MyConstant().h2Style()),
            ShowTitle(
                title: 'ນ້ຳໜັກ: ${arrayCallItemList[index].mtl_weight}',
                textStyle: MyConstant().h2Style()),
            ShowTitle(
                title: 'ຂະຫນາດ: ${arrayCallItemList[index].mtl_size}',
                textStyle: MyConstant().h2Style()),
            ShowTitle(
                title: 'ຈຳນວນ: ${arrayCallItemList[index].mtl_am.toString()} ',
                textStyle: MyConstant().h2Style()),
            ShowTitle(
                title:
                    'ລາຄາໃນບິນ: ${arrayCallItemList[index].mtl_total_price} ${arrayCallItemList[index].ccy}',
                textStyle: MyConstant().h2Style()),
            ShowTitle(
                title: 'ວັນທີລົງທະບຽນ :${arrayCallItemList[index].create_date}',
                textStyle: MyConstant().h2Style()),
          ],
        ),
      ),
    );
  }
}
