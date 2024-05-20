CREATE PROCEDURE AnalyzeCandles
AS
BEGIN
  -- Топ-5 самых продаваемых свечей по количеству проданных
  DECLARE @name NVARCHAR(255), @price INT, @type NVARCHAR(255), @smell NVARCHAR(255), @total_sold INT;
  DECLARE top5_cursor CURSOR FOR
    SELECT TOP 5
      c.name, c.price, c.type, c.smell, SUM(sp.quantity_of_candles) AS total_sold
    FROM
      Candle c
    JOIN
      Select_products sp ON c.ID = sp.id_of_candles
    GROUP BY
      c.name, c.price, c.type, c.smell
    ORDER BY 
      total_sold DESC;

  OPEN top5_cursor;
  FETCH NEXT FROM top5_cursor INTO @name, @price, @type, @smell, @total_sold;

  PRINT 'Топ-5 самых продаваемых свечей по количеству проданных:';
  WHILE @@FETCH_STATUS = 0
  BEGIN
    PRINT @name + ' | Цена: ' + CAST(@price AS NVARCHAR(10)) + ' | Тип: ' + @type + ' | Запах: ' + @smell + ' | Продано: ' + CAST(@total_sold AS NVARCHAR(10));
    FETCH NEXT FROM top5_cursor INTO @name, @price, @type, @smell, @total_sold;
  END

  CLOSE top5_cursor;
  DEALLOCATE top5_cursor;

  -- Количество поставок по месяцам
  DECLARE @month INT, @num_supplies INT;
  DECLARE supplies_cursor CURSOR FOR
    SELECT
      MONTH(s.date) AS month, 
      COUNT(*) AS num_supplies
    FROM
      Supply s
    GROUP BY
      MONTH(s.date)
    ORDER BY
      month;

  OPEN supplies_cursor;
  FETCH NEXT FROM supplies_cursor INTO @month, @num_supplies;

  PRINT 'Количество поставок по месяцам:';
  WHILE @@FETCH_STATUS = 0
  BEGIN
    PRINT 'Месяц: ' + CAST(@month AS NVARCHAR(2)) + ' | Количество поставок: ' + CAST(@num_supplies AS NVARCHAR(10));
    FETCH NEXT FROM supplies_cursor INTO @month, @num_supplies;
  END

  CLOSE supplies_cursor;
  DEALLOCATE supplies_cursor;

  -- Поставщики с ценами выше среднего
  DECLARE @provider_name NVARCHAR(255), @country NVARCHAR(255), @provider_city NVARCHAR(255), @avg_price DECIMAL(10,2);
  DECLARE suppliers_cursor CURSOR FOR
    SELECT
      p.name AS provider_name, p.country, p.city, AVG(c.price) AS avg_price
    FROM
      Provider p
    JOIN
      Supply s ON p.ID = s.provider_id
    JOIN
      Candle c ON s.number_of_supply = c.supply
    GROUP BY
      p.name, p.country, p.city
    HAVING
      AVG(c.price) > (SELECT AVG(price) FROM Candle)
    ORDER BY
      avg_price DESC;

  OPEN suppliers_cursor;
  FETCH NEXT FROM suppliers_cursor INTO @provider_name, @country, @provider_city, @avg_price;

  PRINT 'Поставщики с ценами выше среднего:';
  WHILE @@FETCH_STATUS = 0
  BEGIN
    PRINT @provider_name + ' | Страна: ' + @country + ' | Город: ' + @provider_city + ' | Средняя цена: ' + CAST(@avg_price AS NVARCHAR(10));
    FETCH NEXT FROM suppliers_cursor INTO @provider_name, @country, @provider_city, @avg_price;
  END

  CLOSE suppliers_cursor;
  DEALLOCATE suppliers_cursor;

  -- Топ-5 пользователей по количеству заказов
  DECLARE @user_name NVARCHAR(255), @user_surname NVARCHAR(255), @user_email VARCHAR(100), @user_phone_number VARCHAR(13), @total_orders INT;
  DECLARE users_cursor CURSOR FOR
    SELECT TOP 5
      u.name, u.surname, u.email, u.phone_number, COUNT(*) AS total_orders
    FROM
      Users u
    JOIN
      Orders o ON u.login = o.login_user
    GROUP BY
      u.name, u.surname, u.email, u.phone_number
    ORDER BY
      total_orders DESC;

  OPEN users_cursor;
  FETCH NEXT FROM users_cursor INTO @user_name, @user_surname, @user_email, @user_phone_number, @total_orders;

  PRINT 'Топ-5 пользователей по количеству заказов:';
  WHILE @@FETCH_STATUS = 0
  BEGIN
    PRINT @user_name + ' ' + @user_surname + ' | Email: ' + @user_email + ' | Телефон: ' + @user_phone_number + ' | Количество заказов: ' + CAST(@total_orders AS NVARCHAR(10));
    FETCH NEXT FROM users_cursor INTO @user_name, @user_surname, @user_email, @user_phone_number, @total_orders;
  END

  CLOSE users_cursor;
  DEALLOCATE users_cursor;

  -- Топ-5 популярных типов и ароматов свечей
  DECLARE popular_candles_cursor CURSOR FOR
    SELECT TOP 5
      c.type, c.smell, SUM(sp.quantity_of_candles) AS total_sold
    FROM
      Candle c
    JOIN
      Select_products sp ON c.ID = sp.id_of_candles
    GROUP BY
      c.type, c.smell
    ORDER BY
      total_sold DESC;

  OPEN popular_candles_cursor;
  FETCH NEXT FROM popular_candles_cursor INTO @type, @smell, @total_sold;

  PRINT 'Топ-5 популярных типов и ароматов свечей:';
  WHILE @@FETCH_STATUS = 0
  BEGIN
    PRINT 'Тип: ' + @type + ' | Запах: ' + @smell + ' | Продано: ' + CAST(@total_sold AS NVARCHAR(10));
    FETCH NEXT FROM popular_candles_cursor INTO @type, @smell, @total_sold;
  END

  CLOSE popular_candles_cursor;
  DEALLOCATE popular_candles_cursor;

  -- Топ-5 городов по количеству заказов
  DECLARE @order_city NVARCHAR(255);
  DECLARE cities_cursor CURSOR FOR
    SELECT TOP 5
      a.city, COUNT(*) AS total_orders
    FROM
      Orders o
    JOIN
      Address a ON o.adress = a.ID
    GROUP BY
      a.city
    ORDER BY
      total_orders DESC;

  OPEN cities_cursor;
  FETCH NEXT FROM cities_cursor INTO @order_city, @total_orders;

  PRINT 'Топ-5 городов по количеству заказов:';
  WHILE @@FETCH_STATUS = 0
  BEGIN
    PRINT 'Город: ' + @order_city + ' | Количество заказов: ' + CAST(@total_orders AS NVARCHAR(10));
    FETCH NEXT FROM cities_cursor INTO @order_city, @total_orders;
  END

  CLOSE cities_cursor;
  DEALLOCATE cities_cursor;
END;
-----------------------------
EXEC AnalyzeCandles;
