import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';

class printTest extends StatefulWidget {
  const printTest({Key? key}) : super(key: key);

  @override
  State<printTest> createState() => _printTestState();
}

class _printTestState extends State<printTest> {
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDevices();
  }

  void getDevices() async {
    devices = await printer.getBondedDevices();
    setState(() {
      devices.forEach((deviceauto) {
        printer.connect(deviceauto);
        print('show device ==>$deviceauto');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                if ((await printer.isConnected)!) {
                  printer.printNewLine();
                  printer.printCustom('ສະບາຍດີ ທົດລອງພິນ', 0, 1);
                  printer.printQRcode('test QR', 200, 200, 1);
                }
              },
              child: Text('print'),
            )
          ],
        ),
      ),
    );
  }
}
