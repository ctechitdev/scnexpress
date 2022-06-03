import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scnexpress/models/list_callitem_accepted_model.dart';
import 'package:scnexpress/states/list_callitem_detail.dart';
import 'package:scnexpress/utility/my_constant.dart';
import 'package:scnexpress/widgets/Show_title.dart';
import 'package:scnexpress/widgets/show_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class showListCallItemAcepted extends StatefulWidget {
  const showListCallItemAcepted({Key? key}) : super(key: key);

  @override
  State<showListCallItemAcepted> createState() =>
      _showListCallItemAceptedState();
}

class _showListCallItemAceptedState extends State<showListCallItemAcepted> {
  bool load = true;
  bool? haveData;
  List<listCallItemAcceptedModel> arrayCallItemAcceptModel = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listAcceptCallItemData();
  }

  Future<Null> listAcceptCallItemData() async {
    if (arrayCallItemAcceptModel.length != 0) {
      arrayCallItemAcceptModel.clear();
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tokenrider = preferences.getString('token')!;

    await Dio()
        .post('${MyConstant.urlapi}/showinvoicecallaccept',
            options: Options(headers: <String, String>{
              'authorization': 'Bearer $tokenrider'
            }))
        .then((value) {
      if (value.toString() == 'no data show') {
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        for (var item in value.data) {
          listCallItemAcceptedModel model =
              listCallItemAcceptedModel.fromMap(item);
          setState(() {
            load = false;
            haveData = true;
            arrayCallItemAcceptModel.add(model);
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
                  builder: (context, constraints) => buildListVIew(constraints),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShowTitle(
                          title: 'ບໍ່ມີລາຍການກວດສອບເອີ້ນສິນຄ້າ',
                          textStyle: MyConstant().h1Style()),
                      ShowTitle(
                          title: 'ກະລຸນາກວດລາຍການເອີ້ນສິນຄ້າ',
                          textStyle: MyConstant().h2Style())
                    ],
                  ),
                ),
    );
  }

  ListView buildListVIew(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: arrayCallItemAcceptModel.length,
      itemBuilder: (context, index) => Row(
        children: [
          Container(
              padding: EdgeInsets.all(4),
              width: constraints.maxWidth * 0.3 - 4,
              height: constraints.maxWidth * 0.3,
              child: CircleAvatar(
                radius: 100,
                backgroundColor: MyConstant.dark,
                child: const Text('ລຳດັບທີ'),
              )),
          Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(4),
            width: constraints.maxWidth * 0.7 - 4,
            height: constraints.maxWidth * 0.3,
            child: Column(
              children: [
                ShowTitle(
                    title: 'ເລກບິນ: ${arrayCallItemAcceptModel[index].inv_id}',
                    textStyle: MyConstant().h2Style()),
                ShowTitle(
                    title:
                        'ລາຄາ: ${arrayCallItemAcceptModel[index].inv_total.toString()}',
                    textStyle: MyConstant().h2Style()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => showListCallItemDetail(
                                  parentValueModel:
                                      arrayCallItemAcceptModel[index],
                                ),
                              )).then((value) => listAcceptCallItemData());
                        },
                        icon: Icon(
                          Icons.playlist_add_check_outlined,
                          size: 36,
                          color: MyConstant.dark,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.auto_delete_outlined,
                          size: 36,
                          color: MyConstant.dark,
                        ))
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
