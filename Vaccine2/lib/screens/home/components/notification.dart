import 'package:flutter/material.dart';
import 'package:vaccine2/screens/vaccine_history/vaccine_history.dart';
import 'package:vaccine2/screens/vaccine_status/vaccine_status.dart';

import '../../../size_config.dart';
import '../../Create_QR/create_qr_screen.dart';
import 'section_title.dart';

class Function_Screen extends StatelessWidget {
  const Function_Screen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tentaikhoan=ModalRoute.of(context)!.settings.arguments as String;
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
            title: "Chức năng",
            press: () {},
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Notification(
                image: "assets/images/coronavirus.png",
                category: "Lịch sử tiêm",
                numOfL: 0,
                press: () {Navigator.pushNamed(context, VaccineHistory.routeName,arguments: tentaikhoan);},
              ),
              Notification(
                image: "assets/images/qrcode.png",
                category: "Mã-QR",
                numOfL: 0,
                press: () {Navigator.pushNamed(context, CreateQRScreen.routeName,arguments: tentaikhoan);},
              ),
              Notification(
                image: "assets/images/coronavirus.png",
                category: "Theo dõi đợt tiêm",
                numOfL: 0,
                press: () {Navigator.pushNamed(context, VaccineStatus.routeName,arguments: tentaikhoan);},
              ),
              SizedBox(width: getProportionateScreenWidth(20)),
            ],
          ),
        ),
      ],
    );
  }
}

class Notification extends StatelessWidget {
  const Notification({
    Key? key,
    required this.category,
    required this.image,
    required this.numOfL,
    required this.press,
  }) : super(key: key);

  final String category, image;
  final int numOfL;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: getProportionateScreenWidth(242),
          height: getProportionateScreenWidth(100),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.asset(
                  image,
                  fit: BoxFit.cover,

                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF343434).withOpacity(0.4),
                        Color(0xFF343434).withOpacity(0.15),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(15.0),
                    vertical: getProportionateScreenWidth(10),
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "$category\n",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                     //   TextSpan(text: "$numOfL Mục")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
