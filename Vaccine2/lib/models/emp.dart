class Employee {
  String _ID_NhanSu = "";
  String _HoTen = "";
  String _VaiTro = "";
  int _GioiTinh = 0;
  String _TaiKhoan = "";
  String _MatKhau = "";

  String get ID_NhanSu => _ID_NhanSu;

  Employee(this._ID_NhanSu, this._HoTen, this._VaiTro, this._GioiTinh,
      this._TaiKhoan, this._MatKhau);

  Employee.fromJson(Map<String, dynamic> json)
      : _ID_NhanSu = json['ID_NhanSu'].toString(),
        _HoTen = json['HoTen'],
        _VaiTro = json["VaiTro"],
        _GioiTinh = json["GioiTinh"],
        _TaiKhoan = json["TaiKhoan"],
        _MatKhau = json["MatKhau"].toString();

  String get HoTen => _HoTen;

  String get MatKhau => _MatKhau;

  String get TaiKhoan => _TaiKhoan;

  int get GioiTinh => _GioiTinh;

  String get VaiTro => _VaiTro;
}