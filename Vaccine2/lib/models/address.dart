class TinhThanh{
String _MaTinhThanh="10";
String _TenTinhThanh="";

TinhThanh(this._MaTinhThanh, this._TenTinhThanh);
TinhThanh.fromJson(Map<String, dynamic> json)
    :_MaTinhThanh = json['MaTinhThanh'].toString(),
      _TenTinhThanh = json['TenTinhThanh'];


String get TenTinhThanh => _TenTinhThanh;

  set TenTinhThanh(String value) {
    _TenTinhThanh = value;
  }

  String get MaTinhThanh => _MaTinhThanh;

  set MaTinhThanh(String value) {
    _MaTinhThanh = value;
  }
}