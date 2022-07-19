USE QLTiemChung
Go

SELECT * FROM XaPhuong;

update xaphuong
set TenDiaPhuong = (
select XaPhuong.LoaiXaPhuong+' '+TenXaPhuong+', '+LoaiQuanHuyen+' '+TenQuanHuyen+', '+LoaiTinhThanh+' '+TenTinhThanh
From XaPhuong  INNER JOIN QuanHuyen 
ON XaPhuong.MaQuanHuyen = QuanHuyen.MaQuanHuyen INNER JOIN TinhThanh 
ON QuanHuyen.MaTinhThanh = TinhThanh.MaTinhThanh
WHERE XaPhuong.MaXaPhuong = '32248';

use master;
use QLTiemChung;
SELECT count(*) FROM XaPhuong WHERE TenDiaPhuong is NULL OR TenDiaPhuong='';
//11110
Exec dbo.Update_TenDiaPhuong;

Xã Ð?t Mui, Huy?n Ng?c Hi?n, T?nh Cà Mau

select * from XaPhuong where MaXaPhuong = '32248';
select * from QuanHuyen Where MaQuanHuyen = '973'
select * from TinhThanh Where MaTinhThanh = '96'