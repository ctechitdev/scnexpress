import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class configPrinterPage extends StatefulWidget {
  const configPrinterPage({Key? key}) : super(key: key);

  @override
  State<configPrinterPage> createState() => _configPrinterPageState();
}

class _configPrinterPageState extends State<configPrinterPage> {
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  String? connected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDevices();
  }

  void getDevices() async {
    devices = await printer.getBondedDevices();
    setState(() {});
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? printername = preferences.getString('printer_name');
    String? printeraddress = preferences.getString('printer_address');

    print('printer Name => $printername');
    print('printer Name => $printeraddress');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<BluetoothDevice>(
                value: selectedDevice,
                hint: const Text('select printer'),
                onChanged: (device) {
                  setState(() async {
                    print('printer name: ${device?.name}');
                    print('printer address: ${device?.address}');
                    selectedDevice = device;

                    String? device_name = device!.name;
                    String? device_address = device.address;

                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    preferences.setString('printer_name', device_name!);
                    preferences.setString('printer_address', device_address!);
                  });
                },
                items: devices
                    .map((e) => DropdownMenuItem(
                          child: Text(e.name!),
                          value: e,
                        ))
                    .toList()),
            ElevatedButton(
              onPressed: () async {
                printer.connect(selectedDevice!);
                connected = 'true';
              },
              child: Text('Connect'),
            ),
            ElevatedButton(
              onPressed: () async {
                printer.disconnect();
                connected = 'false';
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                preferences.remove('printer');
              },
              child: Text('disconnect'),
            ),
            ElevatedButton(
              onPressed: () async {
                if ((await printer.isConnected)!) {
                  printer.printNewLine();
                  printer.printCustom('ສະບາຍດີ ທົດລອງພິນ', 0, 1);
                  printer.printQRcode('test QR', 200, 200, 1);
                }
              },
              child: Text('print'),
            ),
          ],
        ),
      ),
    );
  }
}
