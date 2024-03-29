import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scnexpress/models/listbill_detail_print_model.dart';
import 'package:scnexpress/models/listbillprint_model.dart';
import 'package:scnexpress/models/testBillprint_model.dart';
import 'package:scnexpress/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

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

  late PrinterStatus _printerStatus;
  late PrinterMode _printerMode;

  @override
  void initState() {
    super.initState();
    refbilllistSelect = widget.billlistModel;
    showListbillDetailPrint();

    _bindingPrinter().then((bool? isBind) async => {
          if (isBind!)
            {
              _getPrinterStatus(),
              _printerMode = await _getPrinterMode(),
            }
        });
  }

  /// must binding ur printer at first init in app
  Future<bool?> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }

  /// you can get printer status
  Future<void> _getPrinterStatus() async {
    final PrinterStatus result = await SunmiPrinter.getPrinterStatus();
    setState(() {
      _printerStatus = result;
    });
  }

  Future<PrinterMode> _getPrinterMode() async {
    final PrinterMode mode = await SunmiPrinter.getPrinterMode();
    return mode;
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
                onPressed: () async {
                  printerData('${refbilllistSelect!.inv_id}');
                },
                child: Text('ພິນບິນ'))
          ],
        ),
      ),
    );
  }

  final List<String> entries = <String>['A', 'B', 'C'];

  printerData(String bill_header) async {
    await SunmiPrinter.initPrinter();
    await SunmiPrinter.startTransactionPrint(true);
    String url = 'http://www.scngroup.la/appicon/test-pic2.jpg';
    Uint8List byte = (await NetworkAssetBundle(Uri.parse(url)).load(url))
        .buffer
        .asUint8List();
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.startTransactionPrint(true);
    await SunmiPrinter.printImage(byte);
    await SunmiPrinter.lineWrap(2);
    await SunmiPrinter.setCustomFontSize(35);

    await SunmiPrinter.printText('ບິນຝາກເຄື່ອງ', style: SunmiStyle(bold: true));

    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);

    await SunmiPrinter.resetFontSize();

    await SunmiPrinter.bold();
    await SunmiPrinter.line();
    for (var i = 0; i < arrayListDetailPrint.length; i++) {
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);

      await SunmiPrinter.printText('${arrayListDetailPrint[i].bill_code}',
          style: SunmiStyle(bold: true));

      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.printText('${arrayListDetailPrint[i].mtl_name}',
          style: SunmiStyle(bold: true));

      await SunmiPrinter.setCustomFontSize(20);

      await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);

      await SunmiPrinter.printText(
          'ຜູ້ຮັບ: ${arrayListDetailPrint[i].mtl_recipient_name}',
          style: SunmiStyle(bold: true));

      await SunmiPrinter.printText(
          'ເບິໂທ: ${arrayListDetailPrint[i].mtl_recipient_tel}',
          style: SunmiStyle(bold: true));

      await SunmiPrinter.printText(
          'ປາຍທາງ: ${arrayListDetailPrint[i].destination_branch_name}',
          style: SunmiStyle(bold: true));

      await SunmiPrinter.printText(
          'ເບີສາຂາ: ${arrayListDetailPrint[i].destination_branch_tel}',
          style: SunmiStyle(bold: true));

      await SunmiPrinter.printText('ລາຄາ: ${arrayListDetailPrint[i].from_pay}',
          style: SunmiStyle(bold: true));

      await SunmiPrinter.line();

      await SunmiPrinter.resetFontSize();
    }
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.printText('ລວມ ', style: SunmiStyle(bold: true));
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.printText('260,000', style: SunmiStyle(bold: true));
    await SunmiPrinter.lineWrap(2);
    await SunmiPrinter.exitTransactionPrint(true);
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
                            'ວັນທີ: ${arrayListDetailPrint[index].add_date}',
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
                      'ເລກບິນ: ${arrayListDetailPrint[index].bill_code}',
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
                                    Text(
                                        'ຊື່ຜຸ້ສົ່ງ: ${arrayListDetailPrint[index].mtl_cusdeposit_fname}'),
                                    Text(
                                        'ເບີໂທ: ${arrayListDetailPrint[index].mobi_cusdeposit_number}'),
                                    Text(
                                        'ທີ່ຢູ່ຜູ້ສົ່ງ: ${arrayListDetailPrint[index].origin_branch_name}'),
                                    Text(
                                        'ເບີໂທສາຂາ: ${arrayListDetailPrint[index].origin_branch_tel}'),
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
                                    Text(
                                        'ຊື່ຜຸ້ຮັບ: ${arrayListDetailPrint[index].mtl_recipient_name}'),
                                    Text(
                                        'ເບີໂທ: ${arrayListDetailPrint[index].mtl_recipient_tel}'),
                                    Text(
                                        'ທີ່ຢູ່ຜູ້ຮັບ: ${arrayListDetailPrint[index].destination_branch_name}'),
                                    Text(
                                        'ເບີໂທສາຂາ: ${arrayListDetailPrint[index].destination_branch_tel}'),
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
                        Container(
                            child: Text(
                                '${arrayListDetailPrint[index].mtl_name}')),
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
                              Text('${arrayListDetailPrint[index].mtl_am}'),
                            ],
                          ),
                        ),
                        Container(
                          width: constraints.maxWidth * 0.4 - 4,
                          height: constraints.maxWidth * 0.15,
                          child: Column(
                            children: [
                              Text('ປະເພດ'),
                              Text('${arrayListDetailPrint[index].mt_name}'),
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
                              Text('${arrayListDetailPrint[index].from_pay}'),
                            ],
                          ),
                        ),
                        Container(
                          width: constraints.maxWidth * 0.4 - 4,
                          height: constraints.maxWidth * 0.15,
                          child: Column(
                            children: [
                              Text('ຈ່າຍປາຍທາງ'),
                              Text('${arrayListDetailPrint[index].to_pay}'),
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
                            '${arrayListDetailPrint[index].tfs_name}',
                            style: TextStyle(
                              fontFamily: 'Notosan',
                              fontWeight: FontWeight.bold,
                              color: MyConstant.dark,
                              fontSize: 20,
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
