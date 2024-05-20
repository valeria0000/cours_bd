use candle;
CREATE TABLE Boss (
    ID INT IDENTITY(1,1) PRIMARY KEY,
	name nvarchar(255),
	surname nvarchar(255),
	email varchar(100),
    phone_number varchar(13),
);

CREATE TABLE Provider (
    ID INT IDENTITY(1,1) PRIMARY KEY,
	name nvarchar(255),
	country nvarchar(255),
	city nvarchar(255),
	boss_id int,
	FOREIGN KEY (boss_id) REFERENCES Boss(id),
);

CREATE TABLE Supply (
    number_of_supply INT IDENTITY(1,1) PRIMARY KEY,
	date date,
    quantity_of_products int,
	provider_id int, 
	FOREIGN KEY (provider_id) REFERENCES Provider(id),
);

CREATE TABLE Candle (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    name nvarchar(255),
	price int,
	type nvarchar(255),
	smell nvarchar(255),
	photo nvarchar(255),
	quantity int,
	supply int, 
	FOREIGN KEY (supply) REFERENCES Supply(number_of_supply)
);

CREATE TABLE Address (
    ID INT IDENTITY(1,1) PRIMARY KEY,
	country nvarchar(255),
	city nvarchar(255),
	adress nvarchar(255),
);

CREATE TABLE Users (
    login varchar(50) PRIMARY KEY,
	name nvarchar(255),
	surname nvarchar(255),
	email varchar(100),
    phone_number varchar(13),
	sex nvarchar(3),
);

CREATE TABLE Select_products (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    id_of_candles INT,
    FOREIGN KEY (id_of_candles) REFERENCES Candle(ID),
    quantity_of_candles INT,
	login_user varchar(50),
    FOREIGN KEY (login_user) REFERENCES Users(login),
);

CREATE TABLE Orders (
    number INT IDENTITY(1,1) PRIMARY KEY,
    adress INT,
    FOREIGN KEY (adress) REFERENCES Address(id),
    products INT,
    FOREIGN KEY (products) REFERENCES Candle(ID),
	login_user varchar(50),
    FOREIGN KEY (login_user) REFERENCES Users(login),
    date DATE,
);

insert into users values ('rr.valeri', 'Valeria', 'Rudyak', 'vlrr@gmail.com', '+375336740852', 'Æ');
insert into users values ('papita', 'Anna', 'Dudko', 'pip@gmail.com', '+375336740852', 'Æ');

INSERT INTO Boss (name, surname, email, phone_number) 
VALUES ('John', 'Doe', 'john.doe@example.com', '123-456-7890'),
       ('Jane', 'Smith', 'jane.smith@example.com', '987-654-3210'),
       ('Alice', 'Johnson', 'alice.johnson@example.com', '555-123-4567');

INSERT INTO Provider (name, country, city, boss_id) 
VALUES ('ABC Suppliers', 'Belarus', 'Minsk', 1),
       ('XYZ Exporters', 'Poland', 'Krakow', 2),
       ('123 Enterprises', 'Belarus', 'Grodno', 3);

INSERT INTO Supply (date, quantity_of_products, provider_id) 
VALUES ('2024-04-01', 100, 1),
       ('2024-04-02', 150, 2),
       ('2024-04-03', 200, 3),
       ('2024-04-04', 120, 1);

INSERT INTO Candle (name, price, type, smell, photo, quantity, supply) 
VALUES ('Vanilla Candle', 25, 'Candle', 'Vanilla', 'vanilla_candle.jpg', 100, 1),
       ('Rose Candle', 20, 'Candle', 'Rose', 'rose_candle.jpg', 150, 2),
       ('Peach Incense', 15, 'Incense', 'Peach', 'peach_Incense.jpg', 200, 3),
       ('Green Candleholders', 10, 'Candleholders', NULL, 'green_candleholders.jpg', 500, 4),
       ('Peach Candleholders', 15, 'Candleholders', NULL, 'peach_candleholders.jpg', 50, 1);

INSERT INTO Address (country, city, adress)
VALUES
    ('Belarus', 'Lida', 'Kooperativnaya 52-56'),
    ('Belarus', 'Minsk', 'Rainysa 19-68'),
    ('Belarus', 'Grodno', 'Belarusskaya 21-56');

select * from Candle;
select * from users;
select * from Orders;
select * from Select_products;
select * from Address;
select * from Supply;
select * from Provider;
select * from Boss;

SELECT name 
FROM sys.procedures