sqlite3 movies_rating.db < db_init.sql

echo "=== Task 1 ==="
sqlite3 movies_rating.db -box "SELECT u1.name AS user1, u2.name AS user2, movies.title FROM ratings r1 JOIN ratings r2 ON r1.movie_id = r2.movie_id AND r1.user_id < r2.user_id JOIN users u1 ON r1.user_id = u1.id JOIN users u2 ON r2.user_id = u2.id JOIN movies ON r1.movie_id = movies.id LIMIT 100;"

echo "=== Task 2 ==="
sqlite3 movies_rating.db -box "SELECT movies.title, users.name, ratings.rating, strftime('%Y-%m-%d', ratings.timestamp, 'unixepoch') AS review_date FROM ratings JOIN movies ON ratings.movie_id = movies.id JOIN users ON ratings.user_id = users.id GROUP BY ratings.user_id ORDER BY ratings.timestamp DESC LIMIT 10;"

echo "=== Task 3 ==="
sqlite3 movies_rating.db -box "WITH movie_avgs AS (SELECT m.id, m.title, m.year, AVG(r.rating) AS avg_rating FROM movies m JOIN ratings r ON m.id = r.movie_id GROUP BY m.id), ranked AS (SELECT title, year, avg_rating, CASE WHEN avg_rating = (SELECT MAX(avg_rating) FROM movie_avgs) THEN 'Да' ELSE 'Нет' END AS recommended FROM movie_avgs WHERE avg_rating = (SELECT MAX(avg_rating) FROM movie_avgs) OR avg_rating = (SELECT MIN(avg_rating) FROM movie_avgs)) SELECT title, year, ROUND(avg_rating, 2) AS avg_rating, recommended FROM ranked ORDER BY year, title;"

echo "=== Task 4 ==="
sqlite3 movies_rating.db -box "SELECT COUNT(r.rating) AS rating_count, ROUND(AVG(r.rating), 2) AS avg_rating FROM ratings r JOIN users u ON r.user_id = u.id WHERE u.gender = 'female' AND r.timestamp >= strftime('%s', '2010-01-01') AND r.timestamp <= strftime('%s', '2012-12-31');"

echo "=== Task 5 ==="
sqlite3 movies_rating.db -box "WITH movie_ratings AS (SELECT m.title, m.year, AVG(r.rating) AS avg_rating FROM movies m JOIN ratings r ON m.id = r.movie_id GROUP BY m.id, m.title, m.year), ranked_movies AS (SELECT title, year, avg_rating, DENSE_RANK() OVER (ORDER BY avg_rating DESC) as rank_pos FROM movie_ratings) SELECT title, year, ROUND(avg_rating, 2) AS avg_rating, rank_pos FROM ranked_movies ORDER BY year, title LIMIT 20;"

echo "=== Task 6 ==="
sqlite3 movies_rating.db -box "SELECT SUBSTR(name, INSTR(name, ' ') + 1) || ' ' || SUBSTR(name, 1, INSTR(name, ' ') - 1) || '|' || register_date AS user_info FROM users ORDER BY register_date DESC LIMIT 10;"

echo "=== Task 7 ==="
sqlite3 movies_rating.db -box "WITH movie_counts AS (SELECT m.title, COUNT(r.rating) AS cnt FROM movies m JOIN ratings r ON m.id = r.movie_id GROUP BY m.id) SELECT title, cnt FROM movie_counts WHERE cnt = (SELECT MAX(cnt) FROM movie_counts);"

echo "=== Task 8 ==="
sqlite3 movies_rating.db -box "WITH user_counts AS (SELECT u.name, COUNT(r.rating) AS cnt FROM users u JOIN ratings r ON u.id = r.user_id GROUP BY u.id) SELECT name, cnt FROM user_counts WHERE cnt = (SELECT MAX(cnt) FROM user_counts);"

