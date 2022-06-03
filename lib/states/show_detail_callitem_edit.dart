import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scnexpress/models/show_callitem_detail_edit.dart';
import 'package:scnexpress/models/show_callitemdetail_list.dart';
import 'package:scnexpress/utility/my_constant.dart';
import 'package:scnexpress/widgets/Show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class showDetailCallItemForEdit extends StatefulWidget {
  final showCallItemdetaillistModel parentValueModel;
  const showDetailCallItemForEdit({Key? key, required this.parentValueModel})
      : super(key: key);

  @override
  State<showDetailCallItemForEdit> createState() =>
      _showDetailCallItemForEditState();
}

class _showDetailCallItemForEditState extends State<showDetailCallItemForEdit> {
  showCallItemdetaillistModel? callItemlistRefModel;
  bool load = true;
  bool? haveData;
  List<showCallItemDetailForEdit> arrayCallItemDetail = [];
  TextEditingController billControl = TextEditingController();
  TextEditingController vehicleController = TextEditingController();
  TextEditingController billTotalControl = TextEditingController();
  TextEditingController invoiceControl = TextEditingController();
  TextEditingController expressControl = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callItemlistRefModel = widget.parentValueModel;
    showDetailItemCall();
  }

  Future<Null> showDetailItemCall() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tokenrider = preferences.getString('token')!;

    await Dio()
        .post('${MyConstant.urlapi}/showdetailitemcall',
            data: {"billid": "${callItemlistRefModel!.bill_code}"},
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
          showCallItemDetailForEdit model =
              showCallItemDetailForEdit.fromMap(item);
          setState(() {
            load = false;
            haveData = true;
            arrayCallItemDetail.add(model);
            vehicleController.text = model.callitem_price.toString();

            billControl.text = model.bill_code;
            billTotalControl.text = model.mtl_total_price;
            invoiceControl.text = model.callitem_price.toString();
            expressControl.text = model.express_price.toString();
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ກວດສອບສົ່ງເຄື່ອງຮອດບ້ານ'),
      ),
      body: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'data ${callItemlistRefModel!.bill_code}',
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => buildListView(constraints),
            ),
          ),
          ElevatedButton.icon(
              onPressed: () {
                updatedata();
              },
              icon: Icon(Icons.edit),
              label: Text('ແກ້ໄຂຄ່າສົ່ງ')),
        ],
      )),
    );
  }

  ListView buildListView(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: arrayCallItemDetail.length,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              border: Border.all(width: 3, color: MyConstant.dark)),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                buildTitle('ເລກບິນ: ${arrayCallItemDetail[index].bill_code}'),
                buildTitle('ຊື່ສິນຄ້າ: ${arrayCallItemDetail[index].mtl_name}'),
                buildTitle('ນ້ຳໜັກ: ${arrayCallItemDetail[index].mtl_weight}'),
                buildTitle(
                    'ຈຳນວນ: ${arrayCallItemDetail[index].mtl_am.toString()}'),
                buildTitle(
                    'ລາຄາລວມ: ${arrayCallItemDetail[index].mtl_total_price}'),
                buildName(constraints),
              ],
            ),
          ),
        );
      },
    );
  }

  Row buildName(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'ກະລູນາຕື່ມຂໍ່ມູນ';
              } else {
                return null;
              }
            },
            keyboardType: TextInputType.number,
            controller: vehicleController,
            decoration: InputDecoration(
              labelText: 'ລາຄາຂົນສົ່ງເຄື່ອງ',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowTitle(
          title: title,
          textStyle: MyConstant().h2Style(),
        ),
      ],
    );
  }

  updatedata() async {
    if (formKey.currentState!.validate()) {
      String vehicle = vehicleController.text;
      String billnumber = billControl.text;
      String totalprice = billTotalControl.text;
      String invoiceheader = invoiceControl.text;
      String expressprice = expressControl.text;

      var itemtotal =
          int.parse(expressprice) + int.parse(vehicle) + int.parse(totalprice);

      print('$vehicle');
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String tokenrider = preferences.getString('token')!;

      await Dio()
          .post('${MyConstant.urlapi}/caculatecheckcallitem',
              data: {
                "billid": "$billnumber",
                "callitemprice": "$vehicle",
                "totalprice": "$itemtotal",
                "invoicecallitem": "$invoiceheader"
              },
              options: Options(headers: <String, String>{
                'authorization': 'Bearer $tokenrider'
              }))
          .then((value) => Navigator.pop(context));
    }
  }
}
