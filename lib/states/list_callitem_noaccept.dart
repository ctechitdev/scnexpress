import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scnexpress/function/maps_utils.dart';
import 'package:scnexpress/models/list_callitem_detail_model.dart';
import 'package:scnexpress/models/list_callitem_noaccept_model.dart';
import 'package:scnexpress/models/location_calltruck_model.dart';
import 'package:scnexpress/utility/my_constant.dart';
import 'package:scnexpress/widgets/Show_title.dart';
import 'package:scnexpress/widgets/show_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListCallItemNoRidderAccept extends StatefulWidget {
  final listCallItemNoAcceptModel listcallitemnoacceptModel;
  const ListCallItemNoRidderAccept(
      {Key? key, required this.listcallitemnoacceptModel})
      : super(key: key);

  @override
  State<ListCallItemNoRidderAccept> createState() =>
      _ListCallItemNoRidderAcceptState();
}

class _ListCallItemNoRidderAcceptState
    extends State<ListCallItemNoRidderAccept> {
  listCallItemNoAcceptModel? listItemcallNoacceptModel;

  bool load = true;
  bool? haveData;
  List<callItemToHomeDetailListModel> arrayCallItemList = [];
  List<locationCallRidderModel> arrayLocationModel = [];
  double? lat, lng;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listItemcallNoacceptModel = widget.listcallitemnoacceptModel;
    listCallItemDetail();
    findlatlng();
  }

  Future<Null> listCallItemDetail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tokenrider = preferences.getString('token')!;

    await Dio()
        .post('${MyConstant.urlapi}/showlistcallitemdetail',
            data: {"billinvoice": "${listItemcallNoacceptModel!.inv_id}"},
            options: Options(headers: <String, String>{
              'authorization': 'Bearer $tokenrider'
            }))
        .then((value) {
      if (value.toString() == 'null') {
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        for (var item in value.data) {
          callItemToHomeDetailListModel model =
              callItemToHomeDetailListModel.fromMap(item);
          setState(() {
            load = false;
            haveData = true;
            arrayCallItemList.add(model);
          });
        }
      }
    });
  }

  Future<Null> findlatlng() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tokenrider = preferences.getString('token')!;

    await Dio()
        .post('${MyConstant.urlapi}/locatecalltruck',
            data: {"billheaderid": "${listItemcallNoacceptModel!.inv_id}"},
            options: Options(headers: <String, String>{
              'authorization': 'Bearer $tokenrider'
            }))
        .then((value) {
      if (value.toString() == 'null') {
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        for (var item in value.data) {
          locationCallRidderModel model = locationCallRidderModel.fromMap(item);
          arrayLocationModel.add(model);
          setState(() {
            load = false;
            haveData = true;
            lat = model.landx;
            lng = model.landy;
          });
        }
      }
    });
  }

  Future<Null> recieveCalItemOrder() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tokenrider = preferences.getString('token')!;

    await Dio()
        .post('${MyConstant.urlapi}/acceptcallitem',
            data: {"billinvoice": "${listItemcallNoacceptModel!.inv_id}"},
            options: Options(headers: <String, String>{
              'authorization': 'Bearer $tokenrider'
            }))
        .then((value) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ລາຍການເອີ້ນສົ່ງສົນຄ້າຮອດເຮືອນ'),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Container(
                      margin: EdgeInsets.only(top: 3),
                      padding: EdgeInsets.all(4),
                      child: Text(
                          'ຫົວບິນ: ${listItemcallNoacceptModel!.inv_id}'))),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => buildListView(constraints),
              ),
            ),
            buildMap(),
            ElevatedButton(
                onPressed: () => recieveCalItemOrder(),
                child: Text('ຮັບລາຍການເອີ້ນເຄື່ອງ'))
          ],
        ),
      ),
    );
  }

  Set<Marker> setMarker() => <Marker>[
        Marker(
          markerId: MarkerId('id'),
          position: LatLng(lat!, lng!),
          infoWindow:
              InfoWindow(title: 'ທີ່ຢູ່ລູກຄ້າ', snippet: 'ທີ່ຢູ່ລູກຄ້າ'),
        )
      ].toSet();

  Widget buildMap() => Container(
        width: double.infinity,
        height: 200,
        child: lat == null
            ? ShowProgress()
            : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(lat!, lng!),
                  zoom: 16,
                ),
                myLocationEnabled: true,
                onMapCreated: (controller) {},
                markers: setMarker(),
                onTap: (argument) {
                  MapUtils.openMap(lat!, lng!);
                },
              ),
      );

  ListView buildListView(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: arrayCallItemList.length,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.all(4),
        child: Card(
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.all(5),
                width: constraints.maxWidth * 0.4 - 4,
                height: constraints.maxWidth * 0.4,
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(
                        'http://149.129.55.90/appicon/list-calltruck.jpeg'),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(4),
                width: constraints.maxWidth * 0.7 - 58,
                height: constraints.maxWidth * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ເລກບິນ: ${arrayCallItemList[index].bill_code}',
                      style: TextStyle(
                        fontFamily: 'Notosan',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6F00),
                      ),
                    ),
                    Text(
                      'ຊື່ສິນຄ້າ: ${arrayCallItemList[index].mtl_name}',
                      style: TextStyle(
                        fontFamily: 'Notosan',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6F00),
                      ),
                    ),
                    Text(
                      'ນ້ຳໜັກ: ${arrayCallItemList[index].mtl_weight}',
                      style: TextStyle(
                        fontFamily: 'Notosan',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6F00),
                      ),
                    ),
                    Text(
                      'ຂະຫນາດ: ${arrayCallItemList[index].mtl_size}',
                      style: TextStyle(
                        fontFamily: 'Notosan',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6F00),
                      ),
                    ),
                    Text(
                      'ຈຳນວນ: ${arrayCallItemList[index].mtl_am.toString()}',
                      style: TextStyle(
                        fontFamily: 'Notosan',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6F00),
                      ),
                    ),
                    Text(
                      'ລາຄາໃນບິນ: ${arrayCallItemList[index].mtl_total_price} ${arrayCallItemList[index].ccy}',
                      style: TextStyle(
                        fontFamily: 'Notosan',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6F00),
                      ),
                    ),
                    Text(
                      'ວັນທີລົງທະບຽນ :${arrayCallItemList[index].create_date}',
                      style: TextStyle(
                        fontFamily: 'Notosan',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6F00),
                      ),
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
