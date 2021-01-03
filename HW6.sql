USE vk;

-- первый пользователь в списке - тот, от кого пришло больше всего сообщений
SELECT 
    from_users_id, COUNT(from_users_id) AS num_requests
FROM
    messages
WHERE
    to_users_id = 89
GROUP BY from_users_id
ORDER BY num_requests DESC
LIMIT 1
;

-- Подсчитать общее количество лайков, которые получили 10 самых молодых пользователейlikes
SELECT 
    SUM(likes_total)
FROM
    (SELECT 
        profiles.users_id,
            (TO_DAYS(NOW()) - TO_DAYS(profiles.birthday)) / 365.25 AS age,
            COUNT(likes.posts_id) + COUNT(likes.messages_id) + COUNT(likes.media_id) AS likes_total
    FROM
        profiles
    JOIN posts ON profiles.users_id = posts.users_id
    JOIN likes ON posts.id = likes.posts_id
    JOIN messages ON messages.id = likes.messages_id
    JOIN media ON media.id = likes.media_id
    GROUP BY profiles.users_id
    ORDER BY age
    LIMIT 10) AS data;
    
-- 4.	Определить кто больше поставил лайков   мужчины или женщины?

SELECT 
		profiles.gender AS gender,
		COUNT(likes.posts_id) + COUNT(likes.messages_id)+COUNT(likes.media_id)
    FROM profiles
    JOIN likes ON profiles.users_id = likes.users_id
    GROUP BY profiles.gender
    LIMIT 1
;

-- 5.	Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.
SELECT 
    users.id,
    CONCAT(users.firstname, ' ', users.lastname) AS full_name,
    (COUNT(likes.users_id) + COUNT(messages.id) + COUNT(posts.id) + COUNT(media.id)) / 4 AS activity
FROM users
LEFT JOIN likes ON users.id = likes.users_id
LEFT JOIN posts ON users.id = posts.users_id
LEFT JOIN media ON users.id = media.users_id
LEFT JOIN messages ON users.id = messages.from_users_id
GROUP BY users.id
ORDER BY activity
LIMIT 10
;
