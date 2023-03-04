# Урок 1. Установка СУБД, подключение к БД, просмотр и создание таблиц

/*Задача 1. Создайте таблицу с мобильными телефонами, используя графический интерфейс. 
Необходимые поля таблицы: product_name (название товара), manufacturer (производитель), 
product_count (количество), price (цена). 
Заполните БД произвольными данными.*/
USE home_work;

-- создание таблицы
CREATE TABLE `home_work`.`mobile_phones` (
  `idmobile_phones` INT NOT NULL AUTO_INCREMENT,
  `product_name` VARCHAR(45) NOT NULL,
  `manufacturer` VARCHAR(45) NOT NULL,
  `product_count` INT NULL,
  `price` INT NULL,
  PRIMARY KEY (`idmobile_phones`));
  
-- наполнение данными
-- меняем размер поля
ALTER TABLE `home_work`.`mobile_phones` 
CHANGE COLUMN `product_name` `product_name` VARCHAR(255) NOT NULL ;
-- заполняем 
INSERT INTO `home_work`.`mobile_phones` (`idmobile_phones`, `product_name`, `manufacturer`, `product_count`, `price`) VALUES ('1', 'Смартфон Honor X7 CMA-LX1, черный', 'Honor ', '5', '14990');
INSERT INTO `home_work`.`mobile_phones` (`product_name`, `manufacturer`, `product_count`, `price`) VALUES ('Смартфон Xiaomi Mi 11 Lite 4G 8/128GB Pink (32934)', 'Xiaomi', '1', '38970');
INSERT INTO `home_work`.`mobile_phones` (`product_name`, `manufacturer`, `product_count`, `price`) VALUES ('Смартфон Apple iPhone 14 Plus 128Gb Midnight', 'Apple', '2', '85767');
INSERT INTO `home_work`.`mobile_phones` (`product_name`, `manufacturer`, `product_count`, `price`) VALUES ('Смартфон Samsung Galaxy S22 8/128Gb Bora Purple (Global)', 'Samsung', '3', '55472');

/* Задача 2. Напишите SELECT-запрос, который выводит название товара, производителя и цену для товаров, 
количество которых превышает 2*/
SELECT
	product_name,
    manufacturer,
    price
FROM mobile_phones
WHERE product_count > 2;
	
/* Задача 3. Выведите SELECT-запросом весь ассортимент товаров марки “Samsung”*/
SELECT
	*
FROM mobile_phones
WHERE manufacturer = "Samsung";     

/* Задача 4.* С помощью SELECT-запроса с оператором LIKE / REGEXP найти:
 4.1.* Товары, в которых есть упоминание "Iphone"*/
SELECT
	*
FROM mobile_phones
WHERE product_name LIKE '%Iphone%'; 

-- 4.2.* Товары, в которых есть упоминание "Samsung"
SELECT
	*
FROM mobile_phones
WHERE product_name LIKE '%Samsung%'; 
-- 2й вариант с REGEXP
SELECT
	*
FROM mobile_phones
WHERE product_name REGEXP 'Samsung'; 

-- 4.3.* Товары, в названии которых есть ЦИФРЫ
SELECT
	*
FROM mobile_phones
WHERE product_name REGEXP '[0-9]'; 

-- 4.4.* Товары, в названии которых есть ЦИФРА "8"
SELECT
	*
FROM mobile_phones
WHERE product_name REGEXP '8'; 
-- или 
SELECT
	*
FROM mobile_phones
WHERE product_name LIKE '%8%'; 