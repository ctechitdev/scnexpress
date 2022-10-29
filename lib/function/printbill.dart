import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

class printBill {
  late PrinterStatus _printerStatus;
  late PrinterMode _printerMode;

  printInvoice(String pathImage) async {
    _bindingPrinter().then((bool? isBind) async => {
          if (isBind!)
            {
              _getPrinterStatus(),
              _printerMode = await _getPrinterMode(),
            }
        });

    await SunmiPrinter.initPrinter();
    await SunmiPrinter.startTransactionPrint(true);

    final ByteData bytes = await rootBundle.load('images/yourlogo.png');
    final Uint8List list = bytes.buffer.asUint8List();

    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.startTransactionPrint(true);
    await SunmiPrinter.printImage(list);
    await SunmiPrinter.printText('ລາຄາ', style: SunmiStyle(bold: true));

    await SunmiPrinter.line();

    await SunmiPrinter.resetFontSize();
  }

  /// you can get printer status
  Future<void> _getPrinterStatus() async {
    final PrinterStatus result = await SunmiPrinter.getPrinterStatus();

    _printerStatus = result;
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
}
