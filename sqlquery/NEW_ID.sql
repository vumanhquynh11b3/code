/****** Object:  StoredProcedure [dbo].[New_ID_DKTIEM]    Script Date: 6/29/2022 8:56:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[New_ID_DKTIEM]
AS
BEGIN
DECLARE @ma_next varchar(20)
SET @ma_next=CONVERT(VARCHAR(10),getdate(),5)+'_'+LEFT(NEWID(),9)
WHILE(exists(select ID_DangKyTiem from [dbo].[DSDangKyTiem] where ID_DangKyTiem	=@ma_next))
BEGIN
SET @ma_next='DS_DK_'+LEFT(NEWID(),9)
END
SELECT @ma_next
END