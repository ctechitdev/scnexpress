import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scnexpress/models/calltruck_model.dart';
import 'package:scnexpress/models/listitem_calltruckcheck.dart';
import 'package:scnexpress/utility/my_constant.dart';
import 'package:scnexpress/widgets/Show_title.dart';

class CheckCallTruck extends StatefulWidget {
  final CallTruckListModel callTruckListModel;
  const CheckCallTruck({Key? key, required this.callTruckListModel})
      : super(key: key);

  @override
  State<CheckCallTruck> createState() => _CheckCallTruckState();
}

class _CheckCallTruckState extends State<CheckCallTruck> {
  CallTruckListModel? callTruckListModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callTruckListModel = widget.callTruckListModel;
    print('show Bill Header ==> ${callTruckListModel!.bill_header}');
    loadListItemCallTruckAPI();
  }

  Future<Null> loadListItemCallTruckAPI() async {
    await Dio().post('${MyConstant.urlapi}/calltrucklistitem',
        data: {"billheader": "SCNHBR-2203100004"}).then((value) {
      // print('show list bill values ==> $value');

      for (var item in value.data) {
        ListItemCallTruckCheckModel model =
            ListItemCallTruckCheckModel.fromMap(item);
        print("list item is ==> ${model.bill_code}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Item Call Item'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTitle('General : ${callTruckListModel!.bill_header}'),
              buildName(constraints),
            ],
          ),
        ),
      ),
    );
  }

  Row buildName(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Name Item',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildTitle(String title) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ShowTitle(title: title, textStyle: MyConstant().h2Style()),
        ),
      ],
    );
  }
}
