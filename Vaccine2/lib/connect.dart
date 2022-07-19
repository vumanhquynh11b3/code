import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sql_conn/sql_conn.dart';

class connection{
  late String a;

Future<void>  connect(BuildContext context) async {
  debugPrint("Connecting...");
  try {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text("Đang tải"),
          content: CircularProgressIndicator(),
        );
      },
    );
    await SqlConn.connect(
        ip: "quanlytiemchung1.database.windows.net",
        port: "1433",
        databaseName: "QLTiemChung",
        username: "vumanhquynh11b3",
        password: "Vumanhquynh1999");
    debugPrint("Connected!");
  } catch (e) {
    debugPrint(e.toString());
  } finally {
    Navigator.pop(context);
  }
}
Future<void> read(String query) async {
  var res = await SqlConn.readData(query);
  debugPrint(res.toString());
}
Future<String> readdata(String query) async {
  var res = await SqlConn.readData(query);
  return res;
}
Future<void> write(String query) async {
  try{
  var res = await SqlConn.writeData(query);
  debugPrint(res.toString());}catch(e){print(e);}
}

}