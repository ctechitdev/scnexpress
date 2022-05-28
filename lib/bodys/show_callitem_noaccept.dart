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
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tokenrider = preferences.getString('token')!;

    await Dio()
        .post('${MyConstant.urlapi}/showlistcallitemnoaccept',
            options: Options(headers: <String, String>{
              'authorization': 'Bearer $tokenrider'
            }))
        .then((value) {
      if (value.toString() == 'no data') {
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
              : Text('no have'),
    );
  }

  ListView BuildListView(BoxConstraints constraints) => ListView.builder(
        itemCount: showlistcallitemnoacceptModel.length,
        itemBuilder: (context, index) => Card(
          child: Row(
            children: [
              Container(
                  padding: EdgeInsets.all(4),
                  width: constraints.maxWidth * 0.3 - 4,
                  height: constraints.maxWidth * 0.3,
                  child: CircleAvatar(
                      radius: 100,
                      backgroundColor: MyConstant.dark,
                      child: const Text('ເລກທີ'))),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(4),
                width: constraints.maxWidth * 0.7 - 4,
                height: constraints.maxWidth * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShowTitle(
                      title:
                          'ເລກບິນ :${showlistcallitemnoacceptModel[index].inv_id}',
                      textStyle: MyConstant().h2Style(),
                    ),
                    ShowTitle(
                      title:
                          'ເລກບິນ :${showlistcallitemnoacceptModel[index].inv_total.toString()}',
                      textStyle: MyConstant().h2Style(),
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
                                ));
                          },
                          icon: Icon(
                            Icons.moped_outlined,
                            size: 36,
                            color: MyConstant.dark,
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
      );
}
