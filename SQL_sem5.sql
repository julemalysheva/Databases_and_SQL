use seminar5;
-- Задача 1

CREATE TABLE users (
username VARCHAR(50) PRIMARY KEY,
password VARCHAR(50) NOT NULL,
status VARCHAR(10) NOT NULL);

CREATE TABLE users_profile (
username VARCHAR(50) PRIMARY KEY,
name VARCHAR(50) NOT NULL,
address VARCHAR(50) NOT NULL,
email VARCHAR(50) NOT NULL,
FOREIGN KEY (username) REFERENCES users(username) ON DELETE CASCADE);

INSERT INTO users values
('admin' , '7856', 'Active'),
('staff' , '90802', 'Active'),
('manager' , '35462', 'Inactive');

INSERT INTO users_profile values
('admin', 'Administrator' , 'Dhanmondi', 'admin@test.com' ) ,
('staff', 'Jakir Nayek' , 'Mirpur', 'zakir@test.com' ),
('manager', 'Mehr Afroz' , 'Eskaton', 'mehr@test.com' );

-- 1 .1. Используя СТЕ, выведите всех пользователей из таблицы users_profile
/*SELECT -- что-то пробую делать
	username,
    name,
    address,
    email,
    ROW_NUMBER()
		OVER( PARTITION BY name ORDER BY username) AS 'Row number',
    RANK()
		OVER(PARTITION BY username ORDER BY name) AS 'Rank'
FROM users_profile;   */

with up as
(select username, name
from users_profile)
select *
from up;    

-- 1.2. Используя СТЕ, подсчитайте количество активных пользователей. Задайте псевдоним результирующему окну. 
with count_active_users as
(select count(*) as cnt_active
from users
where status = 'Active')
select cnt_active
from count_active_users;

-- 1.3. С помощью СТЕ реализуйте таблицу квадратов чисел от 1 до 10.

-- Рекурсивные CTE
-- выведет циферки от 0 до 10
WITH RECURSIVE `sequence` (n) AS
(
  SELECT 0
  UNION
  SELECT n + 1 
  FROM `sequence`
  WHERE n + 1 <= 10
)
SELECT n
FROM `sequence`;

-- дальше квадраты по задачеalter
WITH RECURSIVE `sequence` (n) AS
(
  SELECT 1
  UNION
  SELECT n + 1 
  FROM `sequence`
  WHERE n + 1 <= 10
)
SELECT n as number, n*n as square 
FROM `sequence`;

-- вариант с семинара от Сергея
WITH RECURSIVE cte AS
(
SELECT 1 AS a, 1 as b
UNION ALL
SELECT a + 1, pow(a+1,2) FROM cte
WHERE a < 10
)
SELECT * FROM cte;

-- Задача 2

CREATE TABLE something (
  TB VARCHAR(50),
  ID_CLIENT INT,
  ID_DOG INT,
  OSZ INT,
  PROCENT_RATE INT,
  RATING INT,
  SEGMENT VARCHAR(10)
);

INSERT INTO something 
(TB, ID_CLIENT, ID_DOG, OSZ, PROCENT_RATE, RATING, SEGMENT)
VALUES
('A',  1,      111, 100 ,     6  ,        10 ,   'SREDN' ),
('A',  1,      222, 150 ,     6  ,        10 ,   'SREDN' ),
('A',  2,      333, 50  ,     9  ,        15 ,   'MMB' ),
('B',  1,      444, 200 ,     7  ,        10 ,   'SREDN' ),
('B',  3,      555, 1000,     5  ,        16 ,   'CIB' ),
('B',  4,      666, 500 ,     10 ,        20 ,   'CIB' ),
('B',  4,      777, 10  ,     12 ,        17 ,   'MMB' ),
('C',  5,      888, 20  ,     11 ,        21 ,   'MMB' ),
('C',  5,      999, 200 ,     9  ,        13 ,   'SREDN' );

SELECT * FROM something;


/*Собрать дэшборд, в котором содержится информация о максимальной задолженности в каждом банке, 
а также средний размер процентной ставки в каждом банке в зависимости от сегмента и количество договоров всего по всем банкам*/

SELECT TB, ID_CLIENT, ID_DOG, OSZ, PROCENT_RATE, RATING, SEGMENT
, MAX(OSZ) OVER (PARTITION BY TB) 'максимальной задолженности в каждом банке'
, AVG(PROCENT_RATE) OVER (partition by TB, SEGMENT) 'средний размер процентной ставки'
, COUNT(ID_DOG) Over(partition by TB) -- можно просто использовать OVER() без аргументов
FROM something;

-- Задача 3. 

CREATE TABLE cars
(
    id INT NOT NULL PRIMARY KEY,
    name VARCHAR(45),
    cost INT
);

INSERT cars
VALUES
    (1, "Audi", 52642),
    (2, "Mercedes", 57127 ),
    (3, "Skoda", 9000 ),
    (4, "Volvo", 29000),
    (5, "Bentley", 350000),
    (6, "Citroen ", 21000 ), 
    (7, "Hummer", 41400), 
    (8, "Volkswagen ", 21600);
    
SELECT *
FROM cars;

-- 3. 1. Создайте представление, в которое попадут автомобили стоимостью  до 25 000 долларов
CREATE view car_view AS
SELECT *
FROM cars
WHERE cost < 25000;

select * 
from car_view;

-- 3. 2. Изменить в существующем представлении порог для стоимости: пусть цена будет до 30 000 долларов (используя оператор ALTER VIEW) 
ALTER VIEW car_view AS
SELECT *
FROM cars
WHERE cost < 30000;

select * 
from car_view;

-- 3. 3. Создайте представление, в котором будут только автомобили марки “Шкода” и “Ауди”
CREATE VIEW car_for_name AS
SELECT *
FROM cars
WHERE name in ('Audi', 'Skoda');

select *
from car_for_name;

