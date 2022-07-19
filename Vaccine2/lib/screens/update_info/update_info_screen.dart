import 'package:flutter/material.dart';
import 'package:vaccine2/screens/update_info/components/update_info.dart';


class UpdateInfo extends StatelessWidget {
  static String routeName = "/update_info";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cập nhập thông tin cá nhân"),
      ),
      body:Body(),
    );
  }
}
