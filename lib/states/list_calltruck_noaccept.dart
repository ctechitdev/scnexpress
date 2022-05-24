import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scnexpress/models/listitem_noaccept_model.dart';
import 'package:scnexpress/models/show_callrider_notaccept_model.dart';
import 'package:scnexpress/states/rider_service.dart';
import 'package:scnexpress/utility/my_constant.dart';
import 'package:scnexpress/utility/my_dialog.dart';
import 'package:scnexpress/widgets/Show_title.dart';
import 'package:scnexpress/widgets/show_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListCalltruckNoAccept extends StatefulWidget {
  final CallRidderNotAcceptModel callRidderNotAcceptModel;
  const ListCalltruckNoAccept(
      {Key? key, required this.callRidderNotAcceptModel})
      : super(key: key);

  @override
  State<ListCalltruckNoAccept> createState() => _ListCalltruckNoAcceptState();
}

class _ListCalltruckNoAcceptState extends State<ListCalltruckNoAccept> {
  CallRidderNotAcceptModel? callRidderNotAcceptModel;

  bool load = true;
  bool? haveData;
  List<ListItemNoAcceptModel> listitemnoacceptModel = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callRidderNotAcceptModel = widget.callRidderNotAcceptModel;

    // print('data bill header is => ${callRidderNotAcceptModel!.bill_header}');
    Listitembillheader();
  }

  Future<Null> Listitembillheader() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tokenridder = preferences.getString('token')!;

    await Dio()
        .post('${MyConstant.urlapi}/calltrucklistitem',
            data: {"billheader": "${callRidderNotAcceptModel!.bill_header}"},
            options: Options(headers: <String, String>{
              'authorization': 'Bearer $tokenridder'
            }))
        .then((value) {
      if (value.toString() == 'null') {
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        for (var item in value.data) {
          ListItemNoAcceptModel model = ListItemNoAcceptModel.fromMap(item);
          print(' this is invoice item list ${model.bill_code}');
          setState(() {
            load = false;
            haveData = true;
            listitemnoacceptModel.add(model);
          });
        }
      }
    });
  }

  Future<Null> ridderAcceptItem() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tokenridder = preferences.getString('token')!;

    //print('token test => $tokenridder');

    await Dio()
        .post('${MyConstant.urlapi}/acceptcalltruck',
            data: {"billheader": "${callRidderNotAcceptModel!.bill_header}"},
            options: Options(headers: <String, String>{
              'authorization': 'Bearer $tokenridder'
            }))
        .then((value) {
      if (value.toString() == 'null') {
        MyDialog().normalDialog(context, 'User flase', 'please change user');
      } else {
        MyDialog().normalDialog(
            context, 'ຮັບລາຍການສຳເລັດ', 'ສາມາດກວດໄດ້ໃນຫນ້າກວດສອບສິນຄ້າ');
      }

      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ລາຍລະອຽດສິນຄ້າເອິ້ນລົດ'),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'ຫົວບິນ: ${callRidderNotAcceptModel!.bill_header}',
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: listitemnoacceptModel.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        border: Border.all(width: 3, color: MyConstant.dark)),
                    child: Column(
                      children: [
                        ShowTitle(
                          title:
                              'ເລກບິນ: ${listitemnoacceptModel[index].bill_code}',
                          textStyle: MyConstant().h2Style(),
                        ),
                        ShowTitle(
                          title:
                              'ຊື່ສິນຄ້າ: ${listitemnoacceptModel[index].mtl_name}',
                          textStyle: MyConstant().h2Style(),
                        ),
                        ShowTitle(
                          title:
                              'ນ້ຳໜັກ: ${listitemnoacceptModel[index].mtl_weight}',
                          textStyle: MyConstant().h2Style(),
                        ),
                        ShowTitle(
                          title:
                              'ຂະໜາດ: ${listitemnoacceptModel[index].mtl_size}',
                          textStyle: MyConstant().h2Style(),
                        ),
                        ShowTitle(
                          title:
                              'ຈຳນວນ: ${listitemnoacceptModel[index].mtl_am.toString()}',
                          textStyle: MyConstant().h2Style(),
                        ),
                        ShowTitle(
                          title:
                              'ລວມລາຄາ: ${listitemnoacceptModel[index].mtl_total_price} ${listitemnoacceptModel[index].ccy}',
                          textStyle: MyConstant().h2Style(),
                        ),
                        ShowTitle(
                          title:
                              'ວັນທີລົງທະບຽນ: ${listitemnoacceptModel[index].create_date}',
                          textStyle: MyConstant().h2Style(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  ridderAcceptItem();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RiderService(),
                      ));
                },
                child: Text('ຮັບລາຍການ'))
          ],
        ),
      ),
    );
  }
}
