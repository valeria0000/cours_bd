---функция поиска по типу продукта---
CREATE FUNCTION GetCandlesByType
(
    @type NVARCHAR(MAX)
)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM Candle
    WHERE type = @type
);
----
SELECT * FROM GetCandlesByType('candle');
----------------------------------------

---функция поиска по запаху---
CREATE FUNCTION GetCandlesBySmell
(
    @Smell nvarchar(MAX)
)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM Candle
    WHERE smell = @Smell
);
-----
SELECT * FROM dbo.GetCandlesBySmell('rose');
---------------------------------------

--поиск по названию
CREATE FUNCTION FindCandleByName
(
    @name NVARCHAR(MAX)
)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM Candle
    WHERE name LIKE '%' + @name + '%'
);
-------------------
SELECT * FROM FindCandleByName('nil');

--поиск заказа по юзеру
CREATE FUNCTION GetOrdersByUser 
(
    @login_user VARCHAR(50)
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        o.number,
        o.adress,
        a.country,
        a.city,
        a.adress AS address_details,
        o.products,
        c.name AS product_name,
        o.login_user,
        o.date
    FROM 
        Orders o
    JOIN 
        Address a ON o.adress = a.ID
    JOIN 
        Candle c ON o.products = c.ID
    WHERE 
        o.login_user = @login_user
);
GO
---------------------------
SELECT * FROM GetOrdersByUser('rr.valeri');

---функция подсчета общей стоимости в корзине
CREATE FUNCTION CalculateTotalCost()
RETURNS INT
AS
BEGIN
    DECLARE @totalCost INT;

    SELECT @totalCost = SUM(sp.quantity_of_candles * c.price)
    FROM Select_products sp
    JOIN Candle c ON sp.id_of_candles = c.ID;

    RETURN @totalCost;
END;
--------------------------
SELECT dbo.CalculateTotalCost() AS TotalCost;

--поиск товаров по дню поставки
CREATE FUNCTION GetProductsDeliveredOnDate
(
    @deliveryDate DATE
)
RETURNS TABLE
AS
RETURN
(
    SELECT c.name AS ProductName, s.date AS DeliveryDate
    FROM Candle c
    INNER JOIN Supply s ON c.supply = s.number_of_supply
    WHERE s.date = @deliveryDate
);
----------------------------
SELECT * FROM dbo.GetProductsDeliveredOnDate('2024-04-04');
SELECT * FROM Supply

--поиск товаров по поставщику
CREATE FUNCTION GetProductsByProvider
(
    @providerID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT c.name AS ProductName
    FROM Candle c
    INNER JOIN Supply s ON c.supply = s.number_of_supply
    WHERE s.provider_id = @providerID
);
-------------------------
SELECT * FROM dbo.GetProductsByProvider(1);
