import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scnexpress/models/show_callrider_notaccept_model.dart';
import 'package:scnexpress/states/list_calltruck_noaccept.dart';
import 'package:scnexpress/utility/my_constant.dart';
import 'package:scnexpress/widgets/Show_title.dart';
import 'package:scnexpress/widgets/show_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class showCallRidderNoneAccept extends StatefulWidget {
  const showCallRidderNoneAccept({Key? key}) : super(key: key);

  @override
  State<showCallRidderNoneAccept> createState() =>
      _showCallRidderNoneAcceptState();
}

class _showCallRidderNoneAcceptState extends State<showCallRidderNoneAccept> {
  bool load = true;
  bool? haveData;
  List<CallRidderNotAcceptModel> callridernotacceptModel = [];

  @override
  void initState() {
    super.initState();
    showCallRiderNoAccept();
  }

  Future<Null> showCallRiderNoAccept() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tokenRidder = preferences.getString('token')!;

    await Dio()
        .post('${MyConstant.urlapi}/calltruck',
            options: Options(headers: <String, String>{
              'authorization': 'Bearere $tokenRidder'
            }))
        .then((value) {
      if (value.toString() == 'no item') {
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        for (var item in value.data) {
          CallRidderNotAcceptModel model =
              CallRidderNotAcceptModel.fromMap(item);
          //  print('show Item =>>  ${model.bill_header}');

          setState(() {
            load = false;
            haveData = true;
            callridernotacceptModel.add(model);
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
                        title: 'ບໍມີລາຍການເອີ້ນລົດ',
                        textStyle: MyConstant().h1Style(),
                      ),
                      ShowTitle(
                          title: 'ລໍຖ້າລູກຄ້ານຳໃຊ້ບໍລິການ',
                          textStyle: MyConstant().h2Style())
                    ],
                  ),
                ),
    );
  }

  ListView buildListView(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: callridernotacceptModel.length,
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
                      title:
                          'ເລກບິນ: ${callridernotacceptModel[index].bill_header}',
                      textStyle: MyConstant().h2Style()),
                  ShowTitle(
                      title:
                          'ລາຄາລວມ ${callridernotacceptModel[index].bill_total.toString()} ກີບ',
                      textStyle: MyConstant().h3Style()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {
                            print(
                                'click show list = ${callridernotacceptModel[index].bill_header}');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ListCalltruckNoAccept(
                                    callRidderNotAcceptModel:
                                        callridernotacceptModel[index],
                                  ),
                                ));
                          },
                          icon: Icon(
                            Icons.moped_outlined,
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
