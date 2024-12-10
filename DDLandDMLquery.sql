CREATE TABLE TblCalisanlar
(
CalisanID CHAR(5),
Isim NVARCHAR(50),
Soyisim NVARCHAR(50),
Telefon NVARCHAR(11),
Adres NVARCHAR(MAX),
Notlar NVARCHAR(MAX),
dTarih DATE,
ProgDili NVARCHAR(100)
)
GO
CREATE TABLE TblDenetmen
(
CalisanID CHAR(5),
Isim NVARCHAR(50),
Soyisim NVARCHAR(50),
Telefon NVARCHAR(11),
)

ALTER PROC SP_CalisanEkle
(
@CalisanID CHAR(5),
@Isim NVARCHAR(50),
@Soyisim NVARCHAR(50),
@Telefon NVARCHAR(11),
@Adres NVARCHAR(MAX),
@Notlar NVARCHAR(MAX),
@dTarih DATE,
@ProgDili NVARCHAR(100)
)
WITH ENCRYPTION
AS
IF EXISTS (SELECT * FROM TblCalisanlar WHERE CalisanID=@CalisanID)
	BEGIN
		PRINT 'SÝSTEMDE BU ID NUMARASI TANIMLI'
	END
ELSE
	BEGIN
		IF(30<=DATEPART(YYYY,GETDATE())-DATEPART(YYYY,@dTarih))
			BEGIN
				INSERT INTO TblCalisanlar(CalisanID,Isim,Soyisim,Telefon,Adres,Notlar,dTarih,ProgDili) VALUES
				(@CalisanID,@Isim,@Soyisim,@Telefon,@Adres,@Notlar,@dTarih,@ProgDili)
				INSERT INTO TblDenetmen(CalisanID,Isim,Soyisim,Telefon) VALUES
				(@CalisanID,@Isim,@Soyisim,@Telefon)
			END
		ELSE
		BEGIN
			INSERT INTO TblCalisanlar(CalisanID,Isim,Soyisim,Telefon,Adres,Notlar,dTarih,ProgDili) VALUES
					(@CalisanID,@Isim,@Soyisim,@Telefon,@Adres,@Notlar,@dTarih,@ProgDili)
		END
	END

EXEC SP_CalisanEkle 'AY25','ABDÜLSAMET','YILMAZ','05419070438','HAKLALI KÜÇÜKÇEKMECE / ÝSTANBUL','ÇALIÞKAN , ÖZVERÝLÝ',
'1998-12-17','C# , C VE JAVA'
EXEC SP_CalisanEkle 'DV05','DENÝZ','VURUCU','05425870438','ÞÝRÝNEVLER BAHÇELÝEVLER / ÝSTANBUL','ÖZVERÝLÝ',
'1992-10-11','JAVA'

SELECT * FROM TblCalisanlar
SELECT * FROM TblDenetmen
--DELETE TblCalisanlar
--DELETE TblDenetmen


