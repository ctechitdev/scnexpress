import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

class capTurepage extends StatefulWidget {
  const capTurepage({Key? key}) : super(key: key);

  @override
  State<capTurepage> createState() => _capTurepageState();
}

class _capTurepageState extends State<capTurepage> {
  ScreenshotController screenshotController = ScreenshotController();
  String? pathImage;

  late PrinterStatus _printerStatus;
  late PrinterMode _printerMode;

  ScreenshotController screenshotControllerImage = ScreenshotController();
  ScreenshotController screenshotControllerDestiny = ScreenshotController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initSavetoPath();

    _bindingPrinter().then((bool? isBind) async => {
          if (isBind!)
            {
              _getPrinterStatus(),
              _printerMode = await _getPrinterMode(),
            }
        });
  }

  /// you can get printer status
  Future<void> _getPrinterStatus() async {
    final PrinterStatus result = await SunmiPrinter.getPrinterStatus();
    setState(() {
      _printerStatus = result;
    });
  }

  /// must binding ur printer at first init in app
  Future<bool?> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }

  Future<PrinterMode> _getPrinterMode() async {
    final PrinterMode mode = await SunmiPrinter.getPrinterMode();
    return mode;
  }

  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Captured widget screenshot"),
        ),
        body: Center(
            child: capturedImage != null
                ? Image.memory(capturedImage)
                : Container()),
      ),
    );
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

  getTextImageSingle(ScreenshotController controller) {
    return Container(
      color: Colors.white,
      child: new Center(
        child: Screenshot(
          controller: controller,
          child: Container(
            color: Colors.white, //Alignment.centerLeft,
            child: Container(
              width: 85,
              height: 85,
              child: Image(
                image:
                    NetworkImage('http://149.129.55.90/appicon/scnexpress.jpg'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  getTextPointSendRecive(ScreenshotController controller) {
    return Container(
      color: Colors.white,
      child: new Center(
        child: Screenshot(
          controller: controller,
          child: Container(
            color: Colors.white, //Alignment.centerLeft,
            child: Container(
              width: 85,
              height: 85,
              child: Image(
                image:
                    NetworkImage('http://149.129.55.90/appicon/scnexpress.jpg'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  createPrintTable() {
    List<TableRow> rows = [];
    for (var i = 0; i < 3; i++) {
      rows.add(
        TableRow(
          children: [
            Row(
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: Text(
                          'ບິນເລກທີ ${i}',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                color: Colors.amberAccent,
              ),
              child: Column(
                children: [
                  getTextImageSingle(screenshotControllerImage),
                ],
              ),
            ),
            ElevatedButton(
              child: Text(
                'Capture Above Widget',
              ),
              onPressed: () {
                screenshotControllerImage
                    .capture(delay: Duration(milliseconds: 10))
                    .then(
                  (capturedImage) async {
                    String dir =
                        (await getApplicationDocumentsDirectory()).path;
                    String filename =
                        DateTime.now().microsecondsSinceEpoch.toString();
                    writeToFileImage(capturedImage!, '$dir/$filename');
                    print('path=> $dir/$filename');
                    String picpath = '$dir/$filename';

                    await SunmiPrinter.initPrinter();
                    await SunmiPrinter.startTransactionPrint(true);

                    final ByteData bytes =
                        await rootBundle.load('images/yourlogo.png');
                    final Uint8List list = bytes.buffer.asUint8List();

                    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
                    await SunmiPrinter.startTransactionPrint(true);
                    await SunmiPrinter.printImage(list);
                    await SunmiPrinter.printText('ລາຄາ',
                        style: SunmiStyle(bold: true));

                    await SunmiPrinter.line();

                    await SunmiPrinter.resetFontSize();

                    // testprint!.printInvoice(
                    //   picpath,
                    // );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
