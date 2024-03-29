import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scnexpress/models/list_callitem_noaccept_model.dart';
import 'package:scnexpress/states/list_callitem_noaccept.dart';
import 'package:scnexpress/utility/my_constant.dart';
import 'package:scnexpress/widgets/Show_title.dart';
import 'package:scnexpress/widgets/show_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class showListCallItemNoaccept extends StatefulWidget {
  const showListCallItemNoaccept({Key? key}) : super(key: key);

  @override
  State<showListCallItemNoaccept> createState() =>
      _showListCallItemNoacceptState();
}

class _showListCallItemNoacceptState extends State<showListCallItemNoaccept> {
  bool load = true;
  bool? haveData;
  List<listCallItemNoAcceptModel> showlistcallitemnoacceptModel = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showCallItemNoaccept();
  }

  Future<Null> showCallItemNoaccept() async {
    if (showlistcallitemnoacceptModel.length != 0) {
      showlistcallitemnoacceptModel.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tokenrider = preferences.getString('token')!;

    await Dio()
        .post('${MyConstant.urlapi}/showlistcallitemnoaccept',
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
          listCallItemNoAcceptModel model =
              listCallItemNoAcceptModel.fromMap(item);
          setState(() {
            load = false;
            haveData = true;
            showlistcallitemnoacceptModel.add(model);
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
                  builder: (context, constraints) => BuildListView(constraints),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShowTitle(
                        title: 'ບໍມີລາຍການເອີ້ນສິນຄ້າສົງຮອດເຮືອນ',
                        textStyle: MyConstant().h1Style(),
                      ),
                      ShowTitle(
                          title: 'ກະລຸນາລໍຖ້າລູກຄ້າໃຊ່້ບໍລິການສົ່ງເຄື່ອງ',
                          textStyle: MyConstant().h2Style())
                    ],
                  ),
                ),
    );
  }

  ListView BuildListView(BoxConstraints constraints) => ListView.builder(
        itemCount: showlistcallitemnoacceptModel.length,
        itemBuilder: (context, index) => Container(
          margin: EdgeInsets.all(5),
          child: Card(
            color: Color(0xFFe8e8e8),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  width: constraints.maxWidth * 0.3 - 4,
                  height: constraints.maxWidth * 0.3,
                  child: Container(
                    decoration: new BoxDecoration(
                      color: MyConstant.primary,
                      borderRadius: new BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: const Text(
                        'SCN RIDER',
                        style: TextStyle(
                          fontFamily: 'Notosan',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.all(4),
                  width: constraints.maxWidth * 0.7 - 14,
                  height: constraints.maxWidth * 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ເລກບິນ :${showlistcallitemnoacceptModel[index].inv_id}',
                        style: TextStyle(
                          fontFamily: 'Notosan',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF6F00),
                        ),
                      ),
                      Text(
                        'ເລກບິນ :${showlistcallitemnoacceptModel[index].inv_total.toString()}',
                        style: TextStyle(
                          fontFamily: 'Notosan',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF6F00),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ListCallItemNoRidderAccept(
                                      listcallitemnoacceptModel:
                                          showlistcallitemnoacceptModel[index],
                                    ),
                                  )).then((value) => showCallItemNoaccept());
                            },
                            icon: Icon(
                              Icons.moped_outlined,
                              size: 36,
                              color: MyConstant.primary,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
