import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scnexpress/models/listitem_noaccept_model.dart';
import 'package:scnexpress/models/show_callrider_notaccept_model.dart';
import 'package:scnexpress/utility/my_constant.dart';
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

    print('data bill header is => ${callRidderNotAcceptModel!.bill_header}');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ລາຍການເອີ້ນລົດຮັບສິນຄ້າ'),
      ),
      body: load
          ? ShowProgress()
          : haveData!
              ? ListView.builder(
                  itemCount: listitemnoacceptModel.length,
                  itemBuilder: (context, index) =>
                      Text(listitemnoacceptModel[index].bill_code.toString()),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShowTitle(
                        title: 'ບໍມີລາຍການ',
                        textStyle: MyConstant().h1Style(),
                      ),
                      ShowTitle(
                        title: 'ກະລຸນາກັບໄປເລືອກລາຍການຄືນໃຫມ່',
                        textStyle: MyConstant().h2Style(),
                      )
                    ],
                  ),
                ),
    );
  }
}
