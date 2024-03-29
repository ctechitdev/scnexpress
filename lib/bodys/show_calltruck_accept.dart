import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scnexpress/models/accept_callitem_model.dart';
import 'package:scnexpress/states/show_detail_accept_calltruck.dart';
import 'package:scnexpress/utility/my_constant.dart';
import 'package:scnexpress/widgets/Show_title.dart';
import 'package:scnexpress/widgets/show_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowAcceptCallItemRidder extends StatefulWidget {
  const ShowAcceptCallItemRidder({Key? key}) : super(key: key);

  @override
  State<ShowAcceptCallItemRidder> createState() =>
      _ShowAcceptCallItemRidderState();
}

class _ShowAcceptCallItemRidderState extends State<ShowAcceptCallItemRidder> {
  bool load = true;
  bool? haveData;
  List<AcceptCallTruckList> acceptcallModel = [];

  @override
  void initState() {
    super.initState();
    showListAcceptCallitem();
  }

  Future<Null> showListAcceptCallitem() async {
    if (acceptcallModel.length != 0) {
      acceptcallModel.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tokenridder = preferences.getString('token')!;
    await Dio()
        .post('${MyConstant.urlapi}/listcalltruckaccepted',
            options: Options(headers: <String, String>{
              'authorization': 'Bearer $tokenridder'
            }))
        .then((value) {
      if (value.toString() == 'no item') {
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        //  print('this is list bill accespt=> $value');

        for (var item in value.data) {
          AcceptCallTruckList model = AcceptCallTruckList.fromMap(item);
          //  print('List accept===> ${model.bill_header}');
          setState(() {
            load = false;
            haveData = true;
            acceptcallModel.add(model);
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
                  builder: (context, constraints) => buildListView(constraints),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShowTitle(
                        title: 'ບໍມີລາຍການຮັບອໍເດີ້ເອີ້ນລົດ',
                        textStyle: MyConstant().h1Style(),
                      ),
                      ShowTitle(
                          title: 'ກະລຸນາກວດສອບຫນ້າຮັບເອີ້ນລົດ',
                          textStyle: MyConstant().h2Style())
                    ],
                  ),
                ),
    );
  }

  ListView buildListView(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: acceptcallModel.length,
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
                      'ເລກຫົວບິນ: ${acceptcallModel[index].bill_header}',
                      style: TextStyle(
                        fontFamily: 'Notosan',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6F00),
                      ),
                    ),
                    Text(
                      'ລາຄາລວມ: ${acceptcallModel[index].bill_total.toString()} ກີບ',
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
                                        ShowListCallItemForCheck(
                                      acceptcalltrucklistModel:
                                          acceptcallModel[index],
                                    ),
                                  )).then((value) => showListAcceptCallitem());
                            },
                            icon: Icon(
                              Icons.playlist_add_check_outlined,
                              size: 36,
                              color: MyConstant.primary,
                            )),
                        IconButton(
                            onPressed: () {
                              //      print(  'cancel bill header to no accept is ${acceptcallModel[index].bill_header}');
                            },
                            icon: Icon(
                              Icons.auto_delete_outlined,
                              size: 36,
                              color: MyConstant.primary,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
