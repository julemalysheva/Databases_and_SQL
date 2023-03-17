# Урок 4. SQL – работа с несколькими таблицами
USE vk;

-- 1. Подсчитать количество групп, в которые вступил каждый пользователь.
SELECT 
	u.firstname,
    u.lastname,
	uc.user_id,
	count(uc.community_id) AS cnt_communities
FROM users_communities uc
JOIN users u ON uc.user_id = u.id 
GROUP BY uc.user_id;

-- 2. Подсчитать количество пользователей в каждом сообществе.
SELECT 
	communities.name,
    count(*) AS count_users
FROM communities 
JOIN users_communities ON users_communities.community_id = communities.id
GROUP BY communities.id
ORDER BY communities.name;    

/* 3. Пусть задан некоторый пользователь. Из всех пользователей соц. сети найдите человека, 
который больше всех общался с выбранным пользователем (написал ему сообщений).*/
SELECT 
	m.from_user_id,
	u.firstname,
    u.lastname,
    count(*) AS cnt_messages
FROM messages m 
JOIN users u ON m.from_user_id = u.id
WHERE to_user_id = 1
GROUP BY from_user_id
ORDER BY cnt_messages DESC
LIMIT 1;
    
-- 4. * Подсчитать общее количество лайков, которые получили пользователи младше 18 лет..
SELECT count(*)
FROM likes
JOIN media ON likes.media_id = media.id
JOIN profiles ON media.user_id = profiles.user_id
WHERE NOW() < (birthday + INTERVAL 18 YEAR);

-- 5. * Определить кто больше поставил лайков (всего): мужчины или женщины.