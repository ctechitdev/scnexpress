import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

    // Dio dio = new Dio();
    // Dio().options.headers["authorization"] = "Bearer $tokenchar";
    // var response = await dio.post("http://192.168.1.9:8081/api/calltruck");
    // print(response);

    await Dio()
        .post('http://192.168.1.9:8081/api/calltruck',
            options: Options(headers: <String, String>{
              'authorization': 'Bearer $tokenchar'
            }))
        .then((value) => print('This is truck API VAL: $value'));

    // var dio = Dio();
    // var tokenDio = Dio();
    // String? csrfToken;
    // dio.options.baseUrl = '192.168.1.9:8081/api/posts';
    // tokenDio.options = dio.options;
    // dio.interceptors.add(QueuedInterceptorsWrapper(
    //   onRequest: (options, handler) {
    //     print('send request：path:${options.path}，baseURL:${options.baseUrl}');
    //     if (csrfToken == null) {
    //       print('no token，request token firstly...');
    //       tokenDio.get('/token').then((d) {
    //         options.headers['Authorization'] =
    //             csrfToken = d.data['Bearer ']['token'];
    //         print(
    //             'request token succeed, value: ' + d.data['Bearer ']['token']);
    //         print(
    //             'continue to perform request：path:${options.path}，baseURL:${options.path}');
    //         handler.next(options);
    //       }).catchError((error, stackTrace) {
    //         handler.reject(error, true);
    //       });
    //     } else {
    //       options.headers['Authorization'] = csrfToken;
    //       return handler.next(options);
    //     }
    //   },
    // ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('This is Show Call Truck'),
    );
  }
}
