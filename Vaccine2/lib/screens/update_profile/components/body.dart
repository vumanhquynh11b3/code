import 'package:flutter/material.dart';


import '../../../components/socal_card.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'update_profile.dart';

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
                Text("Đổi mật khẩu", style: headingStyle),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                UpdateProfileForm(),
                SizedBox(height: getProportionateScreenHeight(20)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
