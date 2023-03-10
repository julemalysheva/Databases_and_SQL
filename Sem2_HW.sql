# Урок 2. SQL – создание объектов, простые запросы выборки

/*Задачи
1. Создать БД vk, исполнив скрипт _vk_db_creation.sql (в материалах к уроку)
2. Написать скрипт, добавляющий в созданную БД vk 2-3 новые таблицы 
(с перечнем полей, указанием индексов и внешних ключей) (CREATE TABLE)
*/
USE vk;

-- добавим таблицу исполнителей 
DROP TABLE IF EXISTS artists;
CREATE TABLE artists (
	id_artist BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    artist_name VARCHAR(255) NOT NULL,
    INDEX idx_artist_name(artist_name)
);

-- добавим таблицу треков
DROP TABLE IF EXISTS tracks;
CREATE TABLE tracks (
	track_id SERIAL,
	artist_id BIGINT UNSIGNED,
	media_id BIGINT UNSIGNED NOT NULL,
    title varchar(255),

	INDEX title_track_idx(title),
    FOREIGN KEY (artist_id) REFERENCES artists(id_artist),
    FOREIGN KEY (media_id) REFERENCES media(id)
);

-- добавим таблицу Музыка пользователей (в самом ближайшем приближении, без плейлистов))
DROP TABLE IF EXISTS users_music;
CREATE TABLE users_music (
	id SERIAL,
	track_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    
	FOREIGN KEY (track_id) REFERENCES tracks(track_id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- добавим таблицу Города 
DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
	id SERIAL,
	name_city varchar(255) NOT NULL,
    INDEX city_index(name_city)
);

-- теперь нужно изменить колонку Город в таблице Профили 
ALTER TABLE profiles RENAME COLUMN hometown TO city_id;
ALTER TABLE profiles MODIFY COLUMN city_id BIGINT UNSIGNED NOT NULL;

-- Добавим отдельным запросом внешний ключ (ссылку на таблицу cities)
ALTER TABLE profiles ADD CONSTRAINT fk_profiles_city_id
    FOREIGN KEY (city_id) REFERENCES cities(id)

-- 3. Заполнить 2 таблицы БД vk данными (по 10 записей в каждой таблице) (INSERT)
-- заполняем таблицу users
INSERT INTO users (`firstname`, `lastname`, `email`, `password_hash`, `phone`)
VALUES 
('Terry','Kris','kole.lowe@example.com','707fda62cd1fc15f5175ca8458467504a2f52c48',5764355),
('Thora','Witting','bins.aida@example.org','a754665ef26557cb481435340e2c1c714e7119a8',99468686),
('Maria','Weissnat','carmen41@example.com','b470e080c8d6d48271c945127cd08c40b141f312',6846949556),
('Audreanne','Borer','alakin@example.net','0e900d55c8394770da7b15ac7b9541b9fc347ab5',908686),
('Hildegard','Sawayn','verner62@example.net','7cfbab8e360e86e5c00caf1235d35df9426df62d',1564646),
('Jonas','Bruen','fae72@example.org','2d4b038b01d29831673ee88691f9bed61b84ad45',21345656),
('Malvina','Hoppe','shuel@example.net','b8027adeea043f86dd53663e8a77d10b917305bd',553568568),
('Yvette','Jakubowski','aquigley@example.net','30cd1a741b9ebaed5c1b3b2012bfdcab64f4f727',8055656),
('Dessie','Sawayn','oswift@example.org','e19e8f45de27d5f45f0c9977521b92de5943c366',15015656),
('Carey','Sporer','darwin.langosh@example.com','fad7d2c272382bb835a33cdff73386b355a225ea',2129862637);

-- заполняем таблицу profiles
INSERT INTO profiles (`user_id`, `gender`, `birthday`)
VALUES 
(1, 'm', '2010-10-22'),
(2, 'f', '1983-07-29'),
(3, 'f', '1962-03-02'),
(4, 'm', '2006-07-17'),
(5, 'm', '1990-11-12'),
(6, 'm', '2010-10-22'),
(7, 'f', '1983-07-29'),
(8, 'f', '1962-03-02'),
(9, 'f', '2006-07-17'),
(10, 'm', '1990-11-12');

/*4.* Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных (поле is_active = true). 
При необходимости предварительно добавить такое поле в таблицу profiles со значением по умолчанию = false (или 0) 
(ALTER TABLE + UPDATE)
*/
-- добавим поле is_active; вероятно, в условии опечатка, по умолчанию ставлю 1, а неактивным поставим 0 
ALTER TABLE vk.profiles
ADD COLUMN is_active TINYINT(1) NOT NULL DEFAULT 1 AFTER city_id;

-- отмечаем невовершеннолетних как неактивных
UPDATE profiles
SET is_active = 0
WHERE NOW() < (birthday + INTERVAL 18 YEAR);

-- формируем запрос с сортировкой по возрасту для проверки значений 
SELECT 
	user_id, birthday, is_active, CURRENT_DATE,
	(YEAR(CURRENT_DATE)-YEAR(birthday))
	- (RIGHT(CURRENT_DATE,5)<RIGHT(birthday,5))
	AS age
FROM profiles ORDER BY age;

/*5.* Написать скрипт, удаляющий сообщения «из будущего» (дата позже сегодняшней) (DELETE)*/
DELETE FROM messages
	WHERE created_at > NOW();

