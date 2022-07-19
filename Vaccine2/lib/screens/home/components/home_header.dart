import 'package:flutter/material.dart';
import 'package:vaccine2/screens/profile/profile_screen.dart';
import 'package:vaccine2/screens/sign_in/components/sign_form.dart';
import 'package:vaccine2/screens/update_info/update_info_screen.dart';
import '../../../size_config.dart';
import 'icon_btn_with_counter.dart';
import 'search_field.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tentaikhoan=ModalRoute.of(context)!.settings.arguments as String;
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //SearchField(),
          IconBtnWithCounter(
            svgSrc: "assets/icons/Settings.svg",
            press: () => Navigator.pushNamed(context, ProfileScreen.routeName, arguments: tentaikhoan),
          ),

        ],
      ),
    );
  }
}
