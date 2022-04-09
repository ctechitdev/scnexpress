import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scnexpress/models/calltruck_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowCallTruck extends StatefulWidget {
  const ShowCallTruck({Key? key}) : super(key: key);

  @override
  State<ShowCallTruck> createState() => _ShowCallTruckState();
}

class _ShowCallTruckState extends State<ShowCallTruck> {
  @override
  void initState() {
    super.initState();
    loadCallTruckAPI();
  }

  Future<Null> loadCallTruckAPI() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String tokenchar = preferences.getString('token')!;

    await Dio()
        .post('http://192.168.1.9:8081/api/calltruck',
            options: Options(headers: <String, String>{
              'authorization': 'Bearer $tokenchar'
            }))
        .then((value) {
      // print('This is truck API VAL: $value');
      for (var item in value.data) {
        CallTruckListModel model = CallTruckListModel.fromMap(item);
        print('List item Call ===> ${model.bill_header}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('This is Show Call Truck'),
    );
  }
}
