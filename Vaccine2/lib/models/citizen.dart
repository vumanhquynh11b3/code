class Citizen{
  String _HoTen="";
  String _TaiKhoan="";


  Citizen.fromJson(Map<String, dynamic> json)
      : _HoTen = json['HoTen'].toString(),
        _TaiKhoan=json['TaiKhoan'].toString();

  Citizen(this._HoTen, this._TaiKhoan);

  String get MatKhau => _TaiKhoan;

  set MatKhau(String value) {
    _TaiKhoan = value;
  }

  String get HoTen => _HoTen;

  set HoTen(String value) {
    _HoTen = value;
  }
}