import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class printBill {
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  printInvoice(String pathImage) async {
    if ((await printer.isConnected)!) {
      printer.printNewLine();
      printer.printCustom('ສະບາຍດີ ທົດລອງພິນ', 0, 1);
      printer.printQRcode('test QR', 200, 200, 1);

      printer.printNewLine();
      printer.printCustom("HEADER", 3, 1);
      printer.printNewLine();
      //path of your image/logo
      printer.printImage(pathImage);
      printer.printNewLine();
//      bluetooth.printImageBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
      // printer.printLeftRight("LEFT", "RIGHT", 0);
      // printer.printLeftRight("LEFT", "RIGHT", 1);
      // printer.printLeftRight("LEFT", "RIGHT", 1, format: "%-15s %15s %n");
      // printer.printNewLine();
      // printer.printLeftRight("LEFT", "RIGHT", 2);
      // printer.printLeftRight("LEFT", "RIGHT", 3);
      // printer.printLeftRight("LEFT", "RIGHT", 4);
      // printer.printNewLine();
      // printer.print3Column("Col1", "Col2", "Col3", 1);
      // printer.print3Column("Col1", "Col2", "Col3", 1,
      //     format: "%-10s %10s %10s %n");
      // printer.printNewLine();
      // printer.print4Column("Col1", "Col2", "Col3", "Col4", 1);
      // printer.print4Column("Col1", "Col2", "Col3", "Col4", 1,
      //     format: "%-8s %7s %7s %7s %n");
      // printer.printNewLine();
      // String testString = " čĆžŽšŠ-H-ščđ";
      // printer.printCustom(testString, 1, 1, charset: "windows-1250");
      // printer.printLeftRight("Številka:", "18000001", 1,
      //     charset: "windows-1250");
      // printer.printCustom("Body left", 1, 0);
      // printer.printCustom("Body right", 0, 2);
      // printer.printNewLine();
      // printer.printCustom("ທົດລອງ", 2, 1);
      // printer.printNewLine();
      // printer.printQRcode("Insert Your Own Text to Generate", 200, 200, 1);
      printer.printNewLine();
      printer.printNewLine();
      printer.paperCut();
    }
  }
}
