import 'package:flutter/material.dart';
import 'package:vaccine2/screens/update_info/components/update_info_form.dart';
import '../../../constants.dart';
import '../../../size_config.dart';


class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04), // 4%
                Text("Thông tin cá nhân", style: headingStyle),
                Text(
                  "Chỉnh sửa thông tin cá nhân",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                UpdateInfoForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
