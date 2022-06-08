import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class mapCallTruck extends StatefulWidget {
  const mapCallTruck({Key? key}) : super(key: key);

  @override
  State<mapCallTruck> createState() => _mapCallTruckState();
}

class _mapCallTruckState extends State<mapCallTruck> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: TextButton(
          onPressed: () {},
          child: Text('Google Map'),
        ),
      ),
    );
  }
}


// https://www.google.com/maps/search/?api=1&query=18.0092437,102.550711