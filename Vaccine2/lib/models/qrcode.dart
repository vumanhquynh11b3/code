class qrcode{
String _ID_DotTiem="";
String _Noi_Den="";
String _Dau_Hieu="";
String _Tiep_Xuc1="";
String _Tiep_Xuc2="";
}

// SELECT [dbo].[DSDangKyTiem].ID_DotTiem,[dbo].[ToKhaiYTe].NoiDenTrongVong14Ngay, [dbo].[ToKhaiYTe].DauHieuBenhCovid, [dbo].[ToKhaiYTe].TiepXucNguoiCoBieuHIen,[dbo].[ToKhaiYTe].TiepXucNguoiTuNuocCoBenh,[dbo].[ToKhaiYTe].TiepXucNguoiBenh,
// [dbo].[DSDangKyTiem].STTMuiTiem,[dbo].[DSDangKyTiem].YKienDongThuan
// FROM [dbo].[ToKhaiYTe],[dbo].[DSDangKyTiem]
// WHERE [dbo].[ToKhaiYTe].ID_ToKhaiYTe=[dbo].[DSDangKyTiem].ID_DangKyTiem AND
// ID_CongDan='170500589999' AND [dbo].[DSDangKyTiem].ID_DotTiem='TC00000001'