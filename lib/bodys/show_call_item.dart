import 'package:flutter/material.dart';

class ShowCallItem extends StatefulWidget {
  const ShowCallItem({Key? key}) : super(key: key);

  @override
  State<ShowCallItem> createState() => _ShowCallItemState();
}

class _ShowCallItemState extends State<ShowCallItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('This is Show Items'),
    );
  }
}
