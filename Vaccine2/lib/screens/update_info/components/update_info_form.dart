import 'dart:async';
import 'dart:convert';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:dvhcvn/dvhcvn.dart' as dvhcvn;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sql_conn/sql_conn.dart';
import 'package:vaccine2/connect.dart';
import 'package:vaccine2/models/dvhcvn.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../components/default_button.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../../../size_config.dart';




class UpdateInfoForm extends StatefulWidget {
  @override
  _UpdateInfoFormState createState() => _UpdateInfoFormState();
}

class _UpdateInfoFormState extends State<UpdateInfoForm> {
  static ValueNotifier<String>enteredValue=ValueNotifier('');
  String? gender='0';
  final _formKey = GlobalKey<FormState>();
  String? hoten;
  final RHoTenController = TextEditingController();
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
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      final tentaikhoan = ModalRoute.of(context)!.settings.arguments as String;
      final check_id_congdan = await ReturnID(tentaikhoan);
      print(check_id_congdan);
      final hoten=await ReturnTen(check_id_congdan);
      final quoctich=await ReturnQT(check_id_congdan);
      final diachi=await ReturnDC(check_id_congdan);
      final namsinh= await ReturnNS(check_id_congdan);
     // final sdt=await ReturnSDT(check_id_congdan).toString();
      RHoTenController.text=hoten;
      RQuocTichController.text=quoctich;
      RDiaChiController.text=diachi;
      RDoBController.text=namsinh;

    });

  }
  @override
  Widget build(BuildContext context) {
    final tentaikhoan = ModalRoute
        .of(context)!
        .settings
        .arguments as String;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildNameFormField(),
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
                              Expanded(child: ButtonDone()),
                            ],
                          ),
                          padding: const EdgeInsets.all(8.0),
                        )
                      ],
                    ),
                    create: (_) => DemoData(),
                  )
              ),
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
            text: "Cập nhật",
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                final rid=await ReturnID(tentaikhoan);
                print(rid.toString());
                  updateCD(rid.toString());
                  updateHoTen(rid.toString());
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
                        content: Text("Cập nhật thành công"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("OK"),
                            onPressed: () { //Put your code here which you want to execute on Cancel button click.
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
              }

            },
          ),
        ],
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
      enabled: false,
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
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPhoneNumberNullError);
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

  Future<String> ReturnID(String tentaikhoan) async {
    String res = await SqlConn.readData(
        "select ID_NhanSu From NhanSu where TaiKhoan ='" + tentaikhoan + "'");
    //print(res.toString());
    var cd = jsonDecode(res.toString());
    String id = (cd[0]['ID_NhanSu'].toString());
    //print(a);
    return id;
  }

  // Future<int> CheckTK() async {
  //   String res = await SqlConn.readData(
  //       "select dbo.kiemtrataikhoan('" + REmailController.text + "')");
  //   //print(res.toString());
  //   var cd = jsonDecode(res.toString());
  //   int a = (cd[0]['']);
  //   print(a);
  //   return a;
  // }

  Future<void> updateCD(String idcongdan) async {
    try {
      connection().write(
          "UPDATE CongDan SET NamSinh='"+RDoBController.text+"',ChiTietDiaChi= N'"+RDiaChiController.text+"',SDT='"+RSDTController.text+"',MaXaPhuong='"+RXaPhuongController.text+"',QuocTich=N'"+RQuocTichController.text+"' where ID_CongDan='"+idcongdan+"'");
    } on Exception catch (e) {
      print(e);
    }
  }
  Future<void> updateHoTen(String idcongdan) async {
    try {
      connection().write(
          "UPDATE NhanSu SET HoTen=N'"+RHoTenController.text+"' where ID_NhanSu='"+idcongdan+"'");
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<String> ReturnTen(String idnhansu) async {
    String res = await SqlConn.readData(
        "select HoTen From NhanSu where ID_NhanSu ='" + idnhansu + "'");
    //print(res.toString());
    var cd = jsonDecode(res.toString());
    String id = (cd[0]['HoTen'].toString());
    //print(a);
    return id;
  }
  Future<String> ReturnSDT(String idnhansu) async {
    String res = await SqlConn.readData(
        "select SDT From CongDan where ID_CongDan ='" + idnhansu + "'");
    print(res.toString());
    var cd = json.decode(res);
    String id = (cd[0]['SDT'].toString());
    //String id="00001";
    print(id);
    return id;
  }
  Future<String> ReturnQT(String idnhansu) async {
    String res = await SqlConn.readData(
        "select QuocTich From CongDan where ID_CongDan ='" + idnhansu + "'");
    //print(res.toString());
    var cd = jsonDecode(res.toString());
    String id = (cd[0]['QuocTich'].toString());
    //print(a);
    return id;
  }
  Future<String> ReturnDC(String idnhansu) async {
    String res = await SqlConn.readData(
        "select ChiTietDiaChi From CongDan where ID_CongDan ='" + idnhansu + "'");
    //print(res.toString());
    var cd = jsonDecode(res.toString());
    String id = (cd[0]['ChiTietDiaChi'].toString());
    //print(a);
    return id;
  }
  Future<String> ReturnNS(String idnhansu) async {
    String res = await SqlConn.readData(
        "select NamSinh From CongDan where ID_CongDan ='" + idnhansu + "'");
    //print(res.toString());
    var cd = jsonDecode(res.toString());
    String id = (cd[0]['NamSinh'].toString());
    //print(a);
    return id;
  }

}
class ButtonReset extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FlatButton(
    child: Text('Chọn lại'),
    onPressed: () => DemoData.of(context, listen: false).level1 = null,
  );
}

class ButtonDone extends StatelessWidget{
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
                _UpdateInfoFormState.enteredValue.value=maxp!;
                _UpdateInfoFormState.RXaPhuongController.text=_UpdateInfoFormState.enteredValue.value.toString();
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
    if (selected != null) data.level3 = selected;
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
                  onTap: () => Navigator.of(itemContext).pop(item),
                );
              },
              itemCount: list.length,
            ),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
