import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class printBill {
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  printInvoice(String pathImage) async {
    if ((await printer.isConnected)!) {
      printer.printNewLine();
      printer.printNewLine();
      printer.printImage(pathImage);
      printer.printNewLine();
      printer.printNewLine();
      printer.printNewLine();
      printer.paperCut();
    }
  }
}
