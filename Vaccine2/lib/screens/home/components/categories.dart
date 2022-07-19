import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../size_config.dart';


class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tentaikhoan=ModalRoute.of(context)!.settings.arguments as String;

    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(20)),
      // child: Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //
      //     children: [
      //       CategoryCard(icon: "assets/icons/Flash Icon.svg", text: "", press: (){/*Navigator.pushNamed(context, ProfileScreen.routeName,arguments: tentaikhoan);*/}),
      //       CategoryCard(icon: "assets/icons/Bill Icon.svg", text: "", press: (){}),
      //       CategoryCard(icon: "assets/icons/Game Icon.svg", text: "", press: (){}),
      //       CategoryCard(icon: "assets/icons/Gift Icon.svg", text: "", press: (){})
      //     ],
      // ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.press,
  }) : super(key: key);

  final String? icon, text;
  final GestureTapCallback press;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: getProportionateScreenWidth(55),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(15)),
              height: getProportionateScreenWidth(55),
              width: getProportionateScreenWidth(55),
              decoration: BoxDecoration(
                color: Color(0xFFFFECDF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(icon!),
            ),
            SizedBox(height: 5),
            Text(text!, textAlign: TextAlign.center)
          ],
        ),
      ),
    );
  }
}
