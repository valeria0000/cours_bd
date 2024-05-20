--триггер для проверки количества товаров
CREATE TRIGGER CheckProductQuantity
ON Select_products
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @id_of_candles INT;
    DECLARE @quantity_of_candles INT;
    DECLARE @available_quantity INT;

    SELECT @id_of_candles = inserted.id_of_candles, 
           @quantity_of_candles = inserted.quantity_of_candles
    FROM inserted;

    SELECT @available_quantity = quantity
    FROM Candle
    WHERE ID = @id_of_candles;

    IF @quantity_of_candles > @available_quantity
    BEGIN
        PRINT 'Ошибка: Недостаточное количество товаров на складе.';
    END
    ELSE
    BEGIN
        INSERT INTO Select_products (id_of_candles, quantity_of_candles, login_user)
        SELECT id_of_candles, quantity_of_candles, login_user
        FROM inserted;
        PRINT 'Товар успешно добавлен в корзину.';
    END
END;
GO

------------------------------------
EXEC ADD_TO_CART 'papita', 3, 10000;
select * from Select_products
------------------------------------
--триггер на оформление заказа
CREATE TRIGGER AfterOrderInsert
ON Orders
AFTER INSERT
AS
BEGIN
    DECLARE @OrderID INT;
    DECLARE @UserName NVARCHAR(255);

    -- Получение информации о новом заказе
    SELECT TOP 1 
        @OrderID = inserted.number, 
        @UserName = u.name
    FROM inserted
    JOIN Users u ON inserted.login_user = u.login;

    -- Вывод сообщения об успешном оформлении заказа
    PRINT 'Заказ №' + CAST(@OrderID AS NVARCHAR(10)) + ' для пользователя ' + @UserName + ' успешно оформлен.';
END;
GO
-----------------------------
---триггер на очистку корзины
CREATE TRIGGER Trigger_ClearCart_EmptyTable
ON Select_products
INSTEAD OF DELETE
AS
BEGIN
    IF NOT EXISTS (SELECT TOP 1 1 FROM Select_products)
    BEGIN
        PRINT 'Таблица корзины уже пуста.';
    END
    ELSE
    BEGIN
        DELETE FROM Select_products;
        PRINT 'Корзина успешно очищена.';
    END
END;

--триггер на одинаковые названия товаров
CREATE TRIGGER PreventDuplicateCandle
ON Candle
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Candle c INNER JOIN inserted i ON c.name = i.name)
    BEGIN
        PRINT 'Ошибка: товар с таким названием уже существует в каталоге.';
    END
    ELSE
    BEGIN
        INSERT INTO Candle (name, price, type, smell, photo, quantity, supply)
        SELECT name, price, type, smell, photo, quantity, supply
        FROM inserted;
    END
END;
---------

--триггер на удаление товара из каталога
CREATE TRIGGER DeleteCandleTrigger
ON Candle
AFTER DELETE
AS
BEGIN
    DECLARE @DeletedCandleID INT;
    SELECT @DeletedCandleID = deleted.ID FROM deleted;

    IF NOT EXISTS (SELECT * FROM Candle WHERE ID = @DeletedCandleID)
    BEGIN
        PRINT 'Товар успешно удален из каталога.';
    END
END;

---триггер на добавление информации о пользователе
CREATE TRIGGER trg_CheckDuplicateLogin
ON Users
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @login VARCHAR(50);
    
    -- Получаем логин из вставляемых данных
    SELECT @login = login FROM inserted;

    -- Проверка на существование пользователя с таким же логином
    IF EXISTS (SELECT 1 FROM Users WHERE login = @login)
    BEGIN
        -- Вывод сообщения об ошибке, если логин уже существует
        RAISERROR('Пользователь с таким логином уже существует', 16, 1);
    END
    ELSE
    BEGIN
        -- Если логин уникален, вставка данных в таблицу Users
        INSERT INTO Users (login, name, surname, email, phone_number, sex)
        SELECT login, name, surname, email, phone_number, sex FROM inserted;

        -- Вывод сообщения об успешном добавлении пользователя
        PRINT 'Информация успешно добавлена!';
    END
END;
GO
-------------------------

--триггер на оформление заказа 
drop TRIGGER OrderSuccessTrigger
ON Orders
AFTER INSERT
AS
BEGIN
    DECLARE @OrderID INT;
    DECLARE @UserName NVARCHAR(255);

    -- Получение информации о новом заказе
    SELECT @OrderID = inserted.number, @UserName = users.name
    FROM inserted
    JOIN Users ON inserted.login_user = Users.login;

    -- Вывод сообщения об успешном оформлении заказа
    PRINT 'Заказ №' + CAST(@OrderID AS NVARCHAR(10)) + ' для пользователя ' + @UserName + ' успешно оформлен.';
END;
GO

--на удал польз
CREATE OR ALTER TRIGGER UserDeletedTrigger
ON Users
AFTER DELETE
AS
BEGIN
    DECLARE @deletedLogin VARCHAR(50);
    SELECT @deletedLogin = login FROM deleted;
    PRINT 'Пользователь с логином ' + @deletedLogin + ' успешно удален.';
END;
GO