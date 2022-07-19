
import 'dart:async';
import 'dart:convert';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sql_conn/sql_conn.dart';
import 'package:vaccine2/connect.dart';
import 'package:vaccine2/screens/home/home_screen.dart';
import 'package:vaccine2/screens/sign_in/sign_in_screen.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../components/default_button.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../../../size_config.dart';



class UpdateProfileForm extends StatefulWidget {
  @override
  _UpdateProfileFormState createState() => _UpdateProfileFormState();
}

class _UpdateProfileFormState extends State<UpdateProfileForm> {
  String? gender;
  final _formKey = GlobalKey<FormState>();
  String? email;
  final REmailController = TextEditingController();
  String? password;
  final RPasswordController = TextEditingController();
  String? confirm_password;
  final RConfirm_passwordController = TextEditingController();
  String? hoten;
  final RHoTenController = TextEditingController();
  String? CMND;
  final RCMNDController = TextEditingController();
  String? SDT;
  final RSDTController = TextEditingController();
  String? diachi;
  final RDiaChiController = TextEditingController();
  String? DoB;
  final RDoBController = TextEditingController();
  String? xaphuong;
  final RXapPhuongController = TextEditingController();
  String? quoctich;
  final RQuocTichController = TextEditingController();
  int? namsinh;
  final RNamSinhController = TextEditingController();
  bool remember = false;
  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    final tentaikhoan=ModalRoute.of(context)!.settings.arguments as String;
    REmailController.text=tentaikhoan;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildConformPassFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(30)),
          DefaultButton(
            text: "Tiếp tục",
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                Update_MK();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Row(
                          children:[
                            Image.network('https://flutter-examples.com/wp-content/uploads/2019/12/android_icon.png',
                              width: 50, height: 50, fit: BoxFit.contain,),
                            Text('  Thông báo ')
                          ]
                      ),
                      content: Text("Cập nhật thành công"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Oke"),
                          onPressed: () {//Put your code here which you want to execute on Cancel button click.
                            Navigator.pushNamed(context, HomeScreen.routeName,arguments: tentaikhoan);
                          },
                        ),
                      ],
                    );
                  },
                );
               // Navigator.pushNamed(context, HomeScreen.routeName,arguments: tentaikhoan);
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => confirm_password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && password == confirm_password) {
          removeError(error: kMatchPassError);
        }
        confirm_password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((password != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Xác nhận mật khẩu",
        hintText: "Nhập lại mật khẩu",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: RPasswordController,
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Mật khẩu",
        hintText: "Nhập mật khẩu",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      enabled: false,
      controller: REmailController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Nhập email của bạn",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
  Future<int> CheckID() async {
    String res = await SqlConn.readData(
        "select dbo.kiemtraID('" + RCMNDController.text + "')");
    //print(res.toString());
    var cd = jsonDecode(res.toString());
    int a = (cd[0]['']);
    print(a);
    return a;
  }
  Future<int> CheckTK() async {
    String res = await SqlConn.readData(
        "select dbo.kiemtrataikhoan('" + REmailController.text + "')");
    //print(res.toString());
    var cd = jsonDecode(res.toString());
    int a = (cd[0]['']);
    print(a);
    return a;
  }
  Future<void> insertCD() async {

    try{
      connection().write(
          "EXEC dbo.Insert_CongDan '" + RCMNDController.text + "',N'" +
              RHoTenController.text + "' ,'" + gender.toString() + "','" +
              RDoBController.text + "' ,'" + RSDTController.text + "',N'" +
              RDiaChiController.text + "','" + RXapPhuongController.text +
              "','" +
              RCMNDController.text + "' ,N'" + RQuocTichController.text +
              "','" +
              REmailController.text + "','" + RPasswordController.text + "'");

    }on Exception catch(e){print(e);}}
  Future<void> Update_MK() async{
    try{
    connection().write("Update NhanSu Set MatKhau='"+RPasswordController.text+"' Where TaiKhoan ='"+REmailController.text+"' ");
    print("oke");
  }on Exception catch(e){print(e);};
  }
  void showToastMessage(String message){
    Fluttertoast.showToast(
        msg: message, //message to show toast
        toastLength: Toast.LENGTH_LONG, //duration for message to show
        gravity: ToastGravity.CENTER, //where you want to show, top, bottom
        timeInSecForIosWeb: 1, //for iOS only
        //backgroundColor: Colors.red, //background Color for message
        textColor: Colors.white, //message text color
        fontSize: 16.0 //message font size
    );
  }
}