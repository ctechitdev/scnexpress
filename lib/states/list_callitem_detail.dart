import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scnexpress/function/maps_utils.dart';
import 'package:scnexpress/models/list_callitem_accepted_model.dart';
import 'package:scnexpress/models/location_calltruck_model.dart';
import 'package:scnexpress/models/show_callitemdetail_list.dart';
import 'package:scnexpress/states/show_detail_callitem_edit.dart';
import 'package:scnexpress/utility/my_constant.dart';
import 'package:scnexpress/widgets/Show_title.dart';
import 'package:scnexpress/widgets/show_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class showListCallItemDetail extends StatefulWidget {
  final listCallItemAcceptedModel parentValueModel;
  const showListCallItemDetail({Key? key, required this.parentValueModel})
      : super(key: key);

  @override
  State<showListCallItemDetail> createState() => _showListCallItemDetailState();
}

class _showListCallItemDetailState extends State<showListCallItemDetail> {
  listCallItemAcceptedModel? listcallitemRefmodel;
  bool load = true;
  bool? haveData;
  List<showCallItemdetaillistModel> arrayListItemDetailModel = [];
  List<locationCallRidderModel> arrayLocationModel = [];
  double? lat, lng;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listcallitemRefmodel = widget.parentValueModel;
    showCallItemDetailList();
    findLatlng();
  }

  Future<Null> showCallItemDetailList() async {
    if (arrayListItemDetailModel.length != 0) {
      arrayListItemDetailModel.clear();
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tokenrider = preferences.getString('token')!;
    await Dio()
        .post('${MyConstant.urlapi}/showacceptitemdetaillist',
            data: {"invoiceheader": "${listcallitemRefmodel!.inv_id}"},
            options: Options(headers: <String, String>{
              'authorization': 'Bearer $tokenrider'
            }))
        .then((value) {
      if (value.toString() == 'no item') {
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        for (var item in value.data) {
          showCallItemdetaillistModel model =
              showCallItemdetaillistModel.fromMap(item);
          setState(() {
            load = false;
            haveData = true;
            arrayListItemDetailModel.add(model);
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
            data: {"billheaderid": "${listcallitemRefmodel!.inv_id}"},
            options: Options(headers: <String, String>{
              'authorization': 'Bearer $tokenrider'
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ລາຍການລາຍລະອຽດສິນຄ້າ'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(8),
              child: Text('ຫົວບິນເອິ້ນສິນຄ້າ: ${listcallitemRefmodel!.inv_id}'),
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
                confirmchecking();
                Navigator.pop(context);
              },
              child: Text('ຢືນຢັນກວດສອບລາຍການ'))
        ],
      ),
    );
  }

  Set<Marker> setMarker() => <Marker>[
        Marker(
          markerId: MarkerId('id'),
          position: LatLng(lat!, lng!),
          infoWindow:
              InfoWindow(title: 'ທີ່ຢູ່ລຸກຄ້າ', snippet: 'ທີ່ຢູ່ລຸກຄ້າ'),
        ),
      ].toSet();

  Widget buildMap() => Container(
      color: MyConstant.dark,
      width: double.infinity,
      height: 200,
      child: lat == null
          ? ShowProgress()
          : GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: LatLng(lat!, lng!), zoom: 16),
              myLocationEnabled: true,
              onMapCreated: (controller) {},
              markers: setMarker(),
              onTap: (argument) {
                MapUtils.openMap(lat!, lng!);
              },
            ));

  Future<Null> confirmchecking() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tokenrider = preferences.getString('token')!;
    await Dio().post('${MyConstant.urlapi}/confirmcheckcallitem',
        data: {"billinvoice": "${listcallitemRefmodel!.inv_id}"},
        options: Options(
            headers: <String, String>{'authorization': 'Bearer $tokenrider'}));
  }

  ListView buildListView(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: arrayListItemDetailModel.length,
      itemBuilder: (context, index) => Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(width: 3, color: MyConstant.dark),
          ),
          child: Column(
            children: [
              ShowTitle(
                title: 'ເລກບິນ: ${arrayListItemDetailModel[index].bill_code}',
                textStyle: MyConstant().h2Style(),
              ),
              ShowTitle(
                title: 'ຊື່ສິນຄ້າ: ${arrayListItemDetailModel[index].mtl_name}',
                textStyle: MyConstant().h2Style(),
              ),
              ShowTitle(
                title: 'ນ້ຳໜັກ: ${arrayListItemDetailModel[index].mtl_weight}',
                textStyle: MyConstant().h2Style(),
              ),
              ShowTitle(
                title: 'ຂະໜາດ: ${arrayListItemDetailModel[index].mtl_size}',
                textStyle: MyConstant().h2Style(),
              ),
              ShowTitle(
                title:
                    'ຈຳນວນ: ${arrayListItemDetailModel[index].mtl_am.toString()}',
                textStyle: MyConstant().h2Style(),
              ),
              ShowTitle(
                title:
                    'ລາຄາ: ${arrayListItemDetailModel[index].mtl_total_price} ${arrayListItemDetailModel[index].ccy}',
                textStyle: MyConstant().h2Style(),
              ),
              ShowTitle(
                title:
                    'ວັນທີ່່ລົງທະບຽນ: ${arrayListItemDetailModel[index].create_date}',
                textStyle: MyConstant().h2Style(),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => showDetailCallItemForEdit(
                            parentValueModel: arrayListItemDetailModel[index],
                          ),
                        )).then((value) => showCallItemDetailList());
                  },
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 36,
                    color: MyConstant.dark,
                  ))
            ],
          )),
    );
  }
}
