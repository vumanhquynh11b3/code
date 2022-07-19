import 'package:flutter/material.dart';
import 'package:vaccine2/screens/health_declaration/health_screen.dart';


import '../../../size_config.dart';

class DiscountBanner extends StatelessWidget {
  const DiscountBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tentaikhoan=ModalRoute.of(context)!.settings.arguments as String;

    return InkWell(
      child: Container(
        // height: 90,
        width: double.infinity,
        margin: EdgeInsets.all(getProportionateScreenWidth(20)),
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
          vertical: getProportionateScreenWidth(15),
        ),
        decoration: BoxDecoration(
          color: Color(0xFF4A3298),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text.rich(
          TextSpan(
            style: TextStyle(color: Colors.white),
            children: [
              TextSpan(text: tentaikhoan+"\n"),
              TextSpan(
                text: "Đăng Ký Tiêm Vaccine",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(24),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: (){
        Navigator.pushNamed(context, HealthScreen.routeName, arguments: tentaikhoan);
      },
    );
  }
}
