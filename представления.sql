--просмотр каталога
CREATE VIEW CandleCatalog AS
SELECT name, price, smell, photo
FROM Candle;
----------------------
SELECT * FROM CandleCatalog;

--просмотр информации о товарах
CREATE VIEW AllCandles AS
SELECT
    c.ID,
    c.name,
    c.price,
    c.type,
    c.smell,
    c.photo,
    c.quantity,
    s.date AS supply_date,
    p.name AS provider_name
FROM
    Candle c
    INNER JOIN Supply s ON c.supply = s.number_of_supply
    INNER JOIN Provider p ON s.provider_id = p.ID;
-------------------------------
SELECT * FROM AllCandles;

--просмотр заказов пользователей
CREATE VIEW UserOrders AS
SELECT
    o.number AS order_number,
    u.login AS user_login,
    u.name AS user_name,
    u.surname AS user_surname,
    a.country AS delivery_country,
    a.city AS delivery_city,
    a.adress AS delivery_address,
    o.date AS order_date
FROM
    Orders o
    INNER JOIN Users u ON o.login_user = u.login
    INNER JOIN Address a ON o.adress = a.ID;
---------------------------
SELECT * FROM UserOrders;

--просмотр поставок товаров
CREATE VIEW SupplyDetails AS
SELECT
    s.number_of_supply AS supply_id,
    s.date AS supply_date,
    s.quantity_of_products AS total_products,
    p.name AS provider_name,
    b.name AS boss_name,
    b.surname AS boss_surname,
    b.email AS boss_email,
    b.phone_number AS boss_phone
FROM
    Supply s
    INNER JOIN Provider p ON s.provider_id = p.ID
    INNER JOIN Boss b ON p.boss_id = b.ID;
------------------------
SELECT * FROM SupplyDetails;

--информация о поставщиках и их начальниках
CREATE VIEW ProviderAndBossInfo
AS
SELECT 
    p.ID AS ProviderID,
    p.name AS ProviderName,
    p.country AS ProviderCountry,
    p.city AS ProviderCity,
    b.name AS BossName,
    b.surname AS BossSurname,
    b.email AS BossEmail,
    b.phone_number AS BossPhoneNumber
FROM 
    Provider p
INNER JOIN 
    Boss b ON p.boss_id = b.ID;
-------------------
SELECT * FROM ProviderAndBossInfo;

