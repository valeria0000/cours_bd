CREATE LOGIN AdministratorCandle WITH PASSWORD = 'admin_for_candle';
CREATE LOGIN ClientCandle WITH PASSWORD = 'client_for_candle';
CREATE USER admin_for_candle FOR LOGIN AdministratorCandle;
CREATE USER client_for_candle FOR LOGIN ClientCandle;
CREATE ROLE AdministratorRole;
CREATE ROLE ClientRole;
ALTER ROLE AdministratorRole ADD MEMBER admin_for_candle;
ALTER ROLE ClientRole ADD MEMBER client_for_candle;
CREATE LOGIN Guestt WITH PASSWORD = 'Guestt';
CREATE USER Guestt FOR LOGIN Guestt;
CREATE ROLE GuestRole;
ALTER ROLE GuestRole ADD MEMBER Guestt;

GRANT SELECT, UPDATE, INSERT, DELETE ON dbo.Users TO AdministratorRole;
GRANT SELECT, UPDATE, INSERT, DELETE ON dbo.Candle TO AdministratorRole;
GRANT SELECT, UPDATE, INSERT, DELETE ON dbo.Adress TO AdministratorRole;
GRANT SELECT, UPDATE, INSERT, DELETE ON dbo.Orders TO AdministratorRole;
GRANT SELECT, UPDATE, INSERT, DELETE ON dbo.Boss TO AdministratorRole;
GRANT SELECT, UPDATE, INSERT, DELETE ON dbo.Supply TO AdministratorRole;
GRANT SELECT, UPDATE, INSERT, DELETE ON dbo.Provider TO AdministratorRole;
GRANT SELECT, UPDATE, INSERT, DELETE ON dbo.Select_products TO AdministratorRole;

GRANT EXECUTE ON dbo.ADD_TO_CART  TO AdministratorRole;
GRANT EXECUTE ON dbo.ClearCart  TO AdministratorRole;
GRANT EXECUTE ON dbo.AddCandle  TO AdministratorRole;
GRANT EXECUTE ON dbo.DeleteCandle  TO AdministratorRole;
GRANT EXECUTE ON dbo.ADD_ORDER  TO AdministratorRole;
GRANT EXECUTE ON dbo.AddSupply  TO AdministratorRole;
GRANT EXECUTE ON dbo.ManageProvider  TO AdministratorRole;
GRANT EXECUTE ON dbo.UpdateCandle  TO AdministratorRole;
GRANT EXECUTE ON dbo.AddUser  TO AdministratorRole;
GRANT EXECUTE ON dbo.AnalyzeCandles  TO AdministratorRole;

GRANT EXECUTE ON dbo.ADD_TO_CART  TO ClientnRole;
GRANT EXECUTE ON dbo.ClearCart  TO ClientnRole;
GRANT EXECUTE ON dbo.ADD_ORDER  TO ClientnRole;
GRANT EXECUTE ON dbo.AddUser  TO ClientnRole;

GRANT EXECUTE ON dbo.AddUser  TO GuestRole;
--ему доступны функции

--проверовчка
execute as user = 'admin_for_candle';
exec dbo.AnalyzeCandles
revert;

execute as user = 'client_for_candle';
exec dbo.AnalyzeCandles
revert;

execute as user = 'Guestt';
exec dbo.AnalyzeCandles
revert;