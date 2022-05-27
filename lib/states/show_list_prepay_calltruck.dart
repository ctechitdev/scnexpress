import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scnexpress/models/list_detail_prepay_calltruck_model.dart';
import 'package:scnexpress/models/list_prepay_calltruck_medel.dart';
import 'package:scnexpress/utility/my_constant.dart';
import 'package:scnexpress/widgets/Show_title.dart';
import 'package:scnexpress/widgets/show_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowListDetailPrepayCallTruck extends StatefulWidget {
  final listPrepayCallTruckModel listprepaycalltruckModel;
  const ShowListDetailPrepayCallTruck(
      {Key? key, required this.listprepaycalltruckModel})
      : super(key: key);

  @override
  State<ShowListDetailPrepayCallTruck> createState() =>
      _ShowListDetailPrepayCallTruckState();
}

class _ShowListDetailPrepayCallTruckState
    extends State<ShowListDetailPrepayCallTruck> {
  listPrepayCallTruckModel? listprepaycalltruckModel;

  bool load = true;
  bool? haveData;
  List<listDetailPrepayCalltruckModel> listprepayModel = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listprepaycalltruckModel = widget.listprepaycalltruckModel;
    ListDetailItemPrepay();
  }

  Future<Null> ListDetailItemPrepay() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tokenrider = preferences.getString('token')!;

    await Dio()
        .post('${MyConstant.urlapi}/showcalltruckbilldetailforpay',
            data: {"billheader": "${listprepaycalltruckModel!.bill_header}"},
            options: Options(headers: <String, String>{
              'authorization': 'Beared $tokenrider'
            }))
        .then((value) {
      if (value.toString() == 'null') {
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        for (var item in value.data) {
          listDetailPrepayCalltruckModel model =
              listDetailPrepayCalltruckModel.fromMap(item);

          setState(() {
            load = false;
            haveData = true;
            listprepayModel.add(model);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ລາຍລະອຽດໃນການຊຳລະ '),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.all(2),
              child: ShowTitle(
                title: 'ຫົວບິນ: ${listprepaycalltruckModel!.bill_header}',
                textStyle: MyConstant().h2Style(),
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => buildListVIew(constraints),
            ),
          ),
          Center(
            child: Container(
              child: ShowTitle(
                  title: 'ລວມລາຄາ: ${listprepaycalltruckModel!.bill_total}',
                  textStyle: MyConstant().h1Style()),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              payment();
              Navigator.pop(context);
            },
            child: Text('ຊຳລະສິນຄ້າ'),
          )
        ],
      ),
    );
  }

  Future<Null> payment() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tokenrider = preferences.getString('token')!;

    await Dio()
        .post('${MyConstant.urlapi}/paymentcalltruk',
            data: {"billheader": "${listprepaycalltruckModel!.bill_header}"},
            options: Options(headers: <String, String>{
              'authorization': 'Bearer $tokenrider'
            }))
        .then((value) => print('$value'));
  }

  ListView buildListVIew(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: listprepayModel.length,
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.all(8),
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(width: 3, color: MyConstant.dark),
        ),
        child: Column(
          children: [
            //Text(listprepayModel[index].bill_code),
            ShowTitle(
              title: 'ເລກບິນທີ: ${listprepayModel[index].bill_code}',
              textStyle: MyConstant().h2Style(),
            ),
            ShowTitle(
              title: 'ຊື່ສິນຄ້າ: ${listprepayModel[index].mtl_name}',
              textStyle: MyConstant().h2Style(),
            ),
            ShowTitle(
              title: 'ນ້ຳໜັກ: ${listprepayModel[index].mtl_weight}',
              textStyle: MyConstant().h2Style(),
            ),
            ShowTitle(
              title: 'ຂະໜາດ: ${listprepayModel[index].mtl_size}',
              textStyle: MyConstant().h2Style(),
            ),
            ShowTitle(
              title: 'ຈຳນວນ: ${listprepayModel[index].mtl_am.toString()} ',
              textStyle: MyConstant().h2Style(),
            ),
            ShowTitle(
              title:
                  'ລາຄາ: ${listprepayModel[index].mtl_total_price} ${listprepayModel[index].ccy}',
              textStyle: MyConstant().h2Style(),
            ),
            ShowTitle(
              title: 'ວັນລົງທະບຽນ: ${listprepayModel[index].create_date}',
              textStyle: MyConstant().h2Style(),
            ),
          ],
        ),
      ),
    );
  }
}
