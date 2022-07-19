import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'sign_up_form.dart';

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
                Text("Đăng ký tài khoản", style: headingStyle),
                Text(
                  "Hoàn tất thông tin để đăng ký",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                SignUpForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
