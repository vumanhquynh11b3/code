import 'package:flutter/material.dart';
import 'package:vaccine2/screens/vaccine_status/components/body.dart';




class VaccineStatus extends StatelessWidget {
  static String routeName = "/vaccine_status";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trạng thái"),
        automaticallyImplyLeading: false,
      ),
      body: ExampleApp(),
    );
  }
}
