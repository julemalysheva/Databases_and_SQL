CREATE SCHEMA computer_shop;
USE computer_shop;

CREATE TABLE Laptop (
	code INT NOT NULL,
	model VARCHAR(50),
	speed SMALLINT,
	ram SMALLINT,
	hd DOUBLE,
	price DECIMAL(12,2),
	screen TINYINT
);

CREATE TABLE Product(
	maker VARCHAR(10),
    model VARCHAR(50),
    type VARCHAR(50)
);

CREATE TABLE PC (
	code INT NOT NULL,
	model VARCHAR(50),
	speed SMALLINT,
	ram SMALLINT,
	hd DOUBLE,
    cd VARCHAR(10),
	price DECIMAL(12,2)
);

CREATE TABLE Printer (
	code INT NOT NULL,
	model VARCHAR(50),
    color CHAR(1),
    type VARCHAR(10),
    price DECIMAL(12,2)
);

ALTER TABLE Laptop ADD CONSTRAINT PK_Laptop PRIMARY KEY ( code );
ALTER TABLE PC ADD CONSTRAINT PK_pc PRIMARY KEY ( code );   
ALTER TABLE Product ADD CONSTRAINT PK_product PRIMARY KEY ( model );
ALTER TABLE Printer ADD CONSTRAINT PK_printer PRIMARY KEY ( code );

ALTER TABLE Laptop ADD CONSTRAINT FK_Laptop_product FOREIGN KEY ( model ) REFERENCES Product ( model );

ALTER TABLE PC ADD CONSTRAINT FK_pc_product FOREIGN KEY ( model )
REFERENCES Product ( model );

ALTER TABLE Printer ADD CONSTRAINT FK_printer_product FOREIGN KEY ( model ) REFERENCES Product ( model );

/*----Product--------------------*/
insert into Product values('B','1121','PC')
,('A','1232','PC')
,('A','1233','PC')
,('E','1260','PC')
,('A','1276','Printer')
,('D','1288','Printer')
,('A','1298','Laptop')
,('C','1321','Laptop')
,('A','1401','Printer')
,('A','1408','Printer')
,('D','1433','Printer')
,('E','1434','Printer')
,('B','1750','Laptop')
,('A','1752','Laptop')
,('E','2113','PC')
,('E','2112','PC');

/*----PC-------------------------*/
insert into PC values(1,'1232',500,64,5,'12x',600)
,(2,'1121',750,128,14,'40x',850)
,(3,'1233',500,64,5,'12x',600)
,(4,'1121',600,128,14,'40x',850)
,(5,'1121',600,128,8,'40x',850)
,(6,'1233',750,128,20,'50x',950)
,(7,'1232',500,32,10,'12x',400)
,(8,'1232',450,64,8,'24x',350)
,(9,'1232',450,32,10,'24x',350)
,(10,'1260',500,32,10,'12x',350)
,(11,'1233',900,128,40,'40x',980)
,(12,'1233',800,128,20,'50x',970)
,(13,'1121',900,64,5,'12x', 850)
,(14,'1121',900,127,11,'50x',850)
,(15,'1121',900,124,12,'40x',850)
,(16,'1121',900,138,14,'40x',850)
;

/*----Laptop---------------------*/
insert into Laptop values(1,'1298',350,32,4,700,11)
,(2,'1321',500,64,8,970,12)
,(3,'1750',750,128,12,1200,14)
,(4,'1298',600,64,10,1050,15)
,(5,'1752',750,128,10,1150,14)
,(6,'1298',450,64,10,950,12)
;

/*----Printer--------------------*/
insert into Printer values(1,'1276','n','Laser',400)
,(2,'1433','y','Jet',270)
,(3,'1434','y','Jet',290)
,(4,'1401','n','Matrix',150)
,(5,'1408','n','Matrix',270)
,(6,'1288','n','Laser',400)
;

/*1.5 * Добавить несколько новых товаров от новых производителей в таблицы 
PC, Laptop, Printer
Будет такое же обычное добавление. 
*/

SELECT COUNT(*) FROM Product;

