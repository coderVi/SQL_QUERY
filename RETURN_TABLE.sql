USE Northwind

--CREATE FUNCTION FN_ORNEK
--(
----PARAMETRELER
--)

--RETURNS TABLE
--AS
--RETURN
--(
----ÝÞLEVLER
--)

CREATE FUNCTION FN_INFO_PRODUCTS
(
@ID NCHAR(5)
)
RETURNS TABLE
AS
RETURN(SELECT P.ProductName,P.UnitPrice,P.UnitsInStock FROM Customers C 
JOIN Orders O
ON C.CustomerID = O.CustomerID
JOIN [Order Details] OD
ON OD.OrderID = O.OrderID
JOIN Products P
ON P.ProductID = OD.ProductID
WHERE C.CustomerID = @ID
)

SELECT UnitPrice,dbo.FN_FiyatArttýrma(UnitPrice) FROM FN_INFO_PRODUCTS('ANTON')

ALTER FUNCTION FN_ProductOfEmployee
(
@ilkYil INT,
@ID INT
)
RETURNS TABLE
AS
RETURN
(
SELECT E.FirstName,E.LastName,P.ProductName,P.UnitPrice,P.UnitsInStock FROM Employees E
JOIN Orders O
ON
O.EmployeeID = E.EmployeeID
JOIN [Order Details] OD
ON
OD.OrderID = O.OrderID
JOIN Products P
ON P.ProductID = OD.ProductID WHERE E.EmployeeID = @ID AND YEAR(OrderDate) = @ilkYil
--ORDERDETAÝLS --PRODUCTS
)
SELECT * FROM dbo.FN_ProductOfEmployee(2,1995)
SELECT * FROM Orders


--ÇOK DEYÝMLÝ TABLO DÖNDÜREN TABLO

CREATE FUNCTION FN_COK_DEYILMLI
(
@UrunID INT
)
RETURNS @PRODUCTS_OF_CUSTOMER TABLE
(
ID INT,
PRODUCTNAME NVARCHAR(40),
UNITPRICE MONEY
)
AS
BEGIN

	IF @UrunID < 0
		BEGIN
			INSERT INTO @PRODUCTS_OF_CUSTOMER(ID,PRODUCTNAME,UNITPRICE)
			SELECT ProductID,ProductName,UnitPrice FROM Products
		END
	ELSE IF @UrunID > 0
		BEGIN
			INSERT INTO @PRODUCTS_OF_CUSTOMER(ID,PRODUCTNAME,UNITPRICE)
			SELECT ProductID,ProductName,UnitPrice FROM Products WHERE ProductID = @UrunID
		END
	ELSE
		BEGIN
			INSERT INTO @PRODUCTS_OF_CUSTOMER (ID,PRODUCTNAME,UNITPRICE)
			VALUES (0,'TEST ÜRÜN',15)
		END
RETURN
END

SELECT * FROM dbo.FN_COK_DEYILMLI(0)

--VÝEW

CREATE VIEW VW_GET_CUSTORMER_ORDERS(MusteriID,SiparisSayisi)
AS
SELECT C.CustomerID , COUNT(O.OrderID)FROM Customers C
JOIN Orders O
ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID

SELECT * FROM dbo.VW_GET_CUSTORMER_ORDERS
ORDER BY SiparisSayisi DESC

CREATE VIEW VW_WITH_ENCR
WITH ENCRYPTION
AS
SELECT P.ProductID,P.ProductName,P.UnitPrice,C.CategoryName FROM Products P ,Categories C
WHERE C.CategoryID=P.CategoryID
AND C.CategoryName='Beverages'


CREATE VIEW VW_SHIPPER_SPEEDY_EMPNANCY
AS
SELECT O.OrderID,O.OrderDate,C.CompanyName 'CUSTOMER COMPANY NAME', S.CompanyName 'SHIPPER COMPANY NAME',E.FirstName,E.LastName FROM Orders O
JOIN Shippers S
ON S.ShipperID = O.ShipVia
JOIN Employees E
ON E.EmployeeID = O.EmployeeID
JOIN Customers C
ON C.CustomerID = O.CustomerID
WHERE E.FirstName='NANCY' AND S.CompanyName='SPEEDY EXPRESS' AND C.CustomerID IN ('DUMON','ALFKI')

SELECT * FROM VW_SHIPPER_SPEEDY_EMPNANCY

--
CREATE VIEW VW_ORT_HESAP
AS
SELECT OD.OrderID, SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS TOPLAM FROM [Order Details] OD
GROUP BY OD.OrderID
HAVING SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount))>
(
SELECT AVG(T.SÝPARÝÞBAZLIPARA) FROM (SELECT OD.OrderID AS SÝPARÝÞID, SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS SÝPARÝÞBAZLIPARA FROM [Order Details] OD
GROUP BY OD.OrderID) AS T
)

SELECT * FROM VW_ORT_HESAP
ORDER BY 2 DESC

CREATE VIEW VW_EN_COK_SATAN
AS
SELECT TOP 1 P.ProductName,C.CategoryName,COUNT(OD.Quantity) AS 'ORDER COUNT' FROM Products P
JOIN Categories C
ON P.CategoryID = C.CategoryID
JOIN [Order Details] OD
ON OD.ProductID = P.ProductID
JOIN Orders O
ON O.OrderID = OD.OrderID
GROUP BY P.ProductName,C.CategoryName
ORDER BY 3 DESC

SELECT * FROM VW_EN_COK_SATAN