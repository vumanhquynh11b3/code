class Vaccination{
  String _ID_Dot_Tiem="";
  DateTime _Ngay_Tiem=new DateTime.now();
  String _Loai_Vaccine="";
  String _Dia_Diem="";
  int _So_Nguoi_Du_Kien=0;
  DateTime _Ngay_Thong_Bao=new DateTime.now();
  String _ID_NV_YTe="";

  Vaccination(
      this._ID_Dot_Tiem,
      this._Ngay_Tiem,
      this._Loai_Vaccine,
      this._Dia_Diem,
      this._So_Nguoi_Du_Kien,
      this._Ngay_Thong_Bao,
      this._ID_NV_YTe);

  Vaccination.fromJson(Map<String, dynamic> json)
      : _ID_Dot_Tiem = json['ID_DotTiem'].toString(),
        _Ngay_Tiem = DateTime.parse(json['NgayTiem']),
        _Loai_Vaccine = json["LoaiVaccine"],
        _Dia_Diem = json["DiaDiem"],
        _So_Nguoi_Du_Kien = json["SLNguoiDuKien"],
        _Ngay_Thong_Bao = DateTime.parse(json['NgayThongBao']),
        _ID_NV_YTe=json["ID_NhanVienYTe"].toString();

  String get ID_NV_YTe => _ID_NV_YTe;

  set ID_NV_YTe(String value) {
    _ID_NV_YTe = value;
  }

  DateTime get Ngay_Thong_Bao => _Ngay_Thong_Bao;

  set Ngay_Thong_Bao(DateTime value) {
    _Ngay_Thong_Bao = value;
  }

  int get So_Nguoi_Du_Kien => _So_Nguoi_Du_Kien;

  set So_Nguoi_Du_Kien(int value) {
    _So_Nguoi_Du_Kien = value;
  }

  String get Dia_Diem => _Dia_Diem;

  set Dia_Diem(String value) {
    _Dia_Diem = value;
  }

  String get Loai_Vaccine => _Loai_Vaccine;

  set Loai_Vaccine(String value) {
    _Loai_Vaccine = value;
  }

  DateTime get Ngay_Tiem => _Ngay_Tiem;

  set Ngay_Tiem(DateTime value) {
    _Ngay_Tiem = value;
  }

  String get ID_DotTiem => _ID_Dot_Tiem;

  set ID_DotTiem(String value) {
    _ID_Dot_Tiem = value;
  }

}