SELECT * FROM Product LIMIT 4;

SELECT 
	DISTINCT type
FROM Product
ORDER BY type; -- ORDER BY всегда ставится в конце запроса

-- количество товаров сгруппированное по производителю A, C и D
SELECT 
       maker, 
       count(*) as type_amount
     FROM Product
     GROUP BY maker
     HAVING maker IN ("A", "C", "D")
     ORDER BY type_amount ASC -- ASC / DESC сортировка по возрастанию по умолчанию, desc по убыванию

-- 01. Выведите все записи, отсортированные по полю "speed" по возрастанию
SELECT *
FROM Laptop
ORDER BY speed;

-- 02. Выведите все записи, отсортированные по полю "model"
SELECT *
FROM Product
ORDER BY model;

-- 03. Выведите записи полей "code", "hd","price",
--    отсортированные по полю "price" в алфавитном порядке по убыванию
SELECT code, hd, price
FROM PC
ORDER BY price DESC;

-- 04. Выполните сортировку по полям "speed" и "ram" по убыванию 
SELECT code, hd, price, speed, ram
FROM PC
ORDER BY speed DESC, ram DESC;

-- 05. Выведите уникальные (неповторяющиеся) значения поля «model»
SELECT distinct model
FROM Laptop;

-- 06. Выведите первые две первые записи из таблицы
SELECT code, hd, price, speed, ram
FROM PC
LIMIT 2;

-- 07. Пропустите  первые 4 строки 1<=code<=4 
--     и извлеките следующие 3 строки 5<=code<=7
SELECT code, hd, price, speed, ram
FROM PC
LIMIT 4, 3;

-- 08. Пропустите две последнии строки 
--     и извлекаются следующие за ними 3 строки
--     Например, в таблице 10 строк 1<=code<=10.
--     Нужно пропустить 9<=code<=10. Показать 8>=code>=6
SELECT code, hd, price, speed, ram -- полный вывод
FROM PC;

SELECT code, hd, price, speed, ram -- по заданию
FROM PC
ORDER BY code DESC
LIMIT 2, 3 ;

/*SELECT code, hd, price, speed, ram -- не пойму, что тут не так
FROM PC
ORDER BY code 
OFFSET 2 ROWS FETCH NEXT 3 ROWS ONLY;*/

/*ПОДУМАТЬ - SELECT ColumnNames FROM TableName ORDER BY
ColumnNames OFFSET m ROWS FETCH NEXT p ROWS ONLY;
--Получаем 5 последних строк
   SELECT ProductId, ProductName, Price
   FROM TestTable
   ORDER BY ProductId
   OFFSET @CNT - 5 ROWS FETCH NEXT 5 ROWS ONLY;
*/

-- 09. Рассчитайте общий бюджет. Каждая позиция встречается один раз
-- ? не понятно, что сделать 
SELECT SUM(price)
FROM PC;

-- 10. Выведите общую стоимость по моделям
SELECT SUM(price), model -- SUM(price)
FROM PC
GROUP BY model;

-- 11. Посчитайте количество записей в таблице
SELECT COUNT(*)
FROM PC;

-- 12. Выведите количество уникальных моделей
SELECT COUNT(distinct model) AS COUNT_MODEL
FROM PC;

-- 13. Найдите среднее стоимость по всем моделям
SELECT AVG(price), model
FROM PC
GROUP BY model;

SELECT AVG(price)
FROM PC;

-- 14. Сгруппируйте поля по модели 
       -- Для каждой группы  найдите суммарную стоимостью
       -- задание 10?

-- 15. Сгруппируйте поля по объёму ram
--     Найдите максимальный ценник внутри группы
SELECT MAX(price), ram
FROM PC
GROUP BY ram;

-- 16. Покажите только модель с минимальным прайсом
SELECT MIN(price)
FROM PC;

SELECT MIN(price) AS min_price, model
FROM PC
GROUP BY model
HAVING min_price = 
	(SELECT MIN(price) 
	FROM PC);
    
-- HAVING min_price = 350; -- или как это можно указать не явно?


