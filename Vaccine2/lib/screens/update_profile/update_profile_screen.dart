import 'package:flutter/material.dart';

import 'components/body.dart';

class UpdateProfile extends StatelessWidget {
  static String routeName = "/update_profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đổi mật khẩu"),
      ),
      body: Body(),
    );
  }
}
