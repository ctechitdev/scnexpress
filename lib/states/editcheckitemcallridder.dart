import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scnexpress/models/listitem_noaccept_model.dart';
import 'package:scnexpress/models/show_itemdetailforedit_model.dart';
import 'package:scnexpress/utility/my_constant.dart';
import 'package:scnexpress/widgets/Show_title.dart';
import 'package:scnexpress/widgets/show_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckEditItemCallRider extends StatefulWidget {
  final ListItemNoAcceptModel listitemDetailModel;
  const CheckEditItemCallRider({Key? key, required this.listitemDetailModel})
      : super(key: key);

  @override
  State<CheckEditItemCallRider> createState() => _CheckEditItemCallRiderState();
}

class _CheckEditItemCallRiderState extends State<CheckEditItemCallRider> {
  bool load = true;
  bool? haveData;
  List<ShowItemDetailForEditModel> showitemeditmodel = [];
  ListItemNoAcceptModel? listItemNoAcceptModel;

  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemWeightController = TextEditingController();
  TextEditingController itemSizeController = TextEditingController();
  TextEditingController itemValuesController = TextEditingController();
  TextEditingController itemExpressPriceController = TextEditingController();
  TextEditingController itemCalltruckPriceController = TextEditingController();

  TextEditingController itembillcode = TextEditingController();
  TextEditingController itembillheader = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    listItemNoAcceptModel = widget.listitemDetailModel;

    LoadItemDetail();
  }

  Future<Null> LoadItemDetail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tokenrider = preferences.getString('token')!;

    await Dio()
        .post('${MyConstant.urlapi}/showitemcalltruckdetailforcheck',
            data: {"billinvoice": "${listItemNoAcceptModel!.bill_code}"},
            options: Options(headers: <String, String>{
              'authorization': 'Bearer $tokenrider'
            }))
        .then((value) {
      if (value.toString() == 'null') {
        setState(() {
          haveData = false;
        });
      } else {
        for (var item in value.data) {
          ShowItemDetailForEditModel model =
              ShowItemDetailForEditModel.fromMap(item);
          // print('detail list item is ${model.bill_header}');
          setState(() {
            load = false;
            haveData = true;
            showitemeditmodel.add(model);

            itemNameController.text = model.mtl_name;
            itemWeightController.text = model.mtl_weight;
            itemSizeController.text = model.mtl_size;
            itemValuesController.text = model.mtl_am.toString();
            itemExpressPriceController.text = model.express_price.toString();
            itemCalltruckPriceController.text = model.vehicle_price.toString();
            itembillcode.text = model.bill_code;
            itembillheader.text = model.bill_header;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ແກ້ໄຂກວດສອບບິນ'),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '  ',
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) =>
                    newBuildListview(constraints),
              ),
            ),
            ElevatedButton(
                onPressed: () => processEdit(), child: Text('ແກ້ໄຂຂໍ້ມູນ'))
          ],
        ),
      ),
    );
  }

  ListView newBuildListview(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: showitemeditmodel.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(8),
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              border: Border.all(width: 3, color: MyConstant.dark)),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                ShowTitle(
                  title: 'ເລກບິນ: ${showitemeditmodel[index].bill_code} ',
                  textStyle: MyConstant().h2Style(),
                ),
                buildItemName(constraints),
                buildItemWeight(constraints),
                buildItemSize(constraints),
                buildItemValues(constraints),
                buildItemExpressPrice(constraints),
                buildItemCalltruckPrice(constraints),
              ],
            ),
          ),
        );
      },
    );
  }

  Row buildItemName(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'ກະລຸນາຕື່ມຂໍ່ມູນ';
              } else {
                return null;
              }
            },
            controller: itemNameController,
            decoration: InputDecoration(
              labelText: 'ຊື່ສິນຄ້າ:',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildItemWeight(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'ກະລຸນາຕື່ມຂໍ່ມູນ';
              } else {
                return null;
              }
            },
            keyboardType: TextInputType.number,
            controller: itemWeightController,
            decoration: InputDecoration(
              labelText: 'ນ້ຳໜັກ: ',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildItemSize(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'ກະລຸນາຕື່ມຂໍ່ມູນ';
              } else {
                return null;
              }
            },
            controller: itemSizeController,
            decoration: InputDecoration(
              labelText: 'ຂະໜາດສິນຄ້າ:',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildItemValues(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'ກະລຸນາຕື່ມຂໍ່ມູນ';
              } else {
                return null;
              }
            },
            keyboardType: TextInputType.number,
            controller: itemValuesController,
            decoration: InputDecoration(
              labelText: 'ຈຳນວນ:',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildItemExpressPrice(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'ກະລຸນາຕື່ມຂໍ່ມູນ';
              } else {
                return null;
              }
            },
            keyboardType: TextInputType.number,
            controller: itemExpressPriceController,
            decoration: InputDecoration(
              labelText: 'ລາຄາຂົນສົ່ງ:',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildItemCalltruckPrice(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'ກະລຸນາຕື່ມຂໍ່ມູນ';
              } else {
                return null;
              }
            },
            keyboardType: TextInputType.number,
            controller: itemCalltruckPriceController,
            decoration: InputDecoration(
              labelText: 'ລາຄາເອີ້ນລົດ: ',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildTitle(String title) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ShowTitle(title: title, textStyle: MyConstant().h2Style()),
        ),
      ],
    );
  }

  Future<Null> processEdit() async {
    if (formKey.currentState!.validate()) {
      String itemName = itemNameController.text;
      String itemWeight = itemWeightController.text;
      String itemSize = itemSizeController.text;
      String itemVal = itemValuesController.text;
      var itemExpress = itemExpressPriceController.text;
      var itemVehicle = itemCalltruckPriceController.text;
      var itemtotal = int.parse(itemExpress) + int.parse(itemVehicle);
      String ItembillID = itembillcode.text;
      String ItembillHeader = itembillheader.text;

      //print(' billid $ItembillID billheader $ItembillHeader');

      SharedPreferences preferences = await SharedPreferences.getInstance();
      String tokenrider = preferences.getString('token')!;
      await Dio()
          .post('${MyConstant.urlapi}/caculatebilltotal',
              data: {
                "billid": "$ItembillID",
                "itemname": "$itemName",
                "types": "1",
                "weight": "$itemWeight",
                "sizes": "$itemSize",
                "quantity": "$itemVal",
                "totalbill": "$itemtotal",
                "currncy": "LAK",
                "exprice": "$itemExpress",
                "codprice": "0",
                "codst": "",
                "truckprice": "$itemVehicle",
                "headerbill": "$ItembillHeader"
              },
              options: Options(headers: <String, String>{
                'authorization': 'Bearer $tokenrider'
              }))
          .then((value) => Navigator.pop(context));
    }
  }
}
