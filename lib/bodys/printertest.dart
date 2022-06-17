import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:scnexpress/function/printbill.dart';

class printTest extends StatefulWidget {
  const printTest({Key? key}) : super(key: key);

  @override
  State<printTest> createState() => _printTestState();
}

class _printTestState extends State<printTest> {
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  printBill? printCall;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDevices();
    printCall = printBill();
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
              onPressed: () {
                printnew();
              },
              child: Text('print'),
            )
          ],
        ),
      ),
    );
  }

  printnew() {
    String billInvoice = "123";
    printCall!.printInvoice(billInvoice);
  }
}
