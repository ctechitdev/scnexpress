import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scnexpress/models/list_prepay_calltruck_medel.dart';
import 'package:scnexpress/states/show_list_prepay_calltruck.dart';
import 'package:scnexpress/utility/my_constant.dart';
import 'package:scnexpress/widgets/Show_title.dart';
import 'package:scnexpress/widgets/show_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowListCalltruckForPayByRidder extends StatefulWidget {
  const ShowListCalltruckForPayByRidder({Key? key}) : super(key: key);

  @override
  State<ShowListCalltruckForPayByRidder> createState() =>
      _ShowListCalltruckForPayByRidderState();
}

class _ShowListCalltruckForPayByRidderState
    extends State<ShowListCalltruckForPayByRidder> {
  bool load = true;
  bool? haveData;
  List<listPrepayCallTruckModel> listprepayModel = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadListforpayCalltruck();
  }

  Future<Null> loadListforpayCalltruck() async {
    if (listprepayModel.length != 0) {
      listprepayModel.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tokenrider = preferences.getString('token')!;
    await Dio()
        .post('${MyConstant.urlapi}/showcalltrucklistforpay',
            options: Options(headers: <String, String>{
              'authorization': 'Bearer $tokenrider'
            }))
        .then((value) {
      if (value.toString() == 'no data to show') {
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        for (var item in value.data) {
          listPrepayCallTruckModel model =
              listPrepayCallTruckModel.fromMap(item);

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
                        title: 'ບໍມີລາຍການກວດສອບສິນຄ້າພ້ອມເອີ້ນລົດ',
                        textStyle: MyConstant().h1Style(),
                      ),
                      ShowTitle(
                          title: 'ກະລຸນາກວດສອບຫນ້າກວດສອບສິນຄ້າ ແລະ ເອີ້ນລົດ',
                          textStyle: MyConstant().h2Style())
                    ],
                  ),
                ),
    );
  }

  ListView buildListView(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: listprepayModel.length,
      itemBuilder: (context, index) => Row(
        children: [
          Container(
            padding: EdgeInsets.all(4),
            width: constraints.maxWidth * 0.3 - 4,
            height: constraints.maxWidth * 0.3,
            child: CircleAvatar(
              radius: 1100,
              backgroundColor: MyConstant.dark,
              child: const Text('ລຳດັບທີ'),
            ),
          ),
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
                      title: 'ເລກຫົວບິນ: ${listprepayModel[index].bill_header}',
                      textStyle: MyConstant().h2Style()),
                  ShowTitle(
                      title:
                          'ລາຄາລວມ: ${listprepayModel[index].bill_total.toString()}',
                      textStyle: MyConstant().h2Style()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ShowListDetailPrepayCallTruck(
                                    listprepaycalltruckModel:
                                        listprepayModel[index],
                                  ),
                                ));
                          },
                          icon: Icon(
                            Icons.playlist_add_check_outlined,
                            size: 36,
                            color: MyConstant.dark,
                          ))
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
