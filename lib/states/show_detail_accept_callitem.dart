import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scnexpress/models/accept_callitem_model.dart';
import 'package:scnexpress/models/listitem_calltruckcheck.dart';
import 'package:scnexpress/models/listitem_noaccept_model.dart';
import 'package:scnexpress/states/editcheckitemcallridder.dart';
import 'package:scnexpress/utility/my_constant.dart';
import 'package:scnexpress/widgets/Show_title.dart';
import 'package:scnexpress/widgets/show_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowListCallItemForCheck extends StatefulWidget {
  final AcceptCallTruckList acceptcalltrucklistModel;
  const ShowListCallItemForCheck(
      {Key? key, required this.acceptcalltrucklistModel})
      : super(key: key);

  @override
  State<ShowListCallItemForCheck> createState() =>
      _ShowListCallItemForCheckState();
}

class _ShowListCallItemForCheckState extends State<ShowListCallItemForCheck> {
  AcceptCallTruckList? acceptcalltruckModel;
  bool load = true;
  bool? haveData;
  List<ListItemNoAcceptModel> listitemnoacceptModel = [];

  @override
  void initState() {
    super.initState();
    acceptcalltruckModel = widget.acceptcalltrucklistModel;
    // print(  'item for list check bill id ==> ${acceptcalltruckModel!.bill_header}');

    ShowlistItemCallforChecking();
  }

  Future<Null> ShowlistItemCallforChecking() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tokenridder = preferences.getString('token')!;
    await Dio()
        .post('${MyConstant.urlapi}/calltrucklistitem',
            data: {"billheader": "${acceptcalltruckModel!.bill_header}"},
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
          print('this is model item ${model.bill_code}');
          setState(() {
            load = false;
            haveData = true;
            listitemnoacceptModel.add(model);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ລາຍການສິນຄ້າເພື່ອກວດສອບ'),
      ),
      body: load
          ? ShowProgress()
          : haveData!
              ? LayoutBuilder(
                  builder: (context, constraints) => buildListView(constraints),
                )
              : Text('No data'),
    );
  }

  ListView buildListView(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: listitemnoacceptModel.length,
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.all(8),
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            border: Border.all(width: 3, color: MyConstant.dark)),
        child: Column(
          children: [
            ShowTitle(
                title: '${listitemnoacceptModel[index].bill_code}',
                textStyle: MyConstant().h2Style()),
            ShowTitle(
                title: '${listitemnoacceptModel[index].mtl_name}',
                textStyle: MyConstant().h2Style()),
            ShowTitle(
                title: '${listitemnoacceptModel[index].mtl_weight}',
                textStyle: MyConstant().h2Style()),
            ShowTitle(
                title: '${listitemnoacceptModel[index].mtl_size}',
                textStyle: MyConstant().h2Style()),
            ShowTitle(
                title: '${listitemnoacceptModel[index].mtl_am.toString()}',
                textStyle: MyConstant().h2Style()),
            ShowTitle(
                title: '${listitemnoacceptModel[index].mtl_total_price}',
                textStyle: MyConstant().h2Style()),
            ShowTitle(
                title: '${listitemnoacceptModel[index].create_date}',
                textStyle: MyConstant().h2Style()),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckEditItemCallRider(
                          listitemDetailModel: listitemnoacceptModel[index],
                        ),
                      ));
                },
                icon: Icon(
                  Icons.edit_outlined,
                  size: 36,
                  color: MyConstant.dark,
                ))
          ],
        ),
      ),
    );
  }
}
