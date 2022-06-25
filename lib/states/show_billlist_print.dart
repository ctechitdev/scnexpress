import 'dart:io';
import 'dart:typed_data';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scnexpress/function/printbill.dart';
import 'package:scnexpress/models/listbill_detail_print_model.dart';
import 'package:scnexpress/models/listbillprint_model.dart';
import 'package:scnexpress/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class detailListBillPrint extends StatefulWidget {
  final billListSelectPrint billlistModel;
  const detailListBillPrint({Key? key, required this.billlistModel})
      : super(key: key);

  @override
  State<detailListBillPrint> createState() => _detailListBillPrintState();
}

class _detailListBillPrintState extends State<detailListBillPrint> {
  billListSelectPrint? refbilllistSelect;

  bool load = true;
  bool? haveData;
  List<listBillDetailPrintModel> arrayListDetailPrint = [];

  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  String? pathImage;

  printBill? testprint;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refbilllistSelect = widget.billlistModel;
    showListbillDetailPrint();
    initSavetoPath();
    testprint = printBill();
  }

  initSavetoPath() async {
    //read and write
    //image max 300px X 300px
    final filename = 'yourlogo.png';
    var bytes = await rootBundle.load('images/yourlogo.png');
    String dir = (await getApplicationDocumentsDirectory()).path;
    writeToFile(bytes, '$dir/$filename');
    setState(() {
      pathImage = '$dir/$filename';
    });
  }

  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future<void> writeToFileImage(Uint8List data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  printnew() async {
    String dir = (await getApplicationDocumentsDirectory()).path;

    testprint!.printInvoice(pathImage!);

//     if ((await printer.isConnected)!) {
//       printer.printNewLine();
//       printer.printCustom("HEADER", 3, 1);
//       printer.printNewLine();
//       printer.printLeftRight("test", "test123", 0);
//       printer.printImage(pathImage!);
//       //path of your image/logo
//       printer.printNewLine();
// //      bluetooth.printImageBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
//       // printer.printLeftRight("LEFT", "RIGHT", 0);
//       // printer.printLeftRight("LEFT", "RIGHT", 1);
//       // printer.printLeftRight("LEFT", "RIGHT", 1, format: "%-15s %15s %n");
//       // printer.printNewLine();
//       // printer.printLeftRight("LEFT", "RIGHT", 2);
//       // printer.printLeftRight("LEFT", "RIGHT", 3);
//       // printer.printLeftRight("LEFT", "RIGHT", 4);
//       // printer.printNewLine();
//       // printer.print3Column("Col1", "Col2", "Col3", 1);
//       // printer.print3Column("Col1", "Col2", "Col3", 1,
//       //     format: "%-10s %10s %10s %n");
//       // printer.printNewLine();
//       // printer.print4Column("Col1", "Col2", "Col3", "Col4", 1);
//       // printer.print4Column("Col1", "Col2", "Col3", "Col4", 1,
//       //     format: "%-8s %7s %7s %7s %n");
//       // printer.printNewLine();
//       // String testString = " čĆžŽšŠ-H-ščđ";
//       // printer.printCustom(testString, 1, 1, charset: "windows-1250");
//       // printer.printLeftRight("Številka:", "18000001", 1,
//       //     charset: "windows-1250");
//       // printer.printCustom("Body left", 1, 0);
//       // printer.printCustom("Body right", 0, 2);
//       // printer.printNewLine();
//       // String testString = " čĆžŽšŠ-H-ščđ";
//       // printer.printCustom(testString, 1, 1, charset: "windows-1250");

//       // printer.printLeftRight("Številka:", "18000001", 1,
//       //     charset: "windows-1250");

//       // printer.printNewLine();
//       // printer.printQRcode("Insert Your Own Text to Generate", 200, 200, 1);
//       // printer.printNewLine();
//       // printer.printNewLine();
//       // printer.paperCut();
//     }
  }

  Future<Null> showListbillDetailPrint() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tokenrider = preferences.getString('token')!;

    Dio()
        .post('${MyConstant.urlapi}/listbillprint',
            data: {"billheader": "${refbilllistSelect!.inv_id}"},
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
          listBillDetailPrintModel model =
              listBillDetailPrintModel.fromMap(item);
          setState(() {
            load = false;
            haveData = true;
            arrayListDetailPrint.add(model);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ລາຍການບິນທີ່ຈະພິນ'),
      ),
      //${refbilllistSelect!.inv_id}
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'ຫົວບິນ: ${refbilllistSelect!.inv_id}',
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => buildListview(constraints),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  printnew();
                },
                child: Text('ພິນບິນ'))
          ],
        ),
      ),
    );
  }

