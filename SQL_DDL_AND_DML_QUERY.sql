/* CREATE DATABASE SIDE */
CREATE DATABASE ARIBILGIODEV_DB
GO
USE ARIBILGIODEV_DB
CREATE TABLE OGRENCI
(
ogrNo INT NOT NULL PRIMARY KEY IDENTITY(1,1),
ogrAd NVARCHAR(50) NOT NULL,
ogrSoyad NVARCHAR(50) NOT NULL,
cinsiyet CHAR(5),
dTarih DATE,
sinif NVARCHAR(5),
puan TINYINT
)
GO
CREATE TABLE TUR
(
turNo INT NOT NULL PRIMARY KEY IDENTITY(1,1),
turAdi NVARCHAR(50)
)
GO
CREATE TABLE YAZAR
(
yazarNo INT NOT NULL PRIMARY KEY IDENTITY(1,1),
yazarAd NVARCHAR(50) NOT NULL,
yazarSoyad NVARCHAR(50)
)
GO
CREATE TABLE KITAP
(
kitapNo INT NOT NULL PRIMARY KEY IDENTITY(1,1),
isbnNo INT,
kitapAd NVARCHAR(50) NOT NULL,
yazarNo INT NOT NULL FOREIGN KEY REFERENCES YAZAR(yazarNo),
turNo INT NOT NULL FOREIGN KEY REFERENCES TUR(turNo),
sayfaSayisi INT,
puan INT
)
GO
CREATE TABLE ISLEM
(
islemNo INT NOT NULL,
ogrNo INT NOT NULL FOREIGN KEY REFERENCES OGRENCI(ogrNo),
kitapNo INT NOT NULL FOREIGN KEY REFERENCES KITAP(kitapNo),
aTarih DATE,
vTarih DATE
)

/* T-SQL DML SIDE */

-- OGRENCI Tablosu
INSERT INTO OGRENCI (ogrAd, ogrSoyad, cinsiyet, dTarih, sinif, puan)
VALUES 
('Ali', 'Yýlmaz', 'E', '2005-04-15', '10A', 85),
('Ayþe', 'Kaya', 'K', '2006-09-22', '9B', 90),
('Mehmet', 'Demir', 'E', '2004-03-05', '11C', 78),
('Fatma', 'Þahin', 'K', '2005-11-11', '10C', 88),
('Ahmet', 'Koç', 'E', '2003-07-30', '12B', 92);

-- TUR Tablosu
INSERT INTO TUR (turAdi)
VALUES 
('Roman'),
('Bilimkurgu'),
('Tarih'),
('Eðitim'),
('Macera');

-- YAZAR Tablosu
INSERT INTO YAZAR (yazarAd, yazarSoyad)
VALUES 
('Orhan', 'Pamuk'),
('Elif', 'Þafak'),
('Jules', 'Verne'),
('Halil', 'Ýnalcýk'),
('Sabahattin', 'Ali');

-- KITAP Tablosuna 5 Örnek Veri
INSERT INTO KITAP (isbnNo, kitapAd, yazarNo, turNo, sayfaSayisi, puan)
VALUES 
(978123456, 'Masumiyet Müzesi', 1, 1, 560, 95),
(978234567, 'Aþk', 2, 1, 430, 88),
(978345672, 'Denizler Altýnda 20.000 Fersah', 3, 2, 310, 92),
(978490123, 'Devlet-i Aliyye', 4, 3, 250, 85),
(678901234, 'Kürk Mantolu Madonna', 5, 1, 200, 90);


-- ISLEM Tablosu
INSERT INTO ISLEM (islemNo, ogrNo, kitapNo, aTarih, vTarih)
VALUES 
(1, 1, 5, '2024-11-01', '2024-11-15'),
(2, 2, 6, '2024-10-05', '2024-10-20'),
(3, 3, 7, '2024-09-10', '2024-09-25'),
(4, 4, 8, '2024-11-12', '2024-11-27'),
(5, 5, 9, '2024-10-01', '2024-10-16');

SELECT * FROM OGRENCI
SELECT * FROM TUR
SELECT * FROM YAZAR
SELECT * FROM KITAP
SELECT * FROM ISLEM

/* 10 QUERY */

--QUERY 1
SELECT O.ogrAd, O.ogrSoyad, K.kitapAd, I.aTarih, I.vTarih
FROM OGRENCI O
JOIN ISLEM I ON O.ogrNo = I.ogrNo
JOIN KITAP K ON I.kitapNo = K.kitapNo;


-- QUERY 2
SELECT K.kitapAd, Y.yazarAd, Y.yazarSoyad
FROM KITAP K
JOIN YAZAR Y ON K.yazarNo = Y.yazarNo;

-- QUERY 3
SELECT O.ogrAd, O.ogrSoyad, K.kitapAd, K.puan AS kitapPuan, T.turAdi
FROM OGRENCI O
JOIN ISLEM I ON O.ogrNo = I.ogrNo
JOIN KITAP K ON I.kitapNo = K.kitapNo
JOIN TUR T ON K.turNo = T.turNo;

-- QUERY 4
SELECT O.ogrAd, O.ogrSoyad, K.kitapAd, MAX(I.aTarih) AS sonAldigiTarih
FROM OGRENCI O
JOIN ISLEM I ON O.ogrNo = I.ogrNo
JOIN KITAP K ON I.kitapNo = K.kitapNo
GROUP BY O.ogrAd, O.ogrSoyad, K.kitapAd;

-- QUERY 5
SELECT O.ogrAd, O.ogrSoyad, AVG(K.puan) AS ortalamaPuan
FROM OGRENCI O
JOIN ISLEM I ON O.ogrNo = I.ogrNo
JOIN KITAP K ON I.kitapNo = K.kitapNo
GROUP BY O.ogrAd, O.ogrSoyad;

-- QUERY 6
SELECT T.turAdi, K.kitapAd, K.puan
FROM KITAP K
JOIN TUR T ON K.turNo = T.turNo
ORDER BY T.turAdi;

-- QUERY 7
SELECT O.ogrAd, O.ogrSoyad, T.turAdi, COUNT(I.islemNo) AS kitapSayisi
FROM OGRENCI O
JOIN ISLEM I ON O.ogrNo = I.ogrNo
JOIN KITAP K ON I.kitapNo = K.kitapNo
JOIN TUR T ON K.turNo = T.turNo
GROUP BY O.ogrAd, O.ogrSoyad, T.turAdi
ORDER BY kitapSayisi DESC;

-- QUERY 8
SELECT O.ogrAd, O.ogrSoyad, K.kitapAd, K.sayfaSayisi, K.puan
FROM OGRENCI O
JOIN ISLEM I ON O.ogrNo = I.ogrNo
JOIN KITAP K ON I.kitapNo = K.kitapNo;

-- QUERY 9
SELECT O.ogrAd, O.ogrSoyad, K.kitapAd, I.aTarih, T.turAdi
FROM OGRENCI O
JOIN ISLEM I ON O.ogrNo = I.ogrNo
JOIN KITAP K ON I.kitapNo = K.kitapNo
JOIN TUR T ON K.turNo = T.turNo;

-- QUERY 10
SELECT Y.yazarAd, Y.yazarSoyad, K.kitapAd, K.sayfaSayisi, K.puan
FROM KITAP K
JOIN YAZAR Y ON K.yazarNo = Y.yazarNo
ORDER BY Y.yazarAd;
