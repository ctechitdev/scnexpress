import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scnexpress/function/maps_utils.dart';
import 'package:scnexpress/models/accept_callitem_model.dart';
import 'package:scnexpress/models/listitem_calltruckcheck.dart';
import 'package:scnexpress/models/listitem_noaccept_model.dart';
import 'package:scnexpress/models/location_calltruck_model.dart';
import 'package:scnexpress/states/editcheckitemcallridder.dart';
import 'package:scnexpress/utility/my_constant.dart';
import 'package:scnexpress/widgets/Show_title.dart';
import 'package:scnexpress/widgets/show_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowListCallItemForCheck extends StatefulWidget {
  final AcceptCallTruckList acceptcalltrucklistModel;
  const ShowListCallItemForCheck(
      {Key? key, required this.acceptcalltrucklistModel})
      : super(key: key);

  @override
  State<ShowListCallItemForCheck> createState() =>
      _ShowListCallItemForCheckState();
}

class _ShowListCallItemForCheckState extends State<ShowListCallItemForCheck> {
  AcceptCallTruckList? acceptcalltruckModel;
  bool load = true;
  bool? haveData;
  List<ListItemNoAcceptModel> listitemnoacceptModel = [];
  List<locationCallRidderModel> arrayLocationModel = [];
  double? lat, lng;

  @override
  void initState() {
    super.initState();
    acceptcalltruckModel = widget.acceptcalltrucklistModel;
    // print(  'item for list check bill id ==> ${acceptcalltruckModel!.bill_header}');

    ShowlistItemCallforChecking();
    findLatlng();
  }

  Future<Null> ShowlistItemCallforChecking() async {
    if (listitemnoacceptModel.length != 0) {
      listitemnoacceptModel.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tokenridder = preferences.getString('token')!;
    await Dio()
        .post('${MyConstant.urlapi}/calltrucklistitem',
            data: {"billheader": "${acceptcalltruckModel!.bill_header}"},
            options: Options(headers: <String, String>{
              'authorization': 'Bearer $tokenridder'
            }))
        .then((value) {
      if (value.toString() == 'null') {
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        for (var item in value.data) {
          ListItemNoAcceptModel model = ListItemNoAcceptModel.fromMap(item);
          // print('this is model item ${model.bill_code}');
          setState(() {
            load = false;
            haveData = true;
            listitemnoacceptModel.add(model);
          });
        }
      }
    });
  }

  Future<Null> findLatlng() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tokenrider = preferences.getString('token')!;

    await Dio()
        .post('${MyConstant.urlapi}/locatecalltruck',
            data: {"billheaderid": "${acceptcalltruckModel!.bill_header}"},
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
          setState(() {
            load = false;
            haveData = true;
            arrayLocationModel.add(model);
            setState(() {
              load = false;
              haveData = true;
              lat = model.landx;
              lng = model.landy;
              //print('accept lat ==> $lat ===> long $lng');
            });
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ລາຍການສິນຄ້າເພື່ອກວດສອບ'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => buildListView(constraints),
              ),
            ),
            buildMap(),
            ElevatedButton(
                onPressed: () {
                  updateToPrepayCallTruck();
                  Navigator.pop(context);
                },
                child: Text('ຢືນຢັນການກວດສອບ'))
          ],
        ));
  }

  Set<Marker> setMarker() => <Marker>[
        Marker(
          markerId: MarkerId('id'),
          position: LatLng(lat!, lng!),
          infoWindow: InfoWindow(title: 'ທີ່ຢູ່ບ່ອນນີ້', snippet: 'ບ່ອນນີ້'),
        )
      ].toSet();

  Widget buildMap() => Container(
        color: Colors.grey,
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

  Future<Null> updateToPrepayCallTruck() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tokenridder = preferences.getString('token')!;
    await Dio()
        .post('${MyConstant.urlapi}/confirmcheckcalltruck',
            data: {"bheader": "${acceptcalltruckModel!.bill_header}"},
            options: Options(headers: <String, String>{
              'authorization': 'Bearer $tokenridder'
            }))
        .then((value) => print('$value'));
  }

  ListView buildListView(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: listitemnoacceptModel.length,
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.all(8),
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            border: Border.all(width: 3, color: MyConstant.dark)),
        child: Column(
          children: [
            ShowTitle(
                title: '${listitemnoacceptModel[index].bill_code}',
                textStyle: MyConstant().h2Style()),
            ShowTitle(
                title: '${listitemnoacceptModel[index].mtl_name}',
                textStyle: MyConstant().h2Style()),
            ShowTitle(
                title: '${listitemnoacceptModel[index].mtl_weight}',
                textStyle: MyConstant().h2Style()),
            ShowTitle(
                title: '${listitemnoacceptModel[index].mtl_size}',
                textStyle: MyConstant().h2Style()),
            ShowTitle(
                title: '${listitemnoacceptModel[index].mtl_am.toString()}',
                textStyle: MyConstant().h2Style()),
            ShowTitle(
                title: '${listitemnoacceptModel[index].mtl_total_price}',
                textStyle: MyConstant().h2Style()),
            ShowTitle(
                title: '${listitemnoacceptModel[index].create_date}',
                textStyle: MyConstant().h2Style()),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckEditItemCallRider(
                          listitemDetailModel: listitemnoacceptModel[index],
                        ),
                      )).then((value) => ShowlistItemCallforChecking());
                },
                icon: Icon(
                  Icons.edit_outlined,
                  size: 36,
                  color: MyConstant.dark,
                ))
          ],
        ),
      ),
    );
  }
}
