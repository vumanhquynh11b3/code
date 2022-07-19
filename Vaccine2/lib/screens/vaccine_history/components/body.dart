import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:sql_conn/sql_conn.dart';


class ExampleApp extends StatefulWidget {
  const ExampleApp({Key? key}) : super(key: key);

  @override
  State<ExampleApp> createState() => _ExampleAppState();

}

class _ExampleAppState extends State<ExampleApp> {
  final REmailController = TextEditingController();
  List <History> ListQr = [];
  var args;
  static String hoten='';
  void initState() {
    // TODO: implement initState
    super.initState();
      Future.delayed(Duration.zero, () async {
        final tentaikhoan = ModalRoute
            .of(context)!
            .settings
            .arguments as String;

        final check_id_congdan = await ReturnID(tentaikhoan);
        hoten=await ReturnName(check_id_congdan);
        SqlConn.readData(
            "select * from LichSuTiem where ID_CongDan='"+check_id_congdan+"'").then((
            value) {
          setState(() {
            List<dynamic> list = json.decode(value);
            // ListQr = list;
            ListQr = list.map((e) =>
                History.fromJson(e)
            ).toList();
          });
        });
        REmailController.text=check_id_congdan;
        });

  }

  @override
  Widget build(BuildContext context) {


    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          const Text('Tìm kiếm theo tên vaccine'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: SearchableList<History>.sliver(
                initialList: ListQr,
                builder: (History actor) => ActorItem(actor: actor),
                filter: _filterUserList,
                emptyWidget: const EmptyView(),
                onItemSelected: (History item) {
                  showModalBottomSheet(context: context,backgroundColor: Colors.white, builder: (context)=>
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 470,
                      decoration: BoxDecoration(
                        color: Colors.green[600],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'CHỨNG NHẬN TIÊM VACCINE',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25
                                ),
                              ),
                                  Spacer(),
                                  RepaintBoundary(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 50),
                                      color: Colors.white,
                                      child: QrImage(
                                        size: 250,//size of the QrImage widget.
                                        data: '$hoten'+'|'+item.stt.toString()+'|'+'${item.dt.day}-${item.dt
                                            .month}-${item.dt.year}'+'|'+item.vctype+'|'+item.stt.toString(),),
                                    ),
                                  ),
                              Spacer(),
                              Text(
                                'Thông tin :',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 25,
                                ),
                              ),
                              Text(
                                'Mũi Tiêm Thứ '+item.stt.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20
                                ),
                              ),
                              // Spacer(),
                              Text(
                                'Họ Tên: '+hoten,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                    fontSize: 20
                                ),
                              ),
                              // Spacer(),
                              Text(
                                'Ngày tiêm: ''${item.dt.day}-${item.dt
                                           .month}-${item.dt.year}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                    fontSize: 20
                                ),
                              ),

                              Text(
                                'Tên Vaccine: '+item.vctype,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                    fontSize: 20
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ));


                },
                inputDecoration: InputDecoration(
                  labelText: "",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                scrollDirection: Axis.vertical,
              ),
            ),
          ),
         buildEmailFormField(),
        ],
      ),
    );
  }

  List<History> _filterUserList(String searchTerm) {
    return ListQr
        .where(
          (element) =>
      element.vctype.toLowerCase().contains(searchTerm) ||
          element.vctype.contains(searchTerm),
    )
        .toList();
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
  Future<String> ReturnName(String tentaikhoan) async {
    String res = await SqlConn.readData(
        "select HoTen From NhanSu where ID_NhanSu ='" + tentaikhoan + "'");
    print(res.toString());
    var cd = jsonDecode(res.toString());
    String ht = (cd[0]['HoTen'].toString());
    print(ht);
    return ht;
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
  Widget buildSheet() =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '1. Tiêm chủng vắc xin',
            style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontStyle: FontStyle.italic
            ),),

        ],
      );
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
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Icon(
              Icons.star,
              color: Colors.red[700],
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(
                  'Vaccine: ${actor.vctype}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Ngày tiêm: ${actor.dt.day}-${actor.dt
                      .month}-${actor.dt.year} ',
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Thời gian: ${actor.dt.hour} giờ ${actor.dt.minute} phút ',
                  style: const TextStyle(
                    color: Colors.brown,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Mũi tiêm thứ: ${actor.stt}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
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

// class Actor {
//   int age;
//   String name;
//   String lastName;
//
//   Actor({
//     required this.age,
//     required this.name,
//     required this.lastName,
//   });
// }
class History{
  String id="";
  int stt=1;
  DateTime dt=DateTime.now();
  String vctype="";

  History({required this.id, required this.stt, required this.dt, required this.vctype});

  History.fromJson(Map<String, dynamic> json)
      : id = json['ID_CongDan'].toString(),
        stt = (json['STTMuiTiem']),
        dt = DateTime.parse(json['NgayGioTiem']),
        vctype = json['LoaiVaccine'].toString();


}