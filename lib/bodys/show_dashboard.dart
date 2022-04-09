import 'package:flutter/material.dart';

class ShowDashboard extends StatefulWidget {
  const ShowDashboard({Key? key}) : super(key: key);

  @override
  State<ShowDashboard> createState() => _ShowDashboardState();
}

class _ShowDashboardState extends State<ShowDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('This is Show Dashboard'),
    );
  }
}
