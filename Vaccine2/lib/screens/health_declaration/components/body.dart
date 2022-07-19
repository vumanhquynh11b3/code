import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  bool? agree = false;
  String _selectedDauHieu = '1';
  String _selectedTiepXuc1 = '1';
  String _selectedTiepXuc2 = '1';
  String _selectedTiepXuc3 = '1';
  List <Vaccination> ListQr = [];
  String? SelectedValue = null;
  String? goto;
  final GoToController = TextEditingController();
  String? STT;
  final RSTTController = TextEditingController();
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
    final id=await ReturnID(tentaikhoan);
    final check_stt = await CheckSTT(id);
    RSTTController.text=check_stt.toString();
    GoToController.text="Không";
    });
    DateTime today = DateTime.now();
    SqlConn.readData(
        "select ID_DotTiem,NgayTiem,LoaiVaccine,DiaDiem,SLNguoiDuKien,NgayThongBao from DotTiemChung Where NgayTiem >='" + today.toString() +
            "'").then((value) {
      setState(() {
        List<dynamic> list = json.decode(value);
        // ListQr = list;
        ListQr = list.map((e) =>
        // new Employee(e["ID_NhanSu"], e["HoTen"], e["VaiTro"], 12, e["TaiKhoan"], e["MatKhau"])
        Vaccination.fromJson(e)
        ).toList();
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    final tentaikhoan = ModalRoute
        .of(context)!
        .settings
        .arguments as String;
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
              Text("I - Chọn Đợt Tiêm",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.red

                ),),
              Row(children: [

                DropdownButton<String>(
                  items: ListQr
                      .map<DropdownMenuItem<String>>((Vaccination value) {
                    // SelectedValue=value.HoTen;
                    return DropdownMenuItem<String>(
                        value: value.ID_DotTiem,
                        child: Text('${value.Ngay_Tiem.day}-${value.Ngay_Tiem
                            .month}-${value.Ngay_Tiem.year}  ${value.Loai_Vaccine}')
                    );
                  }).toList(),
                  value: SelectedValue,
                  onChanged: (String? selected) {
                    setState(() {
                      SelectedValue = selected!;
                     // print(SelectedValue);
                    });
                  },
                ),
              ],),
              const Text(
                  ' Số thứ tự mũi tiêm'),
              SizedBox(height: getProportionateScreenHeight(10)),
              buildSTTNumberFormField(),
              SizedBox(height: getProportionateScreenHeight(10)),
              Text("II - Khai Báo Y Tế",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red

                ),),
              const Text(
                  '   1.Trong vòng 14 ngày qua, Anh/Chị có thấy xuất hiện ít nhất 1 trong các dấu hiệu: sốt, ho, khó thở, viêm phổi, đau họng, mệt mỏi không?'
              ,style: TextStyle(
                  fontSize: 16,
                  color: Colors.black
              ),),
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

              const Text('  2.Trong vòng 14 ngày qua, Anh/Chị có tiếp xúc với',style: TextStyle(
                  fontSize: 16,
                  color: Colors.black
              ),),
              const SizedBox(height: 10),
              const Text('  a) Người bệnh hoặc nghi ngờ, mắc bệnh COVID-19',style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontStyle: FontStyle.italic
              ),),
              ListTile(
                leading: Radio<String>(
                  value: '0',
                  groupValue: _selectedTiepXuc1,
                  onChanged: (value) {
                    setState(() {
                      _selectedTiepXuc1 = value!;
                    });
                  },
                ),
                title: const Text('Có'),
              ),
              ListTile(
                leading: Radio<String>(
                  value: '1',
                  groupValue: _selectedTiepXuc1,
                  onChanged: (value) {
                    setState(() {
                      _selectedTiepXuc1 = value!;
                    });
                  },
                ),
                title: const Text('Không'),
              ),
              const Text('  b) Người từ nước có bệnh COVID-19',style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontStyle: FontStyle.italic
              ),),
              ListTile(
                leading: Radio<String>(
                  value: '0',
                  groupValue: _selectedTiepXuc2,
                  onChanged: (value) {
                    setState(() {
                      _selectedTiepXuc2 = value!;
                    });
                  },
                ),
                title: const Text('Có'),
              ),
              ListTile(
                leading: Radio<String>(
                  value: '1',
                  groupValue: _selectedTiepXuc2,
                  onChanged: (value) {
                    setState(() {
                      _selectedTiepXuc2 = value!;
                    });
                  },
                ),
                title: const Text('Không'),
              ),
              const Text(
                  ' c) Người có biểu hiện (Sốt, ho, khó thở , Viêm phổi)',style: TextStyle(
              fontSize: 14,
              color: Colors.black,
                  fontStyle: FontStyle.italic
              ),),
              ListTile(
                leading: Radio<String>(
                  value: '0',
                  groupValue: _selectedTiepXuc3,
                  onChanged: (value) {
                    setState(() {
                      _selectedTiepXuc3 = value!;
                    });
                  },
                ),
                title: const Text('Có'),
              ),
              ListTile(
                leading: Radio<String>(
                  value: '1',
                  groupValue: _selectedTiepXuc3,
                  onChanged: (value) {
                    setState(() {
                      _selectedTiepXuc3 = value!;
                    });
                  },
                ),
                title: const Text('Không'),
              ),
              const Text(
                  '   3. Trong vòng 14 ngày qua, Anh/Chị có đến quốc gia/vùng lãnh thổ nào (Có thể đi qua nhiều quốc gia)'
                  ,style: TextStyle(
              fontSize: 16,
              color: Colors.black
              ),),
              SizedBox(height: getProportionateScreenHeight(20)),
              buildGoToFormField(),
              SizedBox(height: getProportionateScreenHeight(10)),
              Text("III - Ý Kiến Đồng Thuận",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red
                ),),
              const Text(
                  ' Sau khi đã đọc các thông tin ở dưới, tôi đã hiểu về các nguy cơ và:',style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontStyle: FontStyle.italic
              ),),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => buildSheet());
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

              DefaultButton(
                text: "Đăng ký",
                press: () async {
                  final check_id_congdan = await ReturnID(tentaikhoan);
                  final new_id_ds = await NEW_DS_ID();
                  final checkds = await CheckDS(check_id_congdan, SelectedValue.toString());
                  if(SelectedValue==null){
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
                          content: Text("Bạn chưa chọn đợt tiêm"),
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
                    );
                  }
                  else if (agree == false) {
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
                          content: Text("Bạn chưa đồng ý tiêm chủng"),
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
                    );
                  }
                  else if (await CheckSLDK(SelectedValue.toString())>=await CheckSL(SelectedValue.toString())) {
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
                          content: Text("Số lượng người đăng ký đã đủ"),
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
                    );
                  }
                  else if(checkds==0){
                    try {
                      connection().write(
                          "EXEC dbo.Insert_DSTIEM '" + new_id_ds + "','" +
                              check_id_congdan + "','" +
                              SelectedValue.toString() + "','"+RSTTController.text+"',true,'" +
                              GoToController.text + "','" + _selectedDauHieu +
                              "','" + _selectedTiepXuc1 + "','" +
                              _selectedTiepXuc2 + "','" + _selectedTiepXuc3 +
                              "','0'");
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
                                child: Text("Oke"),
                                onPressed: () { //Put your code here which you want to execute on Cancel button click.
                                  Navigator.pushNamed(context, HomeScreen.routeName,arguments: tentaikhoan);;
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }on Exception catch(e){print(e);}
                  }else if(checkds!=0){
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
                          content: Text("Bạn đã đăng ký đợt này"),
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
                    );
                  };
                },
              ),
              FormError(errors: errors),
              SizedBox(height: getProportionateScreenHeight(30)),
            ],

          )),
    );
  }

  Future<String> NEW_DS_ID() async {
    String res = await SqlConn.readData(
        "EXEC dbo.New_ID_DKTIEM");
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
  Future<int> CheckDS(String CD,String DT) async {
    String res = await SqlConn.readData(
        "select dbo.kiemtraDSTIEM('"+CD+"','"+DT+"')");
    //print(res.toString());
    var cd = jsonDecode(res.toString());
    int a = (cd[0]['']);
    //print(a);
    return a;
  }
  Future<int> CheckSLDK(String DT) async {
    String res = await SqlConn.readData(
        "select dbo.kiemtraDotTiem('"+DT+"')");
    //print(res.toString());
    var cd = jsonDecode(res.toString());
    int a = (cd[0]['']);
    //print(a);
    return a;
  }
  Future<int> CheckSL(String DT) async {
    String res = await SqlConn.readData(
        "select SLNguoiDuKien from DotTiemChung where ID_DotTiem='"+DT+"'");
    //print(res.toString());
    var cd = jsonDecode(res.toString());
    int a = (cd[0]['SLNguoiDuKien']);
    //print(a);
    return a;
  }
  Future<int> CheckSTT(String id) async {
    String res = await SqlConn.readData(
        "select count(STTMuiTiem)+1 from [dbo].[LichSuTiem] where ID_CongDan='"+id+"'");
    //print(res.toString());
    var cd = jsonDecode(res.toString());
    int a = (cd[0]['']);
    //print(a);
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
  Widget buildSheet() =>
      Column(
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
            fontStyle: FontStyle.italic
      ),),
          ),Spacer(),

          // Center(
          //   child: ElevatedButton(
          //     child: Text('Đóng'),
          //     onPressed: ()=>Navigator.of(context).pop(),
          //   ),
          // )
        ],
      );

}