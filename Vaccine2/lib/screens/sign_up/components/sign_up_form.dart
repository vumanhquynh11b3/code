import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:dvhcvn/dvhcvn.dart' as dvhcvn;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sql_conn/sql_conn.dart';
import 'package:vaccine2/connect.dart';
import 'package:vaccine2/models/dvhcvn.dart';
import 'package:vaccine2/screens/sign_in/sign_in_screen.dart';
import 'package:vaccine2/screens/sign_up/components/sign_up_form.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../components/default_button.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../../../size_config.dart';




class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  static ValueNotifier<String>enteredValue=ValueNotifier('');
  String? gender='0';
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
  static TextEditingController RXaPhuongController = TextEditingController();
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
          buildNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildCMNDFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneNumberFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildQuocTichFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAddressFormField(),
          SizedBox(height: getProportionateScreenHeight(10)),
          Column(
            children: [
              SizedBox(
                  height: 200,
                  child: ChangeNotifierProvider(
                    child: ListView(
                      children: [
                        Level1(),
                        Level2(),
                        Level3(),
                        Padding(
                          child: Row(
                            children: [
                              Expanded(child: ButtonReset()),
                              Expanded(child: ButtonDone()
                              ),

                            ],
                          ),
                          padding: const EdgeInsets.all(8.0),
                        ),

                      ],
                    ),
                    create: (_) => DemoData(),

                  )
              ),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     primary: Colors.red, // background
              //     onPrimary: Colors.white, // foreground
              //   ),
              //   onPressed: () {RXaPhuongController.text=enteredValue.value.toString(); },
              //   child: Text('Oke'),
              // )
            ],
          ),

          SizedBox(height: getProportionateScreenHeight(20)),
          buildXaPhuongField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildDoBFormField(),
          SizedBox(height: getProportionateScreenHeight(40)),
          ListTile(
            title: Text("Nam"),
            leading: Radio(
                value: '0',
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value.toString();
                  });
                }),
          ),

          ListTile(
            title: Text("Nữ"),
            leading: Radio(
                value: '1',
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value.toString();
                  });
                }),
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(30)),
          DefaultButton(
            text: "Đăng ký",
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                final checkid = await CheckID();
                final checktk = await CheckTK();
                print(gender.toString());
                if (checkid == 0 && checktk == 0) {
                  print('oke');
                  insertCD();
                  showDialog(
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
                        content: Text("Đăng ký thành công"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("OK"),
                            onPressed: () { //Put your code here which you want to execute on Cancel button click.
                              Navigator.pushNamed(context, SignInScreen.routeName,);
                            },
                          ),
                        ],
                      );
                    },
                  );

                }
                else
                 {showDialog(
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
                       content: Text("Tài khoản đã tồn tại hoặc ID đã được đăng ký"),
                       actions: <Widget>[
                         FlatButton(
                           child: Text("Trở về"),
                           onPressed: () { //Put your code here which you want to execute on Cancel button click.
                             Navigator.of(context).pop();
                           },
                         ),
                       ],
                     );
                   },
                 );}

                //Navigator.pushNamed(context, HomeScreen.routeName);
                //RCMNDController.clear();

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

  TextFormField buildCMNDFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: RCMNDController,
      onSaved: (newValue) => CMND = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: KCMNDNullError);
        }
        if (value.length == 12) {
          removeError(error: kShortCMNDError);
        }
        //CMND = value;
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: KCMNDNullError);
          return "";
        }
        else if (value.length < 12 || value.length > 12) {
          addError(error: kShortCMNDError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "CCCD",
        hintText: "Nhập CCCD của bạn",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      controller: RHoTenController,
      onSaved: (newValue) => hoten = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Tên",
        hintText: "Nhập tên của bạn",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildXaPhuongField() {
    return TextFormField(
      controller: RXaPhuongController,
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => xaphuong = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kMaXPNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kMaXPNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        enabled: false,
        labelText: "Mã Xã Phường",
        hintText: "Nhập mã xã phường",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
        CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildDoBFormField() {
    return TextFormField(
      controller: RDoBController,
      keyboardType: TextInputType.datetime,
      onSaved: (newValue) => DoB = newValue,
      onChanged: (value) {

        if (value.isNotEmpty) {
          removeError(error: KDoBNullError);
        } if (DateTime.now().year-int.parse(value.toString())<100
            ||DateTime.now().year-int.parse(value.toString())>5)
          removeError(error: kAGEError);
          DoB = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: KDoBNullError);
          return "";
        } else if (DateTime.now().year-int.parse(value.toString())> 100||DateTime.now().year-int.parse(value.toString())<5 ) {
          addError(error: kAGEError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Năm sinh",
        hintText: "Nhập năm sinh của bạn",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
        CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildQuocTichFormField() {
    return TextFormField(
      controller: RQuocTichController,
      onSaved: (newValue) => quoctich = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kQuocTichNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kQuocTichNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Quốc tịch",
        hintText: "Nhập quốc tịch của bạn",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildAddressFormField() {
    return TextFormField(
      controller: RDiaChiController,
      keyboardType: TextInputType.streetAddress,
      onSaved: (newValue) => diachi = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAddressNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kAddressNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Địa chỉ",
        hintText: "Nhập địa chỉ của bạn",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
        CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      controller: RSDTController,
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => SDT = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        else if (value.length == 10) {
          removeError(error: kPhoneInvalidNumberError);
        }
        SDT = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        }else if (value.length < 10||value.length>10) {
          addError(error: kPhoneInvalidNumberError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Số điện thoại",
        hintText: "Nhập số điện thoại của bạn",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
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
    try {

      connection().write(
          "EXEC dbo.Insert_CongDan '" + RCMNDController.text + "',N'" +
              RHoTenController.text + "' ,'" + gender.toString() + "','" +
              RDoBController.text + "' ,'" + RSDTController.text + "',N'" +
              RDiaChiController.text + "','" + RXaPhuongController.text +
              "','" +
              RCMNDController.text + "' ,N'" + RQuocTichController.text +
              "','" +
              REmailController.text + "','" + RPasswordController.text + "'");
    } on Exception catch (e) {
      print(e);
    }
  }
}
class ButtonReset extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FlatButton(
    child: Text('Chọn lại'),
    onPressed: () => DemoData.of(context, listen: false).level1 = null,
  );
}

class ButtonDone extends StatelessWidget {


  @override
  Widget build(BuildContext context) => RaisedButton(
    child: Text('Chọn'),
    onPressed: ()async
    => showDialog(
        context: context,
        builder: (_) {

          final data = DemoData.of(context, listen: false);
          if(data.level3!=null){print(data.level3.toString());

          Future.delayed(Duration.zero, () async {
          dvhcvn.Level3? entity = data.level3;
          entity ??= data.level2 as dvhcvn.Level3?;
          entity ??= data.level1 as dvhcvn.Level3?;
            String? maxp=data.level3!.id?.toString();
            _SignUpFormState.enteredValue.value=maxp!;
            _SignUpFormState.RXaPhuongController.text=_SignUpFormState.enteredValue.value.toString();
          });}else{return AlertDialog(
            title: Row(
                children: [
                  Image.network(
                    'https://flutter-examples.com/wp-content/uploads/2019/12/android_icon.png',
                    width: 50, height: 50, fit: BoxFit.contain,),
                  Text('  Thông báo ')
                ]
            ),
            content: Text("Bạn chưa chọn địa chỉ"),
            actions: <Widget>[
              FlatButton(
                child: Text("Trở về"),
                onPressed: () { //Put your code here which you want to execute on Cancel button click.
                  Navigator.of(context).pop();
                },
              ),
            ],
          );}

          return Dialog(
            child: Padding(
              child: Text(
                   'Oke'),
              padding: const EdgeInsets.all(8.0),

            ),
          );
        }
        ),
  );
}

class Level1 extends StatelessWidget {
  @override
  Widget build(BuildContext _) => Consumer<DemoData>(
    builder: (context, data, _) => ListTile(
      title: Text('Tỉnh'),
      subtitle: Text(data.level1?.name ?? 'Chọn tỉnh thành.'),
      onTap: () => _select1(context, data),
    ),
  );

  void _select1(BuildContext context, DemoData data) async {
    final selected = await _select<dvhcvn.Level1>(context, dvhcvn.level1s);
    if (selected != null) data.level1 = selected;
  }
}

class Level2 extends StatefulWidget {
  @override
  _Level2State createState() => _Level2State();
}

class _Level2State extends State<Level2> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final data = DemoData.of(context);
    if (data.latestChange == 1) {
      // user has just selected a level 1 entity,
      // automatically trigger bottom sheet for quick level 2 selection
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _select2(context, data));
    }
  }

  @override
  Widget build(BuildContext _) => Consumer<DemoData>(
    builder: (context, data, _) => ListTile(
      title: Text('Quận huyện'),
      subtitle: Text(data.level2?.name ??
          (data.level1 != null
              ? 'Chọn quận huyện.'
              : 'Hãy chọn tỉnh thành trước.')),
      onTap: data.level1 != null ? () => _select2(context, data) : null,
    ),
  );

  void _select2(BuildContext context, DemoData data) async {
    final level1 = data.level1;
    if (level1 == null) return;

    final selected = await _select<dvhcvn.Level2>(
      context,
      level1.children,
      header: level1.name,
    );
    if (selected != null) data.level2 = selected;
  }
}

class Level3 extends StatefulWidget {
  @override
  _Level3State createState() => _Level3State();
}

class _Level3State extends State<Level3> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final data = DemoData.of(context);
    if (data.latestChange == 2) {
      // user has just selected a level 2 entity,
      // automatically trigger bottom sheet for quick level 3 selection
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _select3(context, data));
    }
  }

  @override
  Widget build(BuildContext _) => Consumer<DemoData>(
    builder: (context, data, _) => ListTile(
      title: Text('Xã Phường'),
      subtitle: Text(data.level3?.name ??
          (data.level2 != null
              ? 'Chọn Xã Phường.'
              : 'Hãy chọn Quận Huyện trước.')),
      onTap: data.level2 != null ? () => _select3(context, data) : null,

    ),
  );

  void _select3(BuildContext context, DemoData data) async {
    final level2 = data.level2;
    if (level2 == null) return;

    final selected = await _select<dvhcvn.Level3>(
      context,
      level2.children,
      header: level2.name,
    );

    if (selected != null) {data.level3 = selected;

  }

  }
}
Future<T?> _select<T extends dvhcvn.Entity>(
    BuildContext context,
    List<T> list, {
      String? header,
    }) =>
    showModalBottomSheet<T>(
      context: context,
      builder: (_) => Column(
        children: [
          // header (if provided)
          if (header != null)
            Padding(
              child: Text(
                header,
                style: Theme.of(context).textTheme.headline6,
              ),
              padding: const EdgeInsets.all(8.0),
            ),
          if (header != null) Divider(),

          // entities
          Expanded(
            child: ListView.builder(
              itemBuilder: (itemContext, i) {
                final item = list[i];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('#${item.id}, ${item.typeAsString}'),
                  onTap: () => {Navigator.of(itemContext).pop(item),
                  print(item.id),
                 },
                );
              },
              itemCount: list.length,
            ),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
