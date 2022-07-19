import 'package:flutter/material.dart';
import 'package:vaccine2/screens/sign_in/sign_in_screen.dart';
import 'package:vaccine2/screens/update_info/update_info_screen.dart';
import 'package:vaccine2/screens/update_profile/update_profile_screen.dart';

import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tentaikhoan=ModalRoute.of(context)!.settings.arguments as String;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "Tài khoản của tôi",
            icon: "assets/icons/User_icon.svg",
            press: () => {Navigator.pushNamed(context, UpdateProfile.routeName,arguments: tentaikhoan)},
          ),
          ProfileMenu(
            text: "Thông tin cá nhân",
            icon: "assets/icons/Settings.svg",
            press: () {Navigator.pushNamed(context, UpdateInfo.routeName, arguments: tentaikhoan);},
          ),
          ProfileMenu(
            text: "Trung tâm hỗ trợ",
            icon: "assets/icons/Question mark.svg",
            press: ()
              => showDialog(
                  context: context,
                  builder: (_) {
                    return Dialog(
                      child: Padding(
                        child: Text( '0775582514\nvumanhquynh11b3@gmail.com'),
                        padding: const EdgeInsets.all(8.0),

                      ),

                    );
                  }),

          ),
          ProfileMenu(
            text: "Đăng xuất",
            icon: "assets/icons/Log out.svg",
            press: () => Navigator.pushNamed(context, SignInScreen.routeName, arguments: tentaikhoan),
          ),
        ],
      ),
    );
  }
}
