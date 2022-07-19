import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vaccine2/size_config.dart';

const kPrimaryColor = Color(0xFF04BD7A);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Hãy nhập email của bạn";
const String kGoToNullError = "Hãy nhập nơi đến của bạn";
const String kInvalidEmailError = "Email chưa đúng định dạng";
const String kPassNullError = "Hãy nhập mật khẩu của bạn";
const String kShortPassError = "Mật khẩu quá ngắn";
const String kCMNDNullError = "Hãy nhập cmnd của bạn";
const String kShortCMNDError = "Hãy nhập đúng CCCD(12 số)";
const String kMatchPassError = "Mật khẩu không khớp";
const String kNamelNullError = "Hãy nhập tên của bạn";
const String kPhoneNumberNullError = "Hãy nhập số điện thoại của bạn";
const String kPhoneInvalidNumberError = "SDT chưa đúng";
const String kAddressNullError = "Hãy nhập địa chỉ của bạn";
const String KCMNDNullError="Hãy nhập CMND của bạn";
const String KDoBNullError="Hãy nhập năm sinh của bạn";
const String kAGEError = "Tuổi không hợp lệ";
const String kQuocTichNullError="Hãy nhập quốc tịch của bạn";
const String kMaXPNullError="Hãy nhập mã phường";

final otpInputDecoration = InputDecoration(
  contentPadding:
  EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}
