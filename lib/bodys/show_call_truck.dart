import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scnexpress/models/calltruck_model.dart';
import 'package:scnexpress/states/check_calltruck.dart';
import 'package:scnexpress/utility/my_constant.dart';
import 'package:scnexpress/widgets/Show_title.dart';
import 'package:scnexpress/widgets/show_image.dart';
import 'package:scnexpress/widgets/show_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowCallTruck extends StatefulWidget {
  const ShowCallTruck({Key? key}) : super(key: key);

  @override
  State<ShowCallTruck> createState() => _ShowCallTruckState();
}

class _ShowCallTruckState extends State<ShowCallTruck> {
  bool load = true;
  bool? haveData;
  List<CallTruckListModel> calltruckModel = [];

  @override
  void initState() {
    super.initState();
    loadCallTruckAPI();
  }

  Future<Null> loadCallTruckAPI() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String tokenchar = preferences.getString('token')!;

    await Dio()
        .post('http://192.168.0.205:8081/api/calltruck',
            options: Options(headers: <String, String>{
              'authorization': 'Bearer $tokenchar'
            }))
        .then((value) {
      // print('This is truck API VAL: $value');

      if (value.toString() == 'null') {
        // nodata
        setState(() {
          haveData = false;
        });
      } else {
        // have data

        for (var item in value.data) {
          CallTruckListModel model = CallTruckListModel.fromMap(item);
          print('List item Call ===> ${model.bill_header}');

          setState(() {
            load = false;
            haveData = true;
            calltruckModel.add(model);
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
                          title: 'No call Truck',
                          textStyle: MyConstant().h1Style()),
                      ShowTitle(
                          title: 'no call truck to show',
                          textStyle: MyConstant().h2Style())
                    ],
                  ),
                ),
    );
  }

  ListView buildListView(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: calltruckModel.length,
      itemBuilder: (context, index) => Card(
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  width: constraints.maxWidth * 0.5 - 4,
                  height: constraints.maxHeight * 0.2,
                  child: ShowImage(path: MyConstant.image1),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(4),
              width: constraints.maxWidth * 0.5 - 4,
              height: constraints.maxWidth * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShowTitle(
                      title: '${calltruckModel[index].bill_header} ',
                      textStyle: MyConstant().h2Style()),
                  ShowTitle(
                      title:
                          'Price ${calltruckModel[index].bill_total.toString()} KIP',
                      textStyle: MyConstant().h3Style()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {
                            print('Click check List Item');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckCallTruck(
                                    callTruckListModel: calltruckModel[index],
                                  ),
                                ));
                          },
                          icon: Icon(
                            Icons.check_box_outlined,
                            size: 36,
                            color: MyConstant.dark,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.delete_outline,
                            size: 36,
                            color: MyConstant.dark,
                          )),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
