import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:vaccine2/screens/home/components/section_title.dart';
import 'package:vaccine2/screens/sign_in/components/sign_form.dart';

import '../../../size_config.dart';
import 'categories.dart';
import 'banner_1.dart';
import 'home_header.dart';
import 'history.dart';
import 'notification.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [

            SizedBox(height: getProportionateScreenHeight(20)),
            HomeHeader(),
            SizedBox(height: getProportionateScreenWidth(10)),
            DiscountBanner(),
            Categories(),
            Function_Screen(),
            SizedBox(height: getProportionateScreenWidth(30)),
            Padding(
              padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
              child: SectionTitle(
                title: "Đợt tiêm gần nhất",
                press: () {},
              ),
            ),

            ExampleApp(),
            SizedBox(height: getProportionateScreenWidth(30)),
          ],
        ),
      ),
    );
  }
}
