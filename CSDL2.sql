﻿create database QLVH
use QLVH
set dateformat DMY
-----QUOCGIA(MAQG,TENQG,CHAULUC,DIENTICH)
create table QUOCGIA
(
	MAQG varchar(10) not null,
	TENQG varchar(50),
	CHAULUC varchar(50),
	DIENTICH int
)
alter table QUOCGIA
add constraint PK_QUOCGIA primary key(MAQG)

create table THEVANHOI
(
	MATVH varchar(10) not null,
	TENTVH varchar(50),
	MAQG varchar(10),
	NAM int
)
alter table THEVANHOI
add constraint PK_THEVANHOI primary key(MATVH)

create table VANDONGVIEN
(
	MAVDV varchar(10) not null,
	HOTEN varchar(50),
	NGSINH datetime,
	GIOITINH varchar(50),
	QUOCTICH varchar(10)
)
alter table VANDONGVIEN
add constraint PK_VANDONGVIEN primary key(MAVDV)

create table NOIDUNGTHI
(
	MANDT varchar(10) not null,
	TENNDT varchar(50),
	GHICHU varchar(50)
)
alter table NOIDUNGTHI
add constraint PK_NOIDUNGTHI primary key(MANDT)

create table THAMGIA
(
	MAVDV varchar(10) not null,
	MANDT varchar(10) not null,
	MATVH varchar(10) not null,
	HUYCHUONG varchar(50)
)
alter table THAMGIA
add constraint PK_THAMGIA primary key(MAVDV,MANDT,MATVH)

--Nhập dữ liệu
insert into QUOCGIA
	(MAQG, TENQG, CHAULUC, DIENTICH)
values
	('DE', 'Đức', 'Châu Âu',NULL),
	('UK', 'Anh', 'Châu Âu',NULL),
	('JA', 'Nhật Bản', 'Châu Á',NULL),
	('BR', 'Brazil', 'Châu Mĩ',NULL),
	('CH', 'Trung Quốc', 'Châu Á',NULL)

insert into THEVANHOI
	(MATVH, TENTVH, MAQG, NAM)
values
	('TVH01', 'Olympic Bejing 2008', 'CH', '2008'),
	('TVH02', 'Olympic London 2012', 'UK', '2012'),
	('TVH03', 'Olympic Rio 2016', 'BR', '2016'),
	('TVH04', 'Olympic Tokyo 2020', 'JA', '2020')

insert into VANDONGVIEN
	(MAVDV,HOTEN, NGSINH, GIOITINH, QUOCTICH)
values
	('VDV001', 'John', '10/1/1988', 'Nam', 'UK'),
	('VDV002', 'Helen', '20/4/1989', 'Nu', 'UK'),
	('VDV003', 'Osaka', '17/3/1990', 'Nu', 'JA'),
	('VDV004', 'Ronaldo', '1/3/1990', 'Nam', 'BR')

insert into NOIDUNGTHI
	(MANDT, TENNDT,GHICHU)
values
	(1, 'Điền kinh',NULL),
	(2, 'Bắn súng',NULL),
	(3, 'Nhảy cầu',NULL)

----1. Tìm danh sách vận động viên(họ tên, ngày sinh, giới tính) có quốc tịch UK và săp xếp theo họ tên tăng dần
----2. In ra danh dách VDV tham gia nội dung thi bắn cung ử TVH Olympic Tokyo 2020
----3. Cho biết số lượng HCV mà VDV Nhật bản đạt được ử TVH diễn ra vào năm 2020
----4. Kiệt kê họ tên, quốc tịch VDV tham gia cả 2 nội dung thi 100m bơi ngửa và 200m bơi tự do
----5. In ra MAVDV , họ tên của VDV nữ người anh tham gia tất cả kỳ TVH từ 2008 đến nay
----6. Tìm VDV (Mã VDV, Họ tên) đã đạt từ 2 HCV trở lên ở Olympic Rio 2016
----7. In ra VDV tham gia điền kinh Olympic Rio 2016
----8 




-- CAU 1
SELECT HOTEN,NGSINH,GIOITINH
FROM VANDONGVIEN
WHERE QUOCTICH = 'UK'
ORDER BY HOTEN ASC

-- CAU 2
SELECT MAVDV
FROM VANDONGVIEN
WHERE MAVDV IN
(
SELECT A.MAVDV
FROM
THAMGIA A INNER JOIN THEVANHOI B
ON
	A.MATVH = B.MATVH
WHERE 
	 (B.NAM = '2020')
)