//arrayListDetailPrint[index].des_provin_name

  ListView buildListview(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: arrayListDetailPrint.length,
      itemBuilder: (context, index) => Container(
        padding: EdgeInsets.all(4),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(32.0),
                ),
                border: Border.all(width: 3, color: MyConstant.dark),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                      border: Border.all(width: 3, color: MyConstant.dark),
                      color: MyConstant.dark,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: constraints.maxWidth * 0.3,
                          height: constraints.maxWidth * 0.2,
                          child: Image(
                            image: NetworkImage(
                                'http://149.129.55.90/appicon/scnexpress.png'),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          width: constraints.maxWidth * 0.6,
                          height: constraints.maxWidth * 0.2,
                          child: Text(
                            'ວັນທີ: 22-06-2022',
                            style: TextStyle(
                              fontFamily: 'Notosan',
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFFFFF),
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: constraints.maxWidth * 0.2,
                    child: Text(
                      'ເລກບິນ: SCNL-012345678',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                            ),
                            border:
                                Border.all(width: 3, color: MyConstant.dark),
                          ),
                          width: constraints.maxWidth * 0.47,
                          height: constraints.maxWidth * 0.4,
                          child: Column(
                            children: [
                              Container(
                                width: constraints.maxWidth * 0.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(22),
                                  ),
                                  border: Border.all(
                                      width: 3, color: MyConstant.dark),
                                  color: MyConstant.dark,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'ຜູູ້ສົ່ງ',
                                  style: TextStyle(
                                    fontFamily: 'Notosan',
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('ຊື່ຜຸ້ສົ່ງ: ທົດລອງ'),
                                    Text('ເບີໂທ: 123456'),
                                    Text('ທີ່ຢູ່ຜູ້ສົ່ງ: ດອນກອຍ'),
                                    Text('ເບີໂທສາຂາ: 654321'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 7.6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              bottomLeft: Radius.circular(25),
                            ),
                            border:
                                Border.all(width: 3, color: MyConstant.dark),
                          ),
                          width: constraints.maxWidth * 0.47,
                          height: constraints.maxWidth * 0.4,
                          child: Column(
                            children: [
                              Container(
                                width: constraints.maxWidth * 0.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(22),
                                  ),
                                  border: Border.all(
                                      width: 3, color: MyConstant.dark),
                                  color: MyConstant.dark,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'ຜູ້ຮັບ',
                                  style: TextStyle(
                                    fontFamily: 'Notosan',
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('ຊື່ຜຸ້ຮັບ: ທົດລອງ'),
                                    Text('ເບີໂທ: 123456'),
                                    Text('ທີ່ຢູ່ຜູ້ຮັບ: ຫ້ວຍຫົງ'),
                                    Text('ເບີໂທສາຂາ: 654321'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Container(
                          child: Text('ພັດສະດຸ'),
                        ),
                        Container(child: Text('ຊື່ພັດສະດຸ')),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          width: constraints.maxWidth * 0.4 - 4,
                          height: constraints.maxWidth * 0.15,
                          child: Column(
                            children: [
                              Text('ຈຳນວນ'),
                              Text('5'),
                            ],
                          ),
                        ),
                        Container(
                          width: constraints.maxWidth * 0.4 - 4,
                          height: constraints.maxWidth * 0.15,
                          child: Column(
                            children: [
                              Text('ຂະໜາດ'),
                              Text('5kg/55cm'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          width: constraints.maxWidth * 0.4 - 4,
                          height: constraints.maxWidth * 0.15,
                          child: Column(
                            children: [
                              Text('ຈ່າຍຕົ້ນທາງ'),
                              Text('50.000'),
                            ],
                          ),
                        ),
                        Container(
                          width: constraints.maxWidth * 0.4 - 4,
                          height: constraints.maxWidth * 0.15,
                          child: Column(
                            children: [
                              Text('ຈ່າຍປາຍທາງ'),
                              Text('0'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          width: constraints.maxWidth * 0.45,
                          height: constraints.maxWidth * 0.15,
                          child: Text(
                            'ສະຖານະ',
                            style: TextStyle(
                              fontFamily: 'Notosan',
                              fontWeight: FontWeight.bold,
                              color: MyConstant.dark,
                              fontSize: 23,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 10),
                          alignment: Alignment.centerRight,
                          width: constraints.maxWidth * 0.5,
                          height: constraints.maxWidth * 0.15,
                          child: Text(
                            'ກຳລັງເຂົ້າສາງ',
                            style: TextStyle(
                              fontFamily: 'Notosan',
                              fontWeight: FontWeight.bold,
                              color: MyConstant.dark,
                              fontSize: 23,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                      border: Border.all(width: 3, color: MyConstant.dark),
                      color: MyConstant.dark,
                    ),
                    child: Container(
                      width: constraints.maxWidth,
                      height: constraints.maxWidth * 0.15,
                      child: Center(
                        child: Text(
                          'ຂອບໃຈ',
                          style: TextStyle(
                            fontFamily: 'Notosan',
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFFFFF),
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
