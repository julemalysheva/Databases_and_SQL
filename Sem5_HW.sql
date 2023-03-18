# Урок 5. SQL – оконные функции
USE vk;

-- 1. Создайте представление с произвольным SELECT-запросом из прошлых уроков [CREATE VIEW]
CREATE or replace VIEW view_cnt_communities AS
	SELECT 
		u.firstname,
		u.lastname,
		uc.user_id,
		count(uc.community_id) AS cnt_communities
	FROM users_communities uc
		JOIN users u ON uc.user_id = u.id 
	GROUP BY uc.user_id
	ORDER BY cnt_communities DESC;

-- 2. Выведите данные, используя написанное представление [SELECT]
SELECT 
	firstname,
    lastname,
    user_id,
    cnt_communities
FROM view_cnt_communities;
    
-- 3. Удалите представление [DROP VIEW]
DROP VIEW view_cnt_communities;

/* 4. * Сколько новостей (записей в таблице media) у каждого пользователя? 
Вывести поля: news_count (количество новостей), user_id (номер пользователя), user_email (email пользователя). 
Попробовать решить с помощью CTE или с помощью обычного JOIN.*/

WITH cte AS (
	select 
		count(*) as news_count,
		user_id
	from media
	group by user_id
)
SELECT 
	news_count,
    user_id,
    email as user_email
FROM cte 
JOIN users as u on u.id = cte.user_id;

-- др. вариант
SELECT 
	m.user_id,
    COUNT(*) AS news_count,
    u.email AS user_email
FROM media m
	JOIN users u ON m.user_id = u.id
GROUP BY user_id;    