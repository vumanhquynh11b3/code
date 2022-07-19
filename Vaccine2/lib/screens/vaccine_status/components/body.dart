import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:sql_conn/sql_conn.dart';
import 'package:vaccine2/components/default_button.dart';


class ExampleApp extends StatefulWidget {
  const ExampleApp({Key? key}) : super(key: key);

  @override
  State<ExampleApp> createState() => _ExampleAppState();

}

class _ExampleAppState extends State<ExampleApp> {
  final REmailController = TextEditingController();
  List <History> ListQr = [];
  var args;
  void initState() {
    // TODO: implement initState
    super.initState();
      Future.delayed(Duration.zero, () async {
        final tentaikhoan = ModalRoute
            .of(context)!
            .settings
            .arguments as String;
        final check_id_congdan = await ReturnID(tentaikhoan);
        SqlConn.readData(
            "select [dbo].[DSDangKyTiem].TrangThai,[dbo].[DotTiemChung].LoaiVaccine,[dbo].[DotTiemChung].NgayTiem from [dbo].[DSDangKyTiem] INNER JOIN [dbo].[DotTiemChung] on [dbo].[DSDangKyTiem].ID_DotTiem=[dbo].[DotTiemChung].ID_DotTiem "
                "Where [dbo].[DSDangKyTiem].ID_CongDan='"+check_id_congdan+"'")
            .then((
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
                onItemSelected: (History item) {},
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
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if(actor.tt==0)
                Text(
                  'Trạng Thái: Chưa quét QR',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )else if(actor.tt==1)
                  Text(
                    'Trạng Thái: Đã tiếp nhận',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )else if(actor.tt==2)
                    Text(
                      'Trạng Thái: Sức khỏe đạt',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),)else if(actor.tt==3)
                      Text(
                        'Trạng Thái: Sức khỏe không đạt',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )
                      )else if(actor.tt==4)
                        Text(
    'Trạng Thái: Đã tiêm',
    style: const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    ),),
                if(actor.kl=='0')
                  Text(
                    'Kết Luận: false',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )else if(actor.kl=='1')
                  Text(
                    'Kết Luận: true',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),),
                if(actor.dt.toString().compareTo(DateTime.now().toString())>0) Text(
                  'Chưa đến ngày tiêm',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                )else if(DateFormat.yMMMd().format(actor.dt).compareTo(DateFormat.yMMMd().format(DateTime.now()))==0)
                  Text(
                    'Đã đến ngày tiêm',
                    style: const TextStyle(
                      color: Colors.yellow ,
                      fontWeight: FontWeight.bold,
                    ),)else if(actor.dt.toString().compareTo(DateTime.now().toString())<0) Text(
                    'Đã qua ngày tiêm',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w900,
                    ),),

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
        Text('Không tìm thấy đợt tiêm'),
      ],
    );
  }
}

class History{
  int tt=1;
  DateTime dt=DateTime.now();
  String vctype="";
  String kl="";
  History({ required this.tt, required this.vctype,required this.dt});

  History.fromJson(Map<String, dynamic> json)
      :
        tt = int.parse(json['TrangThai']),
        vctype = json['LoaiVaccine'].toString(),
        dt = DateTime.parse(json['NgayTiem']);
     //   kl=json['KetLuan'].toString();


}