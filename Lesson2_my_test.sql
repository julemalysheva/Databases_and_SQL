CREATE DATABASE lesson_2;

show databases;

USE lesson_2;

-- создадим таблицу Покупатель
CREATE TABLE Buyer
(
id INT PRIMARY KEY AUTO_INCREMENT,
date_birt DATE,
first_name VARCHAR(20),
last_name VARCHAR(20),
mobile_phone VARCHAR(20)
);
CREATE TABLE Orders
(
  id INT PRIMARY KEY AUTO_INCREMENT,
  buyer_id INT,
  amount INT,
  count_order INT,
  manufacter VARCHAR(45),
  FOREIGN KEY (buyer_id)
  REFERENCES Buyer(id)
);

# Заполним нашу таблицу “Покупатели” данными:
-- DATE - format YYYY-MM-DD
-- DATETIME - format: YYYY-MM-DD HH:MI:SS
-- TIMESTAMP - format: YYYY-MM-DD HH:MI:SS
-- YEAR - format YYYY or YY
-- Способ №1
INSERT Buyer (date_birt, first_name,last_name,mobile_phone)
VALUES
  ("2023-01-01", "Михаил", "Меркушов", "+7-999-888-77-66"), -- id = 1
  ("2022-12-31", "Сергей", "Сергеев", "60-70-80"), -- id = 2
  ("2022-12-30", "Том", "Круз", "80-70-80"), -- id = 3
  ("2022-01-02", "Филл", "Поляков", "+7-999-888-77-55"); -- id = 4
-- Покупатели сделали заказы в нашем магазине. Чтобы увидеть их, создадим таблицу с заказами клиентов:
INSERT INTO Orders (buyer_id, amount, count_order, manufacter)
VALUES
  (1, 1000, 3, "Ягодки"), -- Первый заказ из "Покупатели" по id = 1 (Меркушов Михал)
  (1, 400, 2, "Амазон"), -- Второй заказ из "Покупатели" по id = 2 (Меркушов Михал)
  (2, 1200, 5, "Амазон"),
  (3, 2000, 1, "Ягодки"),
  (4, 5000, 4, "Ягодки");
  -- Получается, что Меркушов Михаил сделал 2 заказа в 1 день
# Попробуем увидеть эту связь среди таблиц:
SELECT Buyer.first_name, Buyer.id, Orders.buyer_id, Orders.amount
FROM Orders, Buyer
WHERE Orders.buyer_id = Buyer.id;  
# Используем псевдоним
-- Посчитаем чек по заказу. Для этого умножаю количество на цену:
SELECT amount * count_order AS result -- Псевдоним - result 
FROM Orders;
# Обновления
UPDATE Orders
SET amount = amount * 0.75;
SELECT amount new_amount
FROM Orders;
/*Мы изменили данные в исходной таблице и хотим вернуть исходный результат. 
Для этого можно полностью очистить таблицу от данных с помощью команды TRUNCATE:*/
TRUNCATE Orders; -- удаляет все записи из таблицы Orders
SELECT *
FROM Orders;
/*Чтобы заполнить данными нашу табличку,
можно заново выполнить операцию заполнения таблицы:*/
INSERT INTO Orders (buyer_id, amount, count_order, manufacter)
VALUES
  (1, 1000, 3, "Ягодки"), -- Первый заказ из "Покупатели" по id = 1 (Меркушов Михал)
  (1, 400, 2, "Амазон"), -- Второй заказ из "Покупатели" по id = 2 (Меркушов Михал)
  (2, 1200, 5, "Амазон"),
  (3, 2000, 1, "Ягодки"),
  (4, 5000, 4, "Ягодки");
SELECT *
FROM Orders;
-- запускаем акцию по условию
UPDATE Orders
SET amount = amount * 0.50
WHERE count_order >= 4 ; -- или > 3

SELECT amount AS new_amount, id
FROM Orders;

-- Добавили клиента
INSERT INTO Buyer (date_birt, first_name, last_name, mobile_phone)
VALUES
  ("2023-01-01", "Тестовый", "Пользователь", "+7-999-888-77-66");
-- Удаляем строчку со значением
DELETE FROM Buyer
WHERE first_name = 'Тестовый';  

/***AND -** операция логического И. 
Она объединяет два выражения
**выражение1 AND выражение2***/
-- Получим заказы от 1500 рублей из магазина "Ягодки"
SELECT amount, count_order 
FROM Orders
WHERE amount > 1500 AND manufacter = "Ягодки";

/***OR**: операция логического ИЛИ. 
Она также объединяет два выражения:
**выражение1 OR выражение2***/
--  Хотим получить товары или из "Амазона", или товары из диапазона (3;5)
SELECT amount, count_order, manufacter
FROM Orders
WHERE manufacter = "Амазон" OR count_order > 2 AND count_order < 5;
-- Оператор AND имеет более высокий приоритет, чем OR

/*NOT: операция логического отрицания.
Если выражение в этой операции ложно, то общее условие истинно.*/
-- Исключим товары марки "Ягодки"
SELECT amount, count_order, manufacter
FROM Orders
WHERE manufacter != "Ягодки";
-- ИЛИ через "!="
SELECT amount, count_order, manufacter
FROM Orders
WHERE NOT manufacter = "Ягодки";

/*# Операторы CASE, IF
1.  **СASE**
Проверяет истинность набора условий и возвращает результат 
в зависимости от проверки.*/
-- Давайте добавим в исходную таблицу столбец “статус”, в котором будет два значения: 
ALTER TABLE Orders
ADD COLUMN status INT AFTER count_order;
-- RAND(): 
-- https://dev.mysql.com/doc/refman/8.0/en/mathematical-functions.html#function_rand
-- Возращает числа от 0 до 1
UPDATE Orders
SET status = RAND();

/*Задачка: в зависимости от значения поля “status” вывести 
сообщение о факте оплаты: “заказ оплачен”, “оплатите заказ”.*/
SELECT status, -- Перед "CASE" ставится запятая, после перечисления столбцов
  CASE WHEN status IS TRUE THEN 'заказ оплачен'
  ELSE 'оплатите заказ'
  END AS message
FROM Orders;  
-- ИЛИ

SELECT status, -- Перед "CASE" ставится запятая, после перечисления столбцов
  CASE WHEN status = 1 THEN 'заказ оплачен'
  ELSE 'оплатите заказ' 
  END AS message
FROM Orders;

-- Представьте,что мы страхуем заказы со средним чеком от 3000 включительно.
-- Сообщим клиентам о наличии или отсутствии страховки
SELECT status, amount, count_order, manufacter,-- Перед "IF" тоже ставится запятая
    IF(amount * count_order >= 3000, 'Cтраховка включена в стоимость', 'Страховка оплачивается отдельно') AS info_message
FROM Orders;
