CREATE DATABASE QuanLyQuanCafe
GO

USE QuanLyQuanCafe
GO

-- Food
-- Table
-- FoodCategory
-- Account
-- Bill
-- BillInfo

CREATE TABLE TableFood
(
	id INT IDENTITY PRIMARY KEY,
	name NVARCHAR(100) NOT NULL DEFAULT N'Ban chua co ten',
	status NVARCHAR(100) NOT NULL DEFAULT N'Trong'   -- Trong || Co nguoi
)
GO

CREATE TABLE Account
(
	DisplayName NVARCHAR(100) NOT NULL DEFAULT N'Than',
	UserName NVARCHAR(100) NOT NULL PRIMARY KEY,
	PassWord NVARCHAR(1000) NOT NULL DEFAULT 0,
	Type INT NOT NULL DEFAULT 0 -- 1: admin && 0: staff
)
GO

CREATE TABLE FoodCategory
(
	id INT IDENTITY PRIMARY KEY,
	name NVARCHAR(100) DEFAULT N'Chua dat ten'
)
GO

CREATE TABLE Food
(
	id INT IDENTITY PRIMARY KEY,
	name NVARCHAR(100) NOT NULL DEFAULT N'Chua dat ten',
	idCategory INT NOT NULL,
	price FLOAT NOT NULL DEFAULT 0

	FOREIGN KEY (idCategory) REFERENCES dbo.FoodCategory(id)
)
GO

CREATE TABLE Bill
(
	id INT IDENTITY PRIMARY KEY,
	DateCheckIN DATE NOT NULL DEFAULT GETDATE(),
	DateCheckOut DATE,
	idTable INT NOT NULL,
	status INT NOT NULL  -- 1: da thanh toan && 0: chua thanh toan

	FOREIGN KEY (idTable) REFERENCES dbo.TableFood(id)
)
GO

CREATE TABLE BillInfo
(
	id INT IDENTITY PRIMARY KEY,
	idBill INT NOT NULL,
	idFood INT NOT NULL,
	count INT NOT NULL DEFAULT 0

	FOREIGN KEY (idBill) REFERENCES dbo.Bill(id),
	FOREIGN KEY (idFood) REFERENCES dbo.Food(id)
)
GO

INSERT INTO dbo.Account
( UserName,
  DisplayName,
  PassWord,
  Type
 )
VALUES ( N'K9' ,--UserName - nvarchar(100)
		 N'RongK9' ,--DisplayName - nvarchar(100)
		 N'1' ,--PassWord - nvarchar(1000)
		 1  -- Type - int
		)
INSERT INTO dbo.Account
( UserName,
  DisplayName,
  PassWord,
  Type
 )
VALUES ( N'staff' ,--UserName - nvarchar(100)
		 N'staff' ,--DisplayName - nvarchar(100)
		 N'1' ,--PassWord - nvarchar(1000)
		 0  -- Type - int
		)
GO

CREATE PROC USP_GetAccountByUserName
@userName nvarchar(100)
AS
BEGIN
	SELECT * FROM dbo.Account WHERE UserName = @userName
END
GO

EXEC dbo.USP_GetAccountByUserName @userName = N'K9' -- nvarchar(100)

GO
CREATE PROC USP_Login
@userName nvarchar(100), @passWord nvarchar(100)
AS
BEGIN
	SELECT * FROM dbo.Account WHERE UserName = @userName AND PassWord = @passWord
END
GO 


--Thêm bàn 
DECLARE @i INT = 0

WHILE @i <= 10
BEGIN
	INSERT dbo.TableFood ( name)VALUES	( N'Bàn số ' + CAST(@i AS nvarchar(100)))
	SET @i = @i + 1
END

GO


CREATE PROC USP_GetTableList
AS SELECT * FROM dbo.TableFood
GO

UPDATE dbo.TableFood SET STATUS = N'Có người' WHERE id = 9

EXEC dbo.USP_GetTableList
GO

--Thêm Category 
INSERT dbo.FoodCategory
		( name )
VALUES  ( N'Hải sản'   -- name  - nvarchar(100)
          )
INSERT dbo.FoodCategory
		( name )
VALUES  ( N'Nông sản'   -- name  - nvarchar(100)
          )
INSERT dbo.FoodCategory
		( name )
VALUES  ( N'Nước'   -- name  - nvarchar(100)
          )

-- thêm món ăn 
INSERT dbo.Food
		( name, idCategory, price)
VALUES  ( N'Mực một nắng nướng',  -- name - nvarchar(100)
		  1,  -- idCategory - int
		  120000 )
INSERT dbo.Food
		( name, idCategory, price)
VALUES  ( N'Nghêu hấp xả', 1, 50000 )
INSERT dbo.Food
		( name, idCategory, price)
VALUES  ( N'Dú dê nướng sữa', 2, 70000 )
INSERT dbo.Food
		( name, idCategory, price)
VALUES  ( N'Trà sữa trân châu', 3, 25000 )
INSERT dbo.Food
		( name, idCategory, price)
VALUES  ( N'Cafe', 3, 10000 )
INSERT dbo.Food
		( name, idCategory, price)
VALUES  ( N'Trà chanh', 3, 10000 )

-- Thêm Bill 
INSERT dbo.Bill
		( DateCheckIN,
		  DateCheckOut,
		  idTable,
		  status
		  )
VALUES   ( GETDATE()  , -- DateCheckin - date
		   NULL  , -- DateCheckout - date
		   1 , -- idTable - int
		   0  -- status - int
		   )
INSERT dbo.Bill
		( DateCheckIN,
		  DateCheckOut,
		  idTable,
		  status
		  )
VALUES   ( GETDATE()  , -- DateCheckin - date
		   NULL  , -- DateCheckout - date
		   2 , -- idTable - int
		   0  -- status - int
		   )
INSERT dbo.Bill
		( DateCheckIN,
		  DateCheckOut,
		  idTable,
		  status
		  )
VALUES   ( GETDATE()  , -- DateCheckin - date
		   GETDATE()  , -- DateCheckout - date
		   2 , -- idTable - int
		   1  -- status - int
		   )

-- thêm bill info
INSERT dbo.BillInfo
		(idBill, idFood, count )
VALUES  ( 1,  -- idBill - int
		  1,  -- idFood - int
		  2   -- count - int
		  )
INSERT dbo.BillInfo
		(idBill, idFood, count )
VALUES  ( 1,  -- idBill - int
		  3,  -- idFood - int
		  4   -- count - int
		  )
INSERT dbo.BillInfo
		(idBill, idFood, count )
VALUES  ( 1,  -- idBill - int
		  5,  -- idFood - int
		  1   -- count - int
		  )
INSERT dbo.BillInfo
		(idBill, idFood, count )
VALUES  ( 2,  -- idBill - int
		  1,  -- idFood - int
		  2   -- count - int
		  )
INSERT dbo.BillInfo
		(idBill, idFood, count )
VALUES  ( 2,  -- idBill - int
		  6,  -- idFood - int
		  2   -- count - int
		  )
INSERT dbo.BillInfo
		(idBill, idFood, count )
VALUES  ( 3,  -- idBill - int
		  5,  -- idFood - int
		  2   -- count - int
		  )

GO

SELECT f.name, bi.count, f.price, f.price*bi.count AS totalPrice FROM dbo.BillInfo AS bi,  dbo.Bill AS b, dbo.Food AS f
WHERE bi.idBill = b.id AND bi.idFood = f.id AND b.idTable = 2


SELECT * FROM dbo.Bill
SELECT * FROM dbo.BillInfo
SELECT * FROM dbo.Food
SELECT * FROM dbo.FoodCategory
