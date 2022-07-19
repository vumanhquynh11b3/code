CREATE PROCEDURE [dbo].[Insert_DSTIEM]
	@ID varchar(20), @ID_CD varchar(12), @ID_DOT_TIEM varchar(10), @STT int,
	@YKien bit,@NgayKhai datetime,@NoiDen nvarchar(250),@DauHieu bit,
	@TiepXuc1 bit ,@TiepXuc2 bit , @TiepXuc3 bit
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION;
	BEGIN TRY		
		INSERT INTO DSDangKyTiem(ID_DangKyTiem, ID_CongDan,ID_DotTiem, STTMuiTiem,YKienDongThuan) 
		VALUES (@ID, @ID_CD, @ID_DOT_TIEM, @STT,@YKien);--thuộc tính bảng nhân sự
		INSERT INTO ToKhaiYTe(ID_ToKhaiYTe, NgayGioKhai, NoiDenTrongVong14Ngay, DauHieuBenhCovid, TiepXucNguoiCoBieuHIen,TiepXucNguoiTuNuocCoBenh , TiepXucNguoiBenh) 
		VALUES(@ID, @NgayKhai, @NoiDen, @DauHieu, @TiepXuc1, @TiepXuc2, @TiepXuc3);
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0  ROLLBACK TRANSACTION;  
		
	END CATCH
	IF @@TRANCOUNT > 0
	BEGIN
		COMMIT TRANSACTION;  
		
	END 
	RETURN;
END