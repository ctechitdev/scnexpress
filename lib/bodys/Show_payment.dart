import 'package:flutter/material.dart';

class ShowPayment extends StatefulWidget {
  const ShowPayment({Key? key}) : super(key: key);

  @override
  State<ShowPayment> createState() => _ShowPaymentState();
}

class _ShowPaymentState extends State<ShowPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('This is Show Payment'),
    );
  }
}
