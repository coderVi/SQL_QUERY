-- T SQL 
--Deðiþkenler

DECLARE @Sayi INT = 15;
PRINT 'Atanan Deðer'
PRINT @Sayi
PRINT 'Atanan Yeni Deðer'
SET @Sayi = 5; --TEK BÝR DEÐERE DEÐER ATAMASI
PRINT @Sayi

DECLARE @Ad NVARCHAR(50),@Yas TINYINT;
SELECT @Ad = 'Ali', @Yas =25; -- BÝRDEN FAZLA DEÐERE DEÐER ATAMA
PRINT @Ad + ' ' +CONVERT(NVARCHAR(2), @Yas)

DECLARE @Tarih DATE;
SET @Tarih = '2024-12-05'
PRINT @Tarih

DECLARE @Price MONEY
SET @Price = 12.2;
PRINT @Price

DECLARE @Description NVARCHAR(MAX)
SET @Description = 'LOREM ÝPSUM BLA BLA BLA'
PRINT @Description

USE Northwind
DECLARE @Category INT
SET @Category = (SELECT COUNT(*) FROM Categories)
SELECT @Category AS KATEGORÝLER


--IF ELSE
--IF(KOSUL)
--BEGIN
--END
DECLARE @Sayi1 INT
SET @Sayi1 = (SELECT COUNT(*) FROM Products)
IF @Sayi1>5000
BEGIN
	PRINT '5000 DEN FAZLA ÜRÜN VAR'
END

ELSE
BEGIN
	PRINT '5000 DEN AZ ÜRÜN'
END

--EXISTS (VAR MI) NOT EXISTS (YOK MU)

IF EXISTS (SELECT * FROM sys.tables WHERE NAME = 'Products')
BEGIN
	PRINT 'Evet'
END

ELSE
BEGIN
	PRINT'Hayýr'
END

--LOOPS
--BREAK
--CONTIUNE

DECLARE @Sayac INT
SET @Sayac = 0

WHILE(@Sayac<=10)
BEGIN
	PRINT @Sayac
	SET @Sayac+=1
END



while(select AVG(UnitPrice) from Products) < 50
	update Products set UnitPrice = UnitPrice * 2
	if(select max(UnitPrice) from Products) > 50
		BEGIN
			break
		END
	else
		BEGIN
			CONTINUE 
		END

--STORED PROCEDURE
CREATE PROC SP_AriBilgiMAXUrunleriGoster
AS
BEGIN
	SELECT TOP 6 P.ProductName , SUM(OD.Quantity) FROM [Order Details] OD
	JOIN Products P
	ON
	OD.ProductID = P.ProductID
	GROUP BY P.ProductName
	ORDER BY 2 DESC
END
ALTER PROC SP_AriBilgiMAXUrunleriGoster
AS
BEGIN
	SELECT TOP 3 P.ProductName , SUM(OD.Quantity) FROM [Order Details] OD
	JOIN Products P
	ON
	OD.ProductID = P.ProductID
	GROUP BY P.ProductName
	ORDER BY 2 DESC
END

EXEC SP_AriBilgiMAXUrunleriGoster


--PARAMETRELÝ SP
CREATE PROCEDURE ISIM
(@Prm1 NVARCHAR(30),@Prm2 INT)
AS
BEGIN
-- TO DO
END
EXECUTE ISIM 'ALÝ','25'

CREATE PROC SP_KargoEKLE
(@name NVARCHAR(30))
AS
BEGIN
	INSERT INTO Shippers(CompanyName) VALUES (@name)
END

EXEC SP_KargoEKLE 'MNG KARGO'

SELECT * FROM Shippers

ALTER PROC SP_KargoEKLE
(@name NVARCHAR(30),@tlf NVARCHAR(20))
AS
BEGIN
	INSERT INTO Shippers(CompanyName , Phone) VALUES (@name , @tlf)
END

EXEC SP_KargoEKLE 'Yurtiçi Kargo' , '02122125151'

SELECT * FROM Products



CREATE PROC SP_FiyatMan
(@prmt1 NVARCHAR(7),@prtm2 INT,@prmt3 INT)
AS
BEGIN
IF @prmt1='ZAM'
	BEGIN
	UPDATE Products SET UnitPrice += @prtm2 WHERE ProductID = @prmt3
	END
ELSE IF @prmt1='ÝNDÝRÝM'
	BEGIN
	UPDATE Products SET UnitPrice -= @prtm2 WHERE ProductID = @prmt3
	END
END

SELECT * FROM Orders
SELECT * FROM Shippers

CREATE PROC SP_KargoUcret
(
    @ad NVARCHAR(30),
    @min INT,
    @max INT
)
AS
BEGIN
    SELECT O.OrderID, S.CompanyName
    FROM Orders O
    JOIN Shippers S
        ON O.ShipVia = S.ShipperID
    WHERE S.CompanyName LIKE N'%' + @ad + N'%' -- NVARCHAR olarak belirtiliyor
      AND O.Freight BETWEEN @min AND @max
    GROUP BY S.CompanyName, O.OrderID;
END;


EXEC SP_KargoUcret 'FED',10,100

DROP PROC SP_KargoUcret

SELECT * FROM Products
SELECT * FROM Suppliers
SELECT * FROM [Order Details]

CREATE PROC SP_StokFiyatKdv
(@minDeger INT, @maxDeger INT, @urunMinUcret INT, @urunMaxUcret INT, @urunAdi NVARCHAR(1), @kdv FLOAT)
AS
BEGIN
	SELECT P.ProductName, P.UnitPrice,(P.UnitPrice+(P.UnitPrice*@kdv)) FROM Products P
	JOIN Suppliers S
	ON P.SupplierID = S.SupplierID
	WHERE P.UnitsInStock BETWEEN @minDeger AND @maxDeger
	AND
	P.UnitPrice BETWEEN @urunMinUcret AND @urunMaxUcret
	AND
	S.CompanyName LIKE N'%'+@urunAdi+N'%'
END

EXEC SP_StokFiyatKdv 5,30,10,100,'c',0.18