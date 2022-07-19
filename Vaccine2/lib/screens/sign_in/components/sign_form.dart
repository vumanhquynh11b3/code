import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sql_conn/sql_conn.dart';
import 'package:vaccine2/connect.dart';
import 'package:vaccine2/screens/home/home_screen.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../components/default_button.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../../../helper/keyboard.dart';
import '../../../size_config.dart';
import '../../forgot_password/forgot_password_screen.dart';


class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}
class ScreenTaiKhoan {
  final String TaiKhoan;
  //final String message;
  ScreenTaiKhoan(this.TaiKhoan);
}

class _SignFormState extends State<SignForm> {
  final EmailController = TextEditingController();
  final PasswordController =  TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool? remember = false;
  final List<String?> errors = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),

          Row(
            children: [
              // Checkbox(
              //   value: remember,
              //   activeColor: kPrimaryColor,
              //   onChanged: (value) {
              //     setState(() {
              //       remember = value;
              //     });
              //   },
              // ),
              // Text("Nhớ mật khẩu"),
              Spacer(),
              // GestureDetector(
              //   onTap: () => Navigator.pushNamed(
              //       context, ForgotPasswordScreen.routeName,
              //       arguments:  ScreenTaiKhoan(
              //         EmailController.toString(),
              //       ),
              //   ),
              //   child: Text(
              //     "Quên mật khẩu",
              //     style: TextStyle(decoration: TextDecoration.underline),
              //   ),
              // )
            ],
          ),


          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Đăng nhập",
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                KeyboardUtil.hideKeyboard(context);
               // if(SqlConn.isConnected==false){connection().connect(context);};
                final checkdn = await CheckDangNhap();

              if(checkdn==1&&await CheckTrangThai()==1){
                Navigator.pushNamed(context, HomeScreen.routeName,
                  arguments: EmailController.text,
                );
              }
              else if(checkdn==0){ showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Row(
                        children: [
                          Image.network(
                            'https://flutter-examples.com/wp-content/uploads/2019/12/android_icon.png',
                            width: 50, height: 50, fit: BoxFit.contain,),
                          Text('  Thông báo ')
                        ]
                    ),
                    content: Text("Sai khoản hoặc mật khẩu"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Trở về"),
                        onPressed: () { //Put your code here which you want to execute on Cancel button click.
                          Navigator.of(context).pop();
                          return;
                        },
                      ),
                    ],
                  );
                },
              );}
               else if(await CheckTrangThai()==0){showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Row(
                          children: [
                            Image.network(
                              'https://flutter-examples.com/wp-content/uploads/2019/12/android_icon.png',
                              width: 50, height: 50, fit: BoxFit.contain,),
                            Text('  Thông báo ')
                          ]
                      ),
                      content: Text("Tài khoản đã bị khóa"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Trở về"),
                          onPressed: () { //Put your code here which you want to execute on Cancel button click.
                            Navigator.of(context).pop();
                            return;
                          },
                        ),
                      ],
                    );
                  },
                );}

              }

            },
          ),

        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: PasswordController,
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        }
        // else if (value.length < 8) {
        //   addError(error: kShortPassError);
        //   return "";
        // }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Mật khẩu",
        hintText: "Nhập mật khẩu của bạn",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: EmailController,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        }
        // else if (emailValidatorRegExp.hasMatch(value)) {
        //   removeError(error: kInvalidEmailError);
        // }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        }
        // else if (!emailValidatorRegExp.hasMatch(value)) {
        //   addError(error: kInvalidEmailError);
        //   return "";
        // }
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
  Future<int> CheckDangNhap()  async {
    String res = await SqlConn.readData(
        "select dbo.kiemtradangnhap('"+EmailController.text+"','"+PasswordController.text+"')");
    //print(res.toString());
    var cd = jsonDecode(res.toString());
    int a =(cd[0]['']);
    print(a);
    return a;
  }
  Future<int> CheckTrangThai()  async {
    String res = await SqlConn.readData(
        "select TrangThai from NhanSu where TaiKhoan='"+EmailController.text+"'And MatKhau='"+PasswordController.text+"'");
    //print(res.toString());
    var cd = jsonDecode(res.toString());
    int a =(cd[0]['TrangThai']);
    print(a);
    return a;
  }
}
