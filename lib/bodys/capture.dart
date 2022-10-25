import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scnexpress/function/printbill.dart';
import 'package:screenshot/screenshot.dart';

class capTurepage extends StatefulWidget {
  const capTurepage({Key? key}) : super(key: key);

  @override
  State<capTurepage> createState() => _capTurepageState();
}

class _capTurepageState extends State<capTurepage> {
  ScreenshotController screenshotController = ScreenshotController();
  String? pathImage;
  printBill? testprint;

  ScreenshotController screenshotControllerImage = ScreenshotController();
  ScreenshotController screenshotControllerDestiny = ScreenshotController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initSavetoPath();
    testprint = printBill();
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

                    testprint!.printInvoice(
                      picpath,
                    );
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
