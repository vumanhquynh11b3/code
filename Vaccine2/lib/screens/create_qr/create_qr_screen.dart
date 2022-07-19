import 'package:flutter/material.dart';
import 'components/body.dart';

class CreateQRScreen extends StatelessWidget {
  static String routeName = "/create_qr";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        title: Text("Đăng nhập thành công"),
      ),
      body: QRGeneratorSharePage(),
    );
  }
}
