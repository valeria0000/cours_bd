-- Создание процедуры для оформления заказа
CREATE PROCEDURE ADD_ORDER 
    @login_user VARCHAR(50),
    @address_id INT,
    @order_date DATE
AS
BEGIN
    DECLARE @id_of_candles INT;
    DECLARE @quantity_of_candles INT;

    DECLARE cart_cursor CURSOR FOR 
    SELECT id_of_candles, quantity_of_candles
    FROM Select_products
    WHERE login_user = @login_user;

    OPEN cart_cursor;
    FETCH NEXT FROM cart_cursor INTO @id_of_candles, @quantity_of_candles;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Вставка записи в таблицу Orders
        INSERT INTO Orders (adress, products, login_user, date)
        VALUES (@address_id, @id_of_candles, @login_user, @order_date);

        FETCH NEXT FROM cart_cursor INTO @id_of_candles, @quantity_of_candles;
    END;

    CLOSE cart_cursor;
    DEALLOCATE cart_cursor;

    -- Очистка корзины после оформления заказа
    DELETE FROM Select_products WHERE login_user = @login_user;
END;
GO
-- Пример вызова процедуры
EXEC ADD_ORDER 'rr.valeri', 1, '2024-05-18';
EXEC ADD_ORDER 'papita', 1, '2024-05-18';

select * from Orders;
select * from Select_products;
select * from Users;

drop PROCEDURE ADD_ORDER 
---------------------------------------------
-- Процедура для добавления товаров в корзину
CREATE PROCEDURE ADD_TO_CART 
    @login_user VARCHAR(50),
    @id_of_candles INT,
    @quantity_of_candles INT
AS
BEGIN
    INSERT INTO Select_products (id_of_candles, quantity_of_candles, login_user)
    VALUES (@id_of_candles, @quantity_of_candles, @login_user);
END;
GO

-- 
EXEC ADD_TO_CART 'rr.valeri', 1, 3;
EXEC ADD_TO_CART 'rr.valeri', 2, 2;
EXEC ADD_TO_CART 'papita', 3, 2;

select * from Select_products;
select * from Candle
select * from Users

----изм товаров--
CREATE PROCEDURE UpdateCandle
    @CandleID INT,
    @Name NVARCHAR(255),
    @Price INT,
    @Type NVARCHAR(255),
    @Smell NVARCHAR(255),
    @Photo NVARCHAR(255),
    @Quantity INT,
    @SupplyID INT
AS
BEGIN
    UPDATE Candle
    SET 
        name = @Name,
        price = @Price,
        type = @Type,
        smell = @Smell,
        photo = @Photo,
        quantity = @Quantity,
        supply = @SupplyID
    WHERE
        ID = @CandleID;
END;
-------------------------------
EXEC UpdateCandle 
    @CandleID = 4,
    @Name = 'Lavender Incense',
    @Price = 150,
    @Type = 'Incense',
    @Smell = 'Lavender',
    @Photo = 'lavender.jpg',
    @Quantity = 100,
    @SupplyID = 2;

select * from Candle
---------------------------
--очистка корзины---
CREATE PROCEDURE ClearCart
    @login_user VARCHAR(50)
AS
BEGIN
    DELETE FROM Select_products WHERE login_user = @login_user;
END;
---------------------
EXEC ClearCart 'papita';
select * from Select_products
---------------------
---Добавление товара в каталог 
CREATE PROCEDURE AddCandle
    @name NVARCHAR(255),
    @price INT,
    @type NVARCHAR(255),
    @smell NVARCHAR(255),
    @photo NVARCHAR(255),
    @quantity INT,
    @supply INT
AS
BEGIN
    INSERT INTO Candle (name, price, type, smell, photo, quantity, supply)
    VALUES (@name, @price, @type, @smell, @photo, @quantity, @supply);
END;

------
EXEC AddCandle 'Orange Candle', 25, 'Candle', 'Orange', 'Orange_candle.jpg', 100, 1;
select * from Candle;
-----------------------------

--удаление товара из каталога 
CREATE PROCEDURE DeleteCandle
    @candleID INT
AS
BEGIN
    DELETE FROM Candle WHERE ID = @candleID;
END;
--------------
EXEC DeleteCandle @candleID = 35;
-------------

---процедура управления поставками---
CREATE PROCEDURE AddSupply
    @date DATE,
    @quantity_of_products INT,
    @provider_id INT
AS
BEGIN
    INSERT INTO Supply (date, quantity_of_products, provider_id)
    VALUES (@date, @quantity_of_products, @provider_id);
END;
----
EXEC AddSupply @date = '2024-04-30', @quantity_of_products = 100, @provider_id = 2;
--------------------------

---процедура управления поставщиками
CREATE PROCEDURE ManageProvider
    @Action VARCHAR(10), -- Возможные значения: 'INSERT', 'UPDATE', 'DELETE'
    @ProviderID INT, -- ID поставщика
    @Name NVARCHAR(MAX), -- Новое имя поставщика (для INSERT и UPDATE)
    @Country NVARCHAR(MAX), -- Новая страна (для INSERT и UPDATE)
    @City NVARCHAR(MAX), -- Новый город (для INSERT и UPDATE)
    @BossID INT -- ID босса (для INSERT и UPDATE)
AS
BEGIN
    IF @Action = 'INSERT'
    BEGIN
        INSERT INTO Provider (name, country, city, boss_id)
        VALUES (@Name, @Country, @City, @BossID);
    END
    ELSE IF @Action = 'UPDATE'
    BEGIN
        UPDATE Provider
        SET name = @Name, country = @Country, city = @City, boss_id = @BossID
        WHERE ID = @ProviderID;
    END
    ELSE IF @Action = 'DELETE'
    BEGIN
        DELETE FROM Provider
        WHERE ID = @ProviderID;
    END
END;
----
EXEC ManageProvider 'INSERT', NULL, 'Prov', 'Belarus', 'Lida', 2;
EXEC ManageProvider 'UPDATE', @ProviderID = 4, @Name = 'AAA', @Country = 'Poland', @City = 'Krakow', @BossID = 1;
EXEC ManageProvider 'DELETE', @ProviderID = 4;
-----

CREATE PROCEDURE AddUser
    @login VARCHAR(50),
    @name NVARCHAR(255),
    @surname NVARCHAR(255),
    @email VARCHAR(100),
    @phone_number VARCHAR(13),
    @sex NVARCHAR(3)
AS
BEGIN
    -- Вставка данных в таблицу Users
    INSERT INTO Users (login, name, surname, email, phone_number, sex)
    VALUES (@login, @name, @surname, @email, @phone_number, @sex);
END;
GO
----------------------
EXEC AddUser 
    @login = 'john_doe',
    @name = 'John',
    @surname = 'Doe',
    @email = 'john.doe@example.com',
    @phone_number = '1234567890',
    @sex = 'M';

select * from Users
----------------------

--удаление пользователя
CREATE OR ALTER PROCEDURE DeleteUserByLogin
    @login varchar(50)
AS
BEGIN
    DELETE FROM Users
    WHERE login = @login;
END;
GO
---------------
EXEC DeleteUserByLogin @login = 'john_doe';
select * from users
