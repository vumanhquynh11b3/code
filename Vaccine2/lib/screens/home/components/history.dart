import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:sql_conn/sql_conn.dart';
import 'package:vaccine2/screens/home/components/history.dart';

class ExampleApp extends StatefulWidget {
  const ExampleApp({Key? key}) : super(key: key);

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  final REmailController = TextEditingController();
  List<History> ListQr = [];
  var args;
  static int slcl=0 ;

  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      DateTime today = DateTime.now();
      SqlConn.readData(
              "select ID_DotTiem,NgayTiem,LoaiVaccine,DiaDiem,SLNguoiDuKien from DotTiemChung Where NgayTiem >='" +
                  today.toString() +
                  "'")
          .then((value) {
        setState(() {
          List<dynamic> list = json.decode(value);
          // ListQr = list;

          ListQr = list.map((e) => History.fromJson(e)).toList();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: ListQr != null
            ? FutureBuilder(
                // future: ,
                builder: (context, snapshot) {
                return ListView.builder(
                    itemCount: ListQr.length,
                    shrinkWrap: true,
                    primary: false,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, int index) {
                      //InkWell
                      return GestureDetector(
                        onTap: () => showDialog(
                            context: context,
                            builder: (_) {
                              Future.delayed(Duration.zero, () async {
                                final id = await ListQr[index].id.toString();
                                final sl = await CheckSLDK(id);
                                slcl=await ListQr[index].sldukien-sl;
                                print(slcl);
                              });
                              return AlertDialog(
                                title: Padding(
                                  child: Text(ListQr[index].diadiem
                                    //  +'\n Số Lượng Còn Lại '+slcl.toString()
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                ),
                              );
                            }),
                        child: Container(
                          // color: Colors.green,
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(15),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: Colors.green.shade700,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Tên Vaccine: ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    ListQr[index].vctype,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Ngày Tiêm: ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    '${ListQr[index].dt.day}-${ListQr[index].dt.month}-${ListQr[index].dt.year}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Địa Điểm: ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      ListQr[index].diadiem,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                      maxLines: 1,
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Số Lượng Dự Kiến: ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    ListQr[index].sldukien.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              })
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  List<History> _filterUserList(String searchTerm) {
    return ListQr.where(
      (element) =>
          element.vctype.toLowerCase().contains(searchTerm) ||
          element.vctype.contains(searchTerm),
    ).toList();
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

  Future<int> CheckSLDK(String DT) async {
    String res =
        await SqlConn.readData("select dbo.kiemtraDotTiem('" + DT + "')");
    //print(res.toString());
    var cd = jsonDecode(res.toString());
    int a = (cd[0]['']);
    //print(a);
    return a;
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      enabled: false,
      controller: REmailController,
      decoration: InputDecoration(
        labelText: "ID",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}

class ActorItem extends StatelessWidget {
  final History actor;

  const ActorItem({
    Key? key,
    required this.actor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.green[600],
          borderRadius: BorderRadius.circular(10),
        ),
        // child: Row(
        //   children: [
        //     const SizedBox(
        //       width: 10,
        //     ),
        //     Icon(
        //       Icons.star,
        //       color: Colors.red[700],
        //     ),
        //     const SizedBox(
        //       width: 10,
        //     ),
        //     Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Text(
        //           'Mũi tiêm thứ: ${actor.diadiem}',
        //           style: const TextStyle(
        //             color: Colors.black,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //         Text(
        //           'Vaccine: ${actor.vctype}',
        //           style: const TextStyle(
        //             color: Colors.white,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //         Text(
        //           'Ngày tiêm: ${actor.dt}',
        //           style: const TextStyle(
        //             color: Colors.yellow,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.error,
          color: Colors.red,
        ),
        Text('Không tìm thấy lịch sử tiêm'),
      ],
    );
  }
}

class History {
  String id = "";
  DateTime dt = DateTime.now();
  String vctype = "";
  String diadiem = "";
  int sldukien = 1;

  History(
      {required this.id,
      required this.dt,
      required this.vctype,
      required this.diadiem,
      required this.sldukien});

  //History({required this.id, required this.stt, required this.dt, required this.vctype});

  History.fromJson(Map<String, dynamic> json)
      : id = json['ID_DotTiem'].toString(),
        dt = DateTime.parse(json['NgayTiem']),
        vctype = json['LoaiVaccine'].toString(),
        diadiem = json['DiaDiem'].toString(),
        sldukien = int.parse(json['SLNguoiDuKien'].toString());
}
