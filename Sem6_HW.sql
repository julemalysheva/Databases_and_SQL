# Урок 6. SQL – Транзакции. Временные таблицы, управляющие конструкции, циклы
use vk;

/* 1. Написать функцию, которая удаляет всю информацию об указанном пользователе из БД vk. 
Пользователь задается по id. Удалить нужно все сообщения, лайки, медиа записи, профиль и запись из таблицы users. 
Функция должна возвращать номер пользователя.*/

DROP FUNCTION IF EXISTS remove_users_data;
DELIMITER //

CREATE FUNCTION remove_users_data(for_user_id BIGINT UNSIGNED)
RETURNS BIGINT UNSIGNED READS SQL DATA
BEGIN
	DECLARE remove_to_user INT; -- BIGINT
    SET remove_to_user = for_user_id;
-- описание команд для удаления
	DELETE FROM messages -- все сообщения
        WHERE from_user_id = remove_to_user OR to_user_id = remove_to_user;
    DELETE FROM media -- медиа записи
        WHERE user_id = remove_to_user;  
	DELETE FROM likes -- лайки
        WHERE user_id = remove_to_user;
	DELETE FROM profiles -- профиль
        WHERE user_id = remove_to_user;   
	DELETE FROM users -- запись из таблицы users
        WHERE id = remove_to_user;
        
-- пробую второй вариант удаления, тоже ошибка внешних ключей     
	/*DELETE messages, media, likes, profiles, users
    FROM messages, media, likes, profiles, users 
    WHERE users.id = for_user_id AND (users.id = messages.from_user_id OR users.id = messages.to_user_id)
		AND users.id = media.user_id AND users.id = likes.user_id AND users.id = profiles.user_id
    ;  */
    
	RETURN remove_to_user;
END//
DELIMITER ; -- вернем прежний разделитель

-- Вызов функции / результаты
SELECT remove_users_data(2); -- передаем id пользователя
/*ошибка ограничения с внешними ключами
Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails
*/

/* 2. Предыдущую задачу решить с помощью процедуры и обернуть используемые команды в транзакцию внутри процедуры.*/

DROP PROCEDURE IF EXISTS del_user;

DELIMITER //

CREATE PROCEDURE del_user(for_user_id BIGINT, OUT tran_result varchar(200))
BEGIN
    DECLARE `_rollback` BOOL DEFAULT 0;
   	DECLARE code varchar(100);
   	DECLARE error_string varchar(100);

   DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
   begin
    	SET `_rollback` = 1;
	GET stacked DIAGNOSTICS CONDITION 1
          code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT;
    	set tran_result := concat('Error occured. Code: ', code, '. Text: ', error_string);
    end;
		        
    START TRANSACTION;
			-- описание команд для удаления
		DELETE FROM messages -- все сообщения
			WHERE from_user_id = for_user_id OR to_user_id = for_user_id;
		DELETE FROM media -- медиа записи
			WHERE user_id = for_user_id;  
		DELETE FROM likes -- лайки
			WHERE user_id = for_user_id;
		DELETE FROM profiles -- профиль
			WHERE user_id = for_user_id;   
		DELETE FROM users -- запись из таблицы users
			WHERE id = for_user_id;
	
	    IF `_rollback` THEN
	       ROLLBACK;
	    ELSE
		set tran_result := 'ok';
	       COMMIT;
	    END IF;
END//

DELIMITER ;
-- вызываем процедуру
call del_user(2, @tran_result);
-- смотрим результат
select @tran_result;

/* 3. * Написать триггер, который проверяет новое появляющееся сообщество. 
Длина названия сообщества (поле name) должна быть не менее 5 символов. 
Если требование не выполнено, то выбрасывать исключение с пояснением.*/

DROP TRIGGER IF EXISTS check_communities_name_before_insert;

DELIMITER //

CREATE TRIGGER check_communities_name_before_insert 
BEFORE INSERT ON communities
FOR EACH ROW
begin
    IF CHAR_LENGTH(NEW.name) < 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Сообщество не создано. Название должно быть от 5 символов';
    END IF;
END//

DELIMITER ;

INSERT INTO communities(name) VALUES ('какое-то');
INSERT INTO communities(name) VALUES ('как'); -- Error Code: 1644. Сообщество не создано. Название должно быть от 5 символов

select * from communities;