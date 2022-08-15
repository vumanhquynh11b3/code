import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sql_conn/sql_conn.dart';
import 'package:vaccine2/models/vaccination.dart';
import 'dart:ui' as ui;



class QRGeneratorSharePage extends StatefulWidget {
  const QRGeneratorSharePage({Key? key}) : super(key: key);

  @override
  _QRGeneratorSharePageState createState() => _QRGeneratorSharePageState();
}

class _QRGeneratorSharePageState extends State<QRGeneratorSharePage> {
  final key = GlobalKey();
  static GlobalKey previewContainer = new GlobalKey();
  String qrdata = 'Chưa xuất mã QR';
  final textcontroller = TextEditingController();
  File? file;
  List <Vaccination> ListQr = [];
  String? SelectedValue = null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
  GlobalKey scr = GlobalKey();
  GlobalKey scr1 = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final tentaikhoan = ModalRoute.of(context)!.settings.arguments as String;
    return RepaintBoundary(
      key: scr,
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.green.shade500,
          appBar: AppBar(
         backgroundColor: Colors.green.shade500,
          ),
          body:Center(
            child: SingleChildScrollView(
              child:Column(
                children: [
                  RepaintBoundary(
                    key: key,
                    child: Container(
                      color: Colors.white,
                      child: QrImage(
                        size: 300,//size of the QrImage widget.
                        data: qrdata,//textdata used to create QR code
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text("Chọn Đợt Tiêm",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),),
                  Row(children: [
                    DropdownButton<String>(
                      items: ListQr
                          .map<DropdownMenuItem<String>>((Vaccination value) {
                        // SelectedValue=value.HoTen;
                        return DropdownMenuItem<String>(
                            value: value.ID_DotTiem,
                            child: Text('${value.Ngay_Tiem.day}-${value.Ngay_Tiem
                                .month}-${value.Ngay_Tiem.year} ${value.Loai_Vaccine}',
                              style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 20,

                            ),textAlign: TextAlign.center,),

                        );
                      }).toList(),
                      value: SelectedValue,
                      onChanged: (String? selected) {
                        setState(() {
                          SelectedValue = selected!;
                          print(SelectedValue);
                        });
                      },
                    ),
                  ],mainAxisAlignment: MainAxisAlignment.center,),

                  Row(
                    children: [
                      Spacer(),
                      ElevatedButton(
                        child: Text('Xuất Mã QR'),
                        onPressed: () async {
                          final check_id_congdan = await ReturnID(tentaikhoan);
                          final checkqr = await ReturnQr(check_id_congdan,SelectedValue.toString());
                          setState(() {
                            qrdata = checkqr;
                            print(qrdata);
                          });
                        },
                      ),
                      Spacer(),
                      ElevatedButton(
                        child: Text('Lưu Mã Qr '),
                        onPressed: () async {
                            _captureSocialPng();
                        },
                      ),Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future<String> ReturnQr(String id_congdan,String id_dottiem) async {
    String res = await SqlConn.readData(
        "SELECT [dbo].[DSDangKyTiem].ID_DangKyTiem,[dbo].[DSDangKyTiem].ID_CongDan,[dbo].[DSDangKyTiem].ID_DotTiem,[dbo].[DSDangKyTiem].TrangThai,[dbo].[ToKhaiYTe].TienSuNhiemCovid, [dbo].[ToKhaiYTe].DangMacBenhCapTinh,[dbo].[ToKhaiYTe].PhuNuMangThai,[dbo].[ToKhaiYTe].PhanVeDo3,[dbo].[ToKhaiYTe].SuyGiamMienDich,[dbo].[ToKhaiYTe].UngThu,[dbo].[ToKhaiYTe].TienSuDiUng,[dbo].[ToKhaiYTe].TienSuRoiLoanMau,[dbo].[ToKhaiYTe].RoiLoanTriGiacHanhVi,[dbo].[DSDangKyTiem].STTMuiTiem,[dbo].[DSDangKyTiem].YKienDongThuan FROM [dbo].[ToKhaiYTe],[dbo].[DSDangKyTiem] WHERE [dbo].[ToKhaiYTe].ID_ToKhaiYTe=[dbo].[DSDangKyTiem].ID_DangKyTiem AND ID_CongDan='"+id_congdan+"' AND [dbo].[DSDangKyTiem].ID_DotTiem='"+id_dottiem+"'AND [dbo].[DSDangKyTiem].TrangThai='0'");
    print(res.toString());
    var cd = jsonDecode(res.toString());
    return res.toString();
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

  Future<void> _captureSocialPng() {
    List<String> imagePaths = [];
    final RenderBox box = context.findRenderObject() as RenderBox;
    return new Future.delayed(const Duration(milliseconds: 20), () async {
      RenderRepaintBoundary? boundary = key.currentContext!//location
          .findRenderObject() as RenderRepaintBoundary?;
      ui.Image image = await boundary!.toImage();
      final directory = (await getApplicationDocumentsDirectory()).path;
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      File imgFile = new File('$directory/screenshot.png');
      imagePaths.add(imgFile.path);
      imgFile.writeAsBytes(pngBytes).then((value) async {
        final resultsave = await ImageGallerySaver.saveImage(Uint8List.fromList(pngBytes),quality: 90,name: 'QR-TiemChung-${DateTime.now()}.png');

        await Share.shareFiles(imagePaths,
            subject: 'Chia sẻ',
            text: 'Check this Out!',
            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
      }).catchError((onError) {
        print(onError);
      });
    });
  }

}




