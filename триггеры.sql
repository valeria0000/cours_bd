--������� ��� �������� ���������� �������
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
        PRINT '������: ������������� ���������� ������� �� ������.';
    END
    ELSE
    BEGIN
        INSERT INTO Select_products (id_of_candles, quantity_of_candles, login_user)
        SELECT id_of_candles, quantity_of_candles, login_user
        FROM inserted;
        PRINT '����� ������� �������� � �������.';
    END
END;
GO

------------------------------------
EXEC ADD_TO_CART 'papita', 3, 10000;
select * from Select_products
------------------------------------
--������� �� ���������� ������
CREATE TRIGGER AfterOrderInsert
ON Orders
AFTER INSERT
AS
BEGIN
    DECLARE @OrderID INT;
    DECLARE @UserName NVARCHAR(255);

    -- ��������� ���������� � ����� ������
    SELECT TOP 1 
        @OrderID = inserted.number, 
        @UserName = u.name
    FROM inserted
    JOIN Users u ON inserted.login_user = u.login;

    -- ����� ��������� �� �������� ���������� ������
    PRINT '����� �' + CAST(@OrderID AS NVARCHAR(10)) + ' ��� ������������ ' + @UserName + ' ������� ��������.';
END;
GO
-----------------------------
---������� �� ������� �������
CREATE TRIGGER Trigger_ClearCart_EmptyTable
ON Select_products
INSTEAD OF DELETE
AS
BEGIN
    IF NOT EXISTS (SELECT TOP 1 1 FROM Select_products)
    BEGIN
        PRINT '������� ������� ��� �����.';
    END
    ELSE
    BEGIN
        DELETE FROM Select_products;
        PRINT '������� ������� �������.';
    END
END;

--������� �� ���������� �������� �������
CREATE TRIGGER PreventDuplicateCandle
ON Candle
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Candle c INNER JOIN inserted i ON c.name = i.name)
    BEGIN
        PRINT '������: ����� � ����� ��������� ��� ���������� � ��������.';
    END
    ELSE
    BEGIN
        INSERT INTO Candle (name, price, type, smell, photo, quantity, supply)
        SELECT name, price, type, smell, photo, quantity, supply
        FROM inserted;
    END
END;
---------

--������� �� �������� ������ �� ��������
CREATE TRIGGER DeleteCandleTrigger
ON Candle
AFTER DELETE
AS
BEGIN
    DECLARE @DeletedCandleID INT;
    SELECT @DeletedCandleID = deleted.ID FROM deleted;

    IF NOT EXISTS (SELECT * FROM Candle WHERE ID = @DeletedCandleID)
    BEGIN
        PRINT '����� ������� ������ �� ��������.';
    END
END;

---������� �� ���������� ���������� � ������������
CREATE TRIGGER trg_CheckDuplicateLogin
ON Users
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @login VARCHAR(50);
    
    -- �������� ����� �� ����������� ������
    SELECT @login = login FROM inserted;

    -- �������� �� ������������� ������������ � ����� �� �������
    IF EXISTS (SELECT 1 FROM Users WHERE login = @login)
    BEGIN
        -- ����� ��������� �� ������, ���� ����� ��� ����������
        RAISERROR('������������ � ����� ������� ��� ����������', 16, 1);
    END
    ELSE
    BEGIN
        -- ���� ����� ��������, ������� ������ � ������� Users
        INSERT INTO Users (login, name, surname, email, phone_number, sex)
        SELECT login, name, surname, email, phone_number, sex FROM inserted;

        -- ����� ��������� �� �������� ���������� ������������
        PRINT '���������� ������� ���������!';
    END
END;
GO
-------------------------

--������� �� ���������� ������ 
drop TRIGGER OrderSuccessTrigger
ON Orders
AFTER INSERT
AS
BEGIN
    DECLARE @OrderID INT;
    DECLARE @UserName NVARCHAR(255);

    -- ��������� ���������� � ����� ������
    SELECT @OrderID = inserted.number, @UserName = users.name
    FROM inserted
    JOIN Users ON inserted.login_user = Users.login;

    -- ����� ��������� �� �������� ���������� ������
    PRINT '����� �' + CAST(@OrderID AS NVARCHAR(10)) + ' ��� ������������ ' + @UserName + ' ������� ��������.';
END;
GO

--�� ���� �����
CREATE OR ALTER TRIGGER UserDeletedTrigger
ON Users
AFTER DELETE
AS
BEGIN
    DECLARE @deletedLogin VARCHAR(50);
    SELECT @deletedLogin = login FROM deleted;
    PRINT '������������ � ������� ' + @deletedLogin + ' ������� ������.';
END;
GO