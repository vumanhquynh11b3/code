import 'package:flutter/material.dart';
import 'package:vaccine2/screens/profile/profile_screen.dart';

import '../../../size_config.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key? key,
    required this.title,
    required this.press,
  }) : super(key: key);

  final String title;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    final tentaikhoan=ModalRoute.of(context)!.settings.arguments as String;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
            color: Colors.black,
          ),
        ),
        // GestureDetector(
        //   onTap: (){Navigator.pushNamed(context, ProfileScreen.routeName,arguments: tentaikhoan);},
        //   child: Text(
        //     "Xem thêm",
        //     style: TextStyle(color: Color(0xFFBBBBBB)),
        //   ),
        // ),
      ],
    );
  }
}
