import 'package:flutter/material.dart';
import '../../../components/no_account_text.dart';
import '../../../size_config.dart';
import 'sign_form.dart';


class Body extends StatelessWidget {
  //Future<void> a =connection().read("select TaiKhoan from [dbo].[NhanSu] where ID_NhanSu='9999999999'") ;
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
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Text(
                  "Chào mừng",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Đăng nhập bằng tài khoản và mật khẩu  \hoặc",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                SignForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     SocalCard(
                //       icon: "assets/icons/google-icon.svg",
                //       press: () {
                //         connection().connect(context);
                //       },
                //     ),
                //     SocalCard(
                //       icon: "assets/icons/facebook-2.svg",
                //       press: () {
                //         CheckTK_ID();
                //       },
                //     ),
                //     SocalCard(
                //       icon: "assets/icons/twitter.svg",
                //       press: () {
                //         SqlConn.disconnect();
                //       },
                //     ),
                //   ],
                // ),
                SizedBox(height: getProportionateScreenHeight(20)),
                NoAccountText(),

              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<bool> CheckTK_ID() async {
  //   String res = await SqlConn.readData(
  //       "select dbo.kiemtraID('1231231231')");
  //   //print(res.toString());
  //   var cd = jsonDecode(res.toString());
  //   print(cd);
  //   int a = (cd[0]['']);
  //   if (a == 0) {
  //     print('Khong ton tai');
  //   return true;
  //   }
  //     else {print(' ton tai');
  //     return false;
  //     }
  //   }
  }

