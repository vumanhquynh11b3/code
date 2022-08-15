import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sql_conn/sql_conn.dart';
import 'package:vaccine2/components/custom_surfix_icon.dart';
import 'package:vaccine2/components/default_button.dart';
import 'package:vaccine2/components/form_error.dart';
import 'package:vaccine2/connect.dart';
import 'package:vaccine2/constants.dart';
import 'package:vaccine2/screens/home/home_screen.dart';
import 'package:vaccine2/size_config.dart';

import '../../../models/vaccination.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  static String vdt="2019-01-01";
  bool? agree = false;
  String _selectedDauHieu = '1';
  String _selectedCapTinh = '1';
  String _selectedMangThai = '1';
  String _selectedPhanVe = '1';
  String _selectedMienDich = '1';
  String _selectedUngThu = '1';
  String _selectedDiUng = '1';
  String _selectedRoiLoanMau = '1';
  String _selectedTriGiac = '1';

  List<Vaccination> ListQr = [];
  String? SelectedValue = null;
  String? goto;
  final GoToController = TextEditingController();
  String? STT;
  final RDateTimeController = TextEditingController();
  String? DT;
  final RSTTController = TextEditingController();
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
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
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final tentaikhoan = ModalRoute.of(context)!.settings.arguments as String;
      final id = await ReturnID(tentaikhoan);
      final check_stt = await CheckSTT(id);
      RSTTController.text = check_stt.toString();
      GoToController.text = "Không";
      String formattedDate = "2022-01-01";
      RDateTimeController.text = formattedDate.toString();
    });
    DateTime today = DateTime.now();
    SqlConn.readData(
            "select ID_DotTiem,NgayTiem,LoaiVaccine,DiaDiem,SLNguoiDuKien,NgayThongBao from DotTiemChung Where NgayTiem >='" +
                today.toString() +
                "'")
        .then((value) {
      setState(() {
        List<dynamic> list = json.decode(value);
        // ListQr = list;
        ListQr = list.map((e) =>
            // new Employee(e["ID_NhanSu"], e["HoTen"], e["VaiTro"], 12, e["TaiKhoan"], e["MatKhau"])
            Vaccination.fromJson(e)).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final tentaikhoan = ModalRoute.of(context)!.settings.arguments as String;
    final DotTiemSelected = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          key: _formKey,
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "I - Chọn Đợt Tiêm",
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
              Row(
                children: [
                  DropdownButton<String>(
                    items: ListQr.map<DropdownMenuItem<String>>(
                        (Vaccination value) {
                      // SelectedValue=value.HoTen;
                      return DropdownMenuItem<String>(
                          value: value.ID_DotTiem,
                          child: Text(
                              '${value.Ngay_Tiem.day}-${value.Ngay_Tiem.month}-${value.Ngay_Tiem.year}  ${value.Loai_Vaccine}'));
                    }).toList(),
                    value: SelectedValue,
                    onChanged: (String? selected) {
                      setState(() {
                        SelectedValue = selected!;
                      });
                    },
                  ),
                ],
              ),
              const Text(' Số thứ tự mũi tiêm'),
              SizedBox(height: getProportionateScreenHeight(10)),
              buildSTTNumberFormField(),
              //chonngaytiem
              SizedBox(height: getProportionateScreenHeight(10)),
              TextButton(
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(2000, 01, 01),
                        maxTime: DateTime(2022, 12, 31),
                        onChanged: (date) {}, onConfirm: (date) async {
                      String datetime = date.year.toString() +
                          '-' +
                          date.month.toString() +
                          '-' +
                          date.day.toString();
                      RDateTimeController.text = datetime.toString();
                    }, currentTime: DateTime.now(), locale: LocaleType.vi);
                  },
                  child: Text(
                    'Nhấn để chọn ngày tiêm gần nhất\n*Tiêm lần đầu không cần chọn',
                    style: TextStyle(color: Colors.blue),
                  )),
              buildDateTimeFormField(),
              Text(
                "II - Khai Báo",
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
              const Text(
                '1.Đã từng mắc covid hay chưa?',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              ListTile(
                leading: Radio<String>(
                  value: '0',
                  groupValue: _selectedDauHieu,
                  onChanged: (value) {
                    setState(() {
                      _selectedDauHieu = value!;
                    });
                  },
                ),
                title: const Text('Có'),
              ),
              ListTile(
                leading: Radio<String>(
                  value: '1',
                  groupValue: _selectedDauHieu,
                  onChanged: (value) {
                    setState(() {
                      _selectedDauHieu = value!;
                    });
                  },
                ),
                title: const Text('Không'),
              ),
              //const SizedBox(height: 25),

              const Text(
                '2.Đang mắc bệnh cấp tính',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: Radio<String>(
                  value: '0',
                  groupValue: _selectedCapTinh,
                  onChanged: (value) {
                    setState(() {
                      _selectedCapTinh = value!;
                    });
                  },
                ),
                title: const Text('Có'),
              ),
              ListTile(
                leading: Radio<String>(
                  value: '1',
                  groupValue: _selectedCapTinh,
                  onChanged: (value) {
                    setState(() {
                      _selectedCapTinh = value!;
                    });
                  },
                ),
                title: const Text('Không'),
              ),
              const Text(
                '3.Phụ nữ đang mang thai',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
              ),
              ListTile(
                leading: Radio<String>(
                  value: '0',
                  groupValue: _selectedMangThai,
                  onChanged: (value) {
                    setState(() {
                      _selectedMangThai = value!;
                    });
                  },
                ),
                title: const Text('Có'),
              ),
              ListTile(
                leading: Radio<String>(
                  value: '1',
                  groupValue: _selectedMangThai,
                  onChanged: (value) {
                    setState(() {
                      _selectedMangThai = value!;
                    });
                  },
                ),
                title: const Text('Không'),
              ),
              const Text(
                '4.Phản vệ độ 3 trở lên với bất kỳ dị nguyên nào ',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                ),
              ),
              ListTile(
                leading: Radio<String>(
                  value: '0',
                  groupValue: _selectedPhanVe,
                  onChanged: (value) {
                    setState(() {
                      _selectedPhanVe = value!;
                    });
                  },
                ),
                title: const Text('Có'),
              ),
              ListTile(
                leading: Radio<String>(
                  value: '1',
                  groupValue: _selectedPhanVe,
                  onChanged: (value) {
                    setState(() {
                      _selectedPhanVe = value!;
                    });
                  },
                ),
                title: const Text('Không'),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              const Text(
                '5.Đang bị suy giảm miễn dịch nặng ',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              ListTile(
                leading: Radio<String>(
                  value: '0',
                  groupValue: _selectedMienDich,
                  onChanged: (value) {
                    setState(() {
                      _selectedMienDich = value!;
                    });
                  },
                ),
                title: const Text('Có'),
              ),
              ListTile(
                leading: Radio<String>(
                  value: '1',
                  groupValue: _selectedMienDich,
                  onChanged: (value) {
                    setState(() {
                      _selectedMienDich = value!;
                    });
                  },
                ),
                title: const Text('Không'),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              const Text(
                '6.Ung thư giai đoạn cuối đang điều trị hóa trị, xạ trị ',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              ListTile(
                leading: Radio<String>(
                  value: '0',
                  groupValue: _selectedUngThu,
                  onChanged: (value) {
                    setState(() {
                      _selectedUngThu= value!;
                    });
                  },
                ),
                title: const Text('Có'),
              ),
              ListTile(
                leading: Radio<String>(
                  value: '1',
                  groupValue: _selectedUngThu,
                  onChanged: (value) {
                    setState(() {
                      _selectedUngThu = value!;
                    });
                  },
                ),
                title: const Text('Không'),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              const Text(
                '7.Tiền sử dị ứng với bất kỳ dị nguyên nào',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              ListTile(
                leading: Radio<String>(
                  value: '0',
                  groupValue: _selectedDiUng,
                  onChanged: (value) {
                    setState(() {
                      _selectedDiUng = value!;
                    });
                  },
                ),
                title: const Text('Có'),
              ),
              ListTile(
                leading: Radio<String>(
                  value: '1',
                  groupValue: _selectedDiUng,
                  onChanged: (value) {
                    setState(() {
                      _selectedDiUng = value!;
                    });
                  },
                ),
                title: const Text('Không'),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              const Text(
                '8.Tiền sử rối loạn đông máu/cầm máu ',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              ListTile(
                leading: Radio<String>(
                  value: '0',
                  groupValue: _selectedRoiLoanMau,
                  onChanged: (value) {
                    setState(() {
                      _selectedRoiLoanMau = value!;
                    });
                  },
                ),
                title: const Text('Có'),
              ),
              ListTile(
                leading: Radio<String>(
                  value: '1',
                  groupValue: _selectedRoiLoanMau,
                  onChanged: (value) {
                    setState(() {
                      _selectedRoiLoanMau = value!;
                    });
                  },
                ),
                title: const Text('Không'),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              const Text(
                '9.Rối loạn tri giác, rối loạn hành vi',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              ListTile(
                leading: Radio<String>(
                  value: '0',
                  groupValue: _selectedTriGiac,
                  onChanged: (value) {
                    setState(() {
                      _selectedTriGiac = value!;
                    });
                  },
                ),
                title: const Text('Có'),
              ),
              ListTile(
                leading: Radio<String>(
                  value: '1',
                  groupValue: _selectedTriGiac,
                  onChanged: (value) {
                    setState(() {
                      _selectedTriGiac = value!;
                    });
                  },
                ),
                title: const Text('Không'),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Text(
                "III - Ý Kiến Đồng Thuận",
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
              const Text(
                ' Sau khi đã đọc các thông tin ở dưới, tôi đã hiểu về các nguy cơ và cam đoan những điều tôi khai báo là chính xác. Tôi hoàn toàn chịu trách nhiệm khi có thông tin sai lệch',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontStyle: FontStyle.italic),
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context, builder: (context) => buildSheet());
                },
                child: Text(
                  "Xem thông tin",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: agree,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        agree = value;
                      });
                    },
                  ),
                  Text("Đồng ý tiêm chủng"),
                  //Spacer(),
                ],
              ),

              RoundedLoadingButton(color: Colors.green,
                child: Text('Đăng ký', style: TextStyle(color: Colors.white)),
                controller: _btnController,
                onPressed: () async {
                  final check_id_congdan = await ReturnID(tentaikhoan);
                  final new_id_ds = await NEW_DS_ID();
                  final checkds = await CheckDS(check_id_congdan, SelectedValue.toString());
                 // final vd=await CheckVDT(SelectedValue.toString());
                //  final checkdt = await CheckDatetime(RDateTimeController.text.toString(),await CheckVDT(SelectedValue.toString()));
                  if (SelectedValue == null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Row(children: [
                            Image.network(
                              'https://flutter-examples.com/wp-content/uploads/2019/12/android_icon.png',
                              width: 50,
                              height: 50,
                              fit: BoxFit.contain,
                            ),
                            Text('  Thông báo ')
                          ]),
                          content: Text("Bạn chưa chọn đợt tiêm"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Trở về"),
                              onPressed: () {
                                //Put your code here which you want to execute on Cancel button click.
                                Navigator.of(context).pop();
                                _btnController.reset();
                                return;
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else if (agree == false) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Row(children: [
                            Image.network(
                              'https://flutter-examples.com/wp-content/uploads/2019/12/android_icon.png',
                              width: 50,
                              height: 50,
                              fit: BoxFit.contain,
                            ),
                            Text('  Thông báo ')
                          ]),
                          content: Text("Bạn chưa đồng ý tiêm chủng"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Trở về"),
                              onPressed: () {
                                //Put your code here which you want to execute on Cancel button click.
                                _btnController.reset();
                                Navigator.of(context).pop();
                                return;
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else if (checkds == 0&&await CheckSLDK(SelectedValue.toString()) >=
                      await CheckSL(SelectedValue.toString())) {
                    connection().write("EXEC dbo.Insert_DSTIEM '" + new_id_ds +
                        "','" + check_id_congdan + "','" + SelectedValue.toString() + "','" + RSTTController.text + "',true,'" +_selectedDauHieu + "','" + _selectedCapTinh + "','" +_selectedMangThai+ "','" + _selectedPhanVe + "','" + _selectedMienDich+ "','" + _selectedUngThu+ "','" + _selectedDiUng+ "','" +_selectedRoiLoanMau+ "','" + _selectedTriGiac+ "','6'");
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Row(children: [
                            Image.network(
                              'https://flutter-examples.com/wp-content/uploads/2019/12/android_icon.png',
                              width: 50,
                              height: 50,
                              fit: BoxFit.contain,
                            ),
                            Text('  Thông báo ')
                          ]),
                          content: Text("Đăng ký thành công\nSố lượng người đăng ký đã đủ"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Trở về"),
                              onPressed: () {
                                //Put your code here which you want to execute on Cancel button click.
                                _btnController.reset();
                                Navigator.of(context).pop();
                                return;
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else if (checkds == 0 && await CheckDatetime(RDateTimeController.text.toString(),await CheckVDT(SelectedValue.toString())) >= 30) {
                    try {
                      print("Neu ngay lon hon 30");
                      connection().write("EXEC dbo.Insert_DSTIEM '" + new_id_ds +
                          "','" + check_id_congdan + "','" + SelectedValue.toString() + "','" + RSTTController.text + "',true,'" +_selectedDauHieu + "','" + _selectedCapTinh + "','" +_selectedMangThai+ "','" + _selectedPhanVe + "','" + _selectedMienDich+ "','" + _selectedUngThu+ "','" + _selectedDiUng+ "','" +_selectedRoiLoanMau+ "','" + _selectedTriGiac+ "','0'");
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Row(children: [
                              Image.network(
                                'https://flutter-examples.com/wp-content/uploads/2019/12/android_icon.png',
                                width: 50,
                                height: 50,
                                fit: BoxFit.contain,
                              ),
                              Text('  Thông báo ')
                            ]),
                            content: Text("Đăng ký thành công\nMời kiểm tra thông báo"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("Ok"),
                                onPressed: () {
                                  //Put your code here which you want to execute on Cancel button click.
                                  Navigator.pushNamed(
                                      context, HomeScreen.routeName,
                                      arguments: tentaikhoan);
                                  ;
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } on Exception catch (e) {
                      print(e);
                    }
                  } else if (checkds == 0 && await CheckDatetime(RDateTimeController.text.toString(),await CheckVDT(SelectedValue.toString())) < 30) {
                    try {
                      print("Neu ngay be hon 30");
                      connection().write("EXEC dbo.Insert_DSTIEM '" + new_id_ds +
                          "','" + check_id_congdan + "','" + SelectedValue.toString() + "','" + RSTTController.text + "',true,'" +_selectedDauHieu + "','" + _selectedCapTinh + "','" +_selectedMangThai+ "','" + _selectedPhanVe + "','" + _selectedMienDich+ "','" + _selectedUngThu+ "','" + _selectedDiUng+ "','" +_selectedRoiLoanMau+ "','" + _selectedTriGiac+ "','5'");
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Row(children: [
                              Image.network(
                                'https://flutter-examples.com/wp-content/uploads/2019/12/android_icon.png',
                                width: 50,
                                height: 50,
                                fit: BoxFit.contain,
                              ),
                              Text('  Thông báo ')
                            ]),
                            content: Text("Đăng ký thành công\nMời kiểm tra thông báo"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("Ok"),
                                onPressed: () {
                                  //Put your code here which you want to execute on Cancel button click.
                                  Navigator.pushNamed(
                                      context, HomeScreen.routeName,
                                      arguments: tentaikhoan);
                                  ;
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } on Exception catch (e) {
                      print(e);
                    }
                  } else if (checkds != 0) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Row(children: [
                            Image.network(
                              'https://flutter-examples.com/wp-content/uploads/2019/12/android_icon.png',
                              width: 50,
                              height: 50,
                              fit: BoxFit.contain,
                            ),
                            Text('  Thông báo ')
                          ]),
                          content: Text("Bạn đã đăng ký đợt này"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Trở về"),
                              onPressed: () {
                                //Put your code here which you want to execute on Cancel button click.
                                _btnController.reset();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                  ;
                },
              ),
              FormError(errors: errors),
              SizedBox(height: getProportionateScreenHeight(30)),
            ],
          )),
    );
  }

  Future<String> NEW_DS_ID() async {
    String res = await SqlConn.readData("EXEC dbo.New_ID_DKTIEM");
    //print(res.toString());
    var cd = jsonDecode(res.toString());
    String new_id = (cd[0][''].toString());
    //print(a);
    return new_id;
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

  Future<int> CheckDS(String CD, String DT) async {
    String res = await SqlConn.readData(
        "select dbo.kiemtraDSTIEM('" + CD + "','" + DT + "')");
    //print(res.toString());
    var cd = jsonDecode(res.toString());
    int a = (cd[0]['']);
    //print(a);
    return a;
  }

  Future<int> CheckSLDK(String DT) async {
    String res =
        await SqlConn.readData("select dbo.kiemtraDotTiem('" + DT + "')");
    //print(res.toString());
    var cd = jsonDecode(res.toString());
    int a = (cd[0]['']);
    //print(a);
    return a;
  }

  Future<int> CheckSL(String DT) async {
    String res = await SqlConn.readData(
        "select SLNguoiDuKien from DotTiemChung where ID_DotTiem='" + DT + "'");
    //print(res.toString());
    var cd = jsonDecode(res.toString());
    int a = (cd[0]['SLNguoiDuKien']);
    //print(a);
    return a;
  }

  Future<int> CheckSTT(String id) async {
    String res = await SqlConn.readData(
        "select count(STTMuiTiem)+1 from [dbo].[LichSuTiem] where ID_CongDan='" +
            id +
            "'");
    //print(res.toString());
    var cd = jsonDecode(res.toString());
    int a = (cd[0]['']);
    //print(a);
    return a;
  }

  Future<int> CheckDatetime(String dt,String vd) async {
    String res = await SqlConn.readData(
        "SELECT DATEDIFF(day, '" + dt.toString() + "', '"+vd+"')");
    var cd = jsonDecode(res.toString());
    int a = (cd[0]['']);
    return a;
  }
  Future<String> CheckVDT(String dt) async {
    String res = await SqlConn.readData(
        "SELECT NgayTiem from DotTiemChung where ID_DotTiem='"+dt+"'");
    var cd = jsonDecode(res.toString());
    String a = (cd[0]['NgayTiem']);
    return a;
  }

  TextFormField buildGoToFormField() {
    return TextFormField(
      controller: GoToController,
      onSaved: (newValue) => goto = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kGoToNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kGoToNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Nơi đến",
        hintText: "Trong vòng 14 ngày",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  TextFormField buildSTTNumberFormField() {
    return TextFormField(
      controller: RSTTController,
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => STT = newValue,
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
        labelText: "",
        hintText: "Nhập số thứ tự mũi tiêm",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildDateTimeFormField() {
    return TextFormField(
      enabled: false,
      controller: RDateTimeController,
      keyboardType: TextInputType.text,
      onSaved: (newValue) => DT = newValue,
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
        labelText: "",
        hintText: "Chon ngay tiem gan nhat",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  Widget buildSheet() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: Text(
              '1. Tiêm chủng vắc xin là biện pháp phòng bệnh hiệu quả, tuy nhiên vắc xin phòng COVID-19 có thể không phòng được bệnh hoàn toàn. Người được tiêm chủng vắc xin phòng COVID-19 đủ liều có thể phòng được bệnh hoặc giảm mức độ nặng nếu mắc COVID-19. Sau khi được tiêm vắc xin phòng COVID-19 vẫn cần thực hiện đầy đủ Thông điệp 5K phòng, chống dịch COVID-19.'
              '\n 2. Tiêm chủng vắc xin phòng COVID-19 có thể gây ra một số biểu hiện tại chỗ tiêm hoặc toàn thân như sưng, đau chỗ tiêm, nhức đầu, buồn nôn, sốt, đau cơ ... hoặc tai biến nặng sau tiêm chủng.'
              '\n3. Khi có triệu chứng bất thường về sức khỏe, người được tiêm chủng cần liên hệ với cơ sở y tế gần nhất để được tư vấn, khám và điều trị kịp thời.',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontStyle: FontStyle.italic),
            ),
          ),
          Spacer(),

          // Center(
          //   child: ElevatedButton(
          //     child: Text('Đóng'),
          //     onPressed: ()=>Navigator.of(context).pop(),
          //   ),
          // )
        ],
      );
}
