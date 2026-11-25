PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

-- Добавляем профессию
INSERT OR IGNORE INTO occupations (name)
VALUES ('student');

-- Добавляем пять пользователей
INSERT OR IGNORE INTO users
    (name, email, gender_id, occupation_id, register_date)
VALUES
    ('Михайлов Александр', 'alexander.mikhailov@example.com',
     (SELECT id FROM genders WHERE name = 'male'),
     (SELECT id FROM occupations WHERE name = 'student'),
     strftime('%Y-%m-%d', 'now', 'localtime')),

    ('Лаптева Виктория', 'victoria.lapteva@example.com',
     (SELECT id FROM genders WHERE name = 'female'),
     (SELECT id FROM occupations WHERE name = 'student'),
     strftime('%Y-%m-%d', 'now', 'localtime')),

    ('Лушаев Александр', 'alexander.lushaev@example.com',
     (SELECT id FROM genders WHERE name = 'male'),
     (SELECT id FROM occupations WHERE name = 'student'),
     strftime('%Y-%m-%d', 'now', 'localtime')),

    ('Мурашов Алексей', 'alexey.murashov@example.com',
     (SELECT id FROM genders WHERE name = 'male'),
     (SELECT id FROM occupations WHERE name = 'student'),
     strftime('%Y-%m-%d', 'now', 'localtime')),

    ('Осипов Виталий', 'vitaly.osipov@example.com',
     (SELECT id FROM genders WHERE name = 'male'),
     (SELECT id FROM occupations WHERE name = 'student'),
     strftime('%Y-%m-%d', 'now', 'localtime'));

-- Добавляем три жанра
INSERT OR IGNORE INTO genres (name)
VALUES ('Sci-Fi'), ('Drama'), ('Comedy');

-- Добавляем три фильма
INSERT INTO movies (title, year)
SELECT 'Interstellar', 2014
WHERE NOT EXISTS (
    SELECT 1 FROM movies WHERE title = 'Interstellar' AND year = 2014
);

INSERT INTO movies (title, year)
SELECT 'The Green Mile', 1999
WHERE NOT EXISTS (
    SELECT 1 FROM movies WHERE title = 'The Green Mile' AND year = 1999
);

INSERT INTO movies (title, year)
SELECT 'The Grand Budapest Hotel', 2014
WHERE NOT EXISTS (
    SELECT 1 FROM movies
    WHERE title = 'The Grand Budapest Hotel' AND year = 2014
);

-- Связываем фильмы с жанрами
INSERT OR IGNORE INTO movie_genres (movie_id, genre_id)
SELECT m.id, g.id
FROM movies m, genres g
WHERE m.title = 'Interstellar'
  AND m.year = 2014
  AND g.name = 'Sci-Fi';

INSERT OR IGNORE INTO movie_genres (movie_id, genre_id)
SELECT m.id, g.id
FROM movies m, genres g
WHERE m.title = 'The Green Mile'
  AND m.year = 1999
  AND g.name = 'Drama';

INSERT OR IGNORE INTO movie_genres (movie_id, genre_id)
SELECT m.id, g.id
FROM movies m, genres g
WHERE m.title = 'The Grand Budapest Hotel'
  AND m.year = 2014
  AND g.name = 'Comedy';

-- Добавляем три отзыва от Александра Михайлова
INSERT OR IGNORE INTO ratings (user_id, movie_id, rating)
SELECT u.id, m.id, 5.0
FROM users u, movies m
WHERE u.email = 'alexander.mikhailov@example.com'
  AND m.title = 'Interstellar' AND m.year = 2014;

INSERT OR IGNORE INTO ratings (user_id, movie_id, rating)
SELECT u.id, m.id, 4.5
FROM users u, movies m
WHERE u.email = 'alexander.mikhailov@example.com'
  AND m.title = 'The Green Mile' AND m.year = 1999;

INSERT OR IGNORE INTO ratings (user_id, movie_id, rating)
SELECT u.id, m.id, 4.0
FROM users u, movies m
WHERE u.email = 'alexander.mikhailov@example.com'
  AND m.title = 'The Grand Budapest Hotel' AND m.year = 2014;

COMMIT;
