import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scnexpress/models/listitem_noaccept_model.dart';
import 'package:scnexpress/models/location_calltruck_model.dart';
import 'package:scnexpress/models/show_callrider_notaccept_model.dart';
import 'package:scnexpress/states/rider_service.dart';
import 'package:scnexpress/utility/my_constant.dart';
import 'package:scnexpress/utility/my_dialog.dart';
import 'package:scnexpress/widgets/Show_title.dart';
import 'package:scnexpress/widgets/show_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ListCalltruckNoAccept extends StatefulWidget {
  final CallRidderNotAcceptModel callRidderNotAcceptModel;
  const ListCalltruckNoAccept(
      {Key? key, required this.callRidderNotAcceptModel})
      : super(key: key);

  @override
  State<ListCalltruckNoAccept> createState() => _ListCalltruckNoAcceptState();
}

class _ListCalltruckNoAcceptState extends State<ListCalltruckNoAccept> {
  CallRidderNotAcceptModel? callRidderNotAcceptModel;

  bool load = true;
  bool? haveData;
  List<ListItemNoAcceptModel> listitemnoacceptModel = [];
  List<locationCallRidderModel> arrayLocationModel = [];
  double? lat, lng;

  final Set<Polyline> polyline = {};
  //List<LatLng> routeCoords;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callRidderNotAcceptModel = widget.callRidderNotAcceptModel;

    // print('data bill header is => ${callRidderNotAcceptModel!.bill_header}');
    Listitembillheader();
    checkperlicaion();
  }

  Future<Null> Listitembillheader() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tokenridder = preferences.getString('token')!;

    await Dio()
        .post('${MyConstant.urlapi}/calltrucklistitem',
            data: {"billheader": "${callRidderNotAcceptModel!.bill_header}"},
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
          // print(' this is invoice item list ${model.bill_code}');
          setState(() {
            load = false;
            haveData = true;
            listitemnoacceptModel.add(model);
          });
        }
      }
    });
  }

  Future<Null> findLocation() async {
    //print('find location work');
    Position? position = await findPosition();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tokenridder = preferences.getString('token')!;

    await Dio()
        .post('${MyConstant.urlapi}/locatecalltruck',
            data: {"billheaderid": "${callRidderNotAcceptModel!.bill_header}"},
            options: Options(headers: <String, String>{
              'authorization': 'Beaer $tokenridder'
            }))
        .then((value) {
      if (value.toString() == 'no data show') {
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

            // print('lat ==> $lat ===> long $lng');
          });
        }
      }
    });
  }

  Future<Position?> findPosition() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      return null;
    }
  }

  Future<Null> checkperlicaion() async {
    bool locationService;
    LocationPermission locationPermission;
    locationService = await Geolocator.isLocationServiceEnabled();

    if (locationService) {
      locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alertLocationService(
              context, 'ເປີດສິດນຳໃຊ້', 'ກະລຸນາເປີດນຳໃຊ້ສະຖານທີ');
        } else {
          //findlocation
          findLocation();
        }
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alertLocationService(
              context, 'ເປີດສິດນຳໃຊ້', 'ກະລຸນາເປີດນຳໃຊ້ສະຖານທີ');
        } else {
          //finlocation
          findLocation();
        }
      }
      // print('Service location is Open');
    } else {
      //  print('Location service not open');
      MyDialog().alertLocationService(
          context, 'ສິດເຂົ້າເຖິງທີ່ຢູ່', 'ກະລຸນາເປີດທີ່ຢູ່ໂທສັບ');
    }
  }

  Future<Null> ridderAcceptItem() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tokenridder = preferences.getString('token')!;

    //print('token test => $tokenridder');

    await Dio()
        .post('${MyConstant.urlapi}/acceptcalltruck',
            data: {"billheader": "${callRidderNotAcceptModel!.bill_header}"},
            options: Options(headers: <String, String>{
              'authorization': 'Bearer $tokenridder'
            }))
        .then((value) {
      if (value.toString() == 'null') {
        MyDialog().normalDialog(context, 'User flase', 'please change user');
      } else {
        MyDialog().normalDialog(
            context, 'ຮັບລາຍການສຳເລັດ', 'ສາມາດກວດໄດ້ໃນຫນ້າກວດສອບສິນຄ້າ');
      }

      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ລາຍລະອຽດສິນຄ້າເອິ້ນລົດ',
          style: TextStyle(
            fontFamily: 'Notosan',
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
          ),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'ຫົວບິນ: ${callRidderNotAcceptModel!.bill_header}',
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => buildListView(constraints),
              ),
            ),
            buildMap(),
            ElevatedButton(
                onPressed: () {
                  ridderAcceptItem();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RiderService(),
                      ));
                },
                child: Text('ຮັບລາຍການ'))
          ],
        ),
      ),
    );
  }

  ListView buildListView(constraints) {
    return ListView.builder(
      itemCount: listitemnoacceptModel.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(4),
          child: Card(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  width: constraints.maxWidth * 0.4 - 4,
                  height: constraints.maxWidth * 0.4,
                  decoration: new BoxDecoration(
                      color: MyConstant.primary,
                      borderRadius: new BorderRadius.circular(10),
                      image: DecorationImage(
                        image:
                            NetworkImage('http://149.129.55.90/scnexpress.jpg'),
                      )),
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
                        'ເລກບິນ: ${listitemnoacceptModel[index].bill_code}',
                        style: TextStyle(
                          fontFamily: 'Notosan',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF6F00),
                        ),
                      ),
                      Text(
                        'ຊື່ສິນຄ້າ: ${listitemnoacceptModel[index].mtl_name}',
                        style: TextStyle(
                          fontFamily: 'Notosan',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF6F00),
                        ),
                      ),
                      Text(
                        'ນ້ຳໜັກ: ${listitemnoacceptModel[index].mtl_weight}',
                        style: TextStyle(
                          fontFamily: 'Notosan',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF6F00),
                        ),
                      ),
                      Text(
                        'ຂະໜາດ: ${listitemnoacceptModel[index].mtl_size}',
                        style: TextStyle(
                          fontFamily: 'Notosan',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF6F00),
                        ),
                      ),
                      Text(
                        'ຈຳນວນ: ${listitemnoacceptModel[index].mtl_am.toString()}',
                        style: TextStyle(
                          fontFamily: 'Notosan',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF6F00),
                        ),
                      ),
                      Text(
                        'ລວມລາຄາ: ${listitemnoacceptModel[index].mtl_total_price} ${listitemnoacceptModel[index].ccy}',
                        style: TextStyle(
                          fontFamily: 'Notosan',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF6F00),
                        ),
                      ),
                      Text(
                        'ວັນທີ : ${listitemnoacceptModel[index].create_date}',
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
        );
      },
    );
  }

  Set<Marker> setMarker() => <Marker>[
        Marker(
          markerId: MarkerId('id'),
          position: LatLng(lat!, lng!),
          infoWindow: InfoWindow(
              title: 'ທີ່ຢູ່ລູກຄ້າ', snippet: 'lat = $lat, lng = $lng'),
        )
      ].toSet();

  Widget buildMap() => Container(
        color: MyConstant.dark,
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
                  openMap(lat!, lng!);
                },
              ),
      );

  Future<Null> openMap(double Latitude, double Longitude) async {
    String googleMapURL =
        "https://www.google.com/maps/search/?api=1&query=$Latitude,$Longitude";

    if (await canLaunch(googleMapURL)) {
      await launch(googleMapURL);
    } else {
      throw 'can not open map';
    }
  }
}