-- CAU 3
SELECT COUNT(HUYCHUONG) AS SOHUYCHUONG
FROM VANDONGVIEN M INNER JOIN
(
SELECT A.MAVDV, A.HUYCHUONG
FROM
THAMGIA A INNER JOIN THEVANHOI B
ON
	A.MATVH = B.MATVH
WHERE 
	(B.NAM = '2020')
) N
ON M.MAVDV = N.MAVDV
WHERE M.QUOCTICH = 'NHAT BAN'

-- CAU 4
SELECT HOTEN, QUOCTICH
FROM VANDONGVIEN
WHERE MAVDV IN
(
SELECT A.MAVDV 
FROM THAMGIA A INNER JOIN NOIDUNGTHI B
ON A.MANDT = B.MANDT
WHERE (TENNDT = '100M')
)
INTERSECT
SELECT HOTEN, QUOCTICH
FROM VANDONGVIEN
WHERE MAVDV IN
(
SELECT A.MAVDV 
FROM THAMGIA A INNER JOIN NOIDUNGTHI B
ON A.MANDT = B.MANDT
WHERE (TENNDT = '200M')
)

-- CAU 5
SELECT MAVDV,HOTEN
FROM VANDONGVIEN
WHERE 
(QUOCTICH = 'ANH') AND
(MAVDV IN 
	(
	SELECT A.MAVDV
	FROM THAMGIA A INNER JOIN THEVANHOI B
	ON A.MATVH = B.MATVH
	WHERE NAM = '2008' AND NAM ='2009'AND
	NAM = '2010' AND NAM = '2011'AND NAM ='2012'AND NAM ='2013' AND NAM ='2017' AND NAM ='2018' AND NAM ='2019'
	)
)

-- CAU 6 (còn bug)
SELECT MAVDV,HOTEN 
FROM VANDONGVIEN
WHERE MAVDV IN (
	SELECT A.MAVDV
	FROM THAMGIA A INNER JOIN THEVANHOI B
	ON A.MATVH = B.MATVH
	WHERE (B.NAM = '2016')
	GROUP BY A.MAVDV 
	HAVING (COUNT(A.HUYCHUONG) > 1)
)

--cau 7
SELECT N.MAVDV
FROM NOIDUNGTHI M INNER JOIN
(
SELECT A.MAVDV, A.MANDT
FROM
THAMGIA A INNER JOIN THEVANHOI B
ON
	A.MATVH = B.MATVH
WHERE 
	 (B.NAM = '2016')
) N
ON M.MANDT = N.MANDT
WHERE M.TENNDT = 'DIEN KINH'

--CAU 8

SELECT COUNT(N.HUYCHUONG) AS SOHC 
FROM VANDONGVIEN M INNER JOIN
(
	SELECT A.MAVDV, A.HUYCHUONG
	FROM THAMGIA A INNER JOIN THEVANHOI B
	ON A.MATVH = B.MATVH
	WHERE (B.NAM = '2012')
) N
ON M.MAVDV = N.MAVDV
WHERE (M.QUOCTICH = 'TRUNG QUOC') AND (N.HUYCHUONG = 'BAC')

-- CAU 9
SELECT HOTEN, QUOCTICH
FROM VANDONGVIEN
WHERE MAVDV IN
(
SELECT A.MAVDV 
FROM THAMGIA A INNER JOIN NOIDUNGTHI B
ON A.MANDT = B.MANDT
WHERE (TENNDT = '100M')
)
EXCEPT
SELECT HOTEN, QUOCTICH
FROM VANDONGVIEN
WHERE MAVDV IN
(
SELECT A.MAVDV 
FROM THAMGIA A INNER JOIN NOIDUNGTHI B
ON A.MANDT = B.MANDT
WHERE (TENNDT = '500M')
)

-- CAU 10
SELECT MAVDV,HOTEN
FROM VANDONGVIEN
WHERE 
(QUOCTICH = 'DUC') AND (GIOITINH = 'NAM') AND
(MAVDV IN 
	(
	SELECT A.MAVDV
	FROM THAMGIA A INNER JOIN THEVANHOI B
	ON A.MATVH = B.MATVH
	WHERE NAM = '2008' AND NAM ='2009'AND
	NAM = '2010' AND NAM = '2011'AND NAM ='2012'AND NAM ='2013' AND NAM ='2017' AND NAM ='2018' AND NAM ='2019'
	)
)

--CAU 11

SELECT M.MAVDV
FROM VANDONGVIEN M INNER JOIN (
	SELECT A.MAVDV,A.HUYCHUONG
	FROM THAMGIA A INNER JOIN NOIDUNGTHI B
	ON A.MANDT = B.MANDT
	WHERE (B.TENNDT = 'BAN CUNG')
) N
ON M.MAVDV = N.MAVDV
WHERE (N.HUYCHUONG = 'VANG')
GROUP BY M.MAVDV
having COUNT(N.HUYCHUONG)>1


















