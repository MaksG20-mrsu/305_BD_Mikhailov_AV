import csv
import re

def sql_str(val):
    if val is None or val == '':
        return "NULL"
    val = str(val).replace("'", "''")
    return f"'{val}'"

with open('db_init.sql', 'w', encoding='utf-8') as out:
    out.write("DROP TABLE IF EXISTS movies;\n")
    out.write("DROP TABLE IF EXISTS ratings;\n")
    out.write("DROP TABLE IF EXISTS tags;\n")
    out.write("DROP TABLE IF EXISTS users;\n\n")

    out.write("""CREATE TABLE movies (
    id INTEGER PRIMARY KEY,
    title TEXT,
    year INTEGER,
    genres TEXT
);\n\n""")

    out.write("""CREATE TABLE ratings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    movie_id INTEGER,
    rating REAL,
    timestamp INTEGER
);\n\n""")

    out.write("""CREATE TABLE tags (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    movie_id INTEGER,
    tag TEXT,
    timestamp INTEGER
);\n\n""")

    out.write("""CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name TEXT,
    email TEXT,
    gender TEXT,
    register_date TEXT,
    occupation TEXT
);\n\n""")

    try:
        with open('movies.csv', 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            for row in reader:
                m_id = row['movieId']
                full_title = row['title']
                genres = row['genres']
                
                match = re.search(r'\s*\((\d{4})\)\s*$', full_title)
                if match:
                    year = match.group(1)
                    title = re.sub(r'\s*\(\d{4}\)\s*$', '', full_title)
                else:
                    year = "NULL"
                    title = full_title
                
                out.write(f"INSERT INTO movies (id, title, year, genres) VALUES ({m_id}, {sql_str(title)}, {year}, {sql_str(genres)});\n")
    except FileNotFoundError:
        pass

    try:
        with open('ratings.csv', 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            for row in reader:
                out.write(f"INSERT INTO ratings (user_id, movie_id, rating, timestamp) VALUES ({row['userId']}, {row['movieId']}, {row['rating']}, {row['timestamp']});\n")
    except FileNotFoundError:
        pass

    try:
        with open('tags.csv', 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            for row in reader:
                out.write(f"INSERT INTO tags (user_id, movie_id, tag, timestamp) VALUES ({row['userId']}, {row['movieId']}, {sql_str(row['tag'])}, {row['timestamp']});\n")
    except FileNotFoundError:
        pass

    try:
        with open('users.txt', 'r', encoding='utf-8') as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                parts = line.split('|') if '|' in line else (line.split('\t') if '\t' in line else line.split(','))
                if parts[0].strip().lower() in ['id', 'userid', 'user_id']:
                    continue
                if len(parts) >= 6:
                    u_id, name, email, gender, reg_date, occupation = [p.strip() for p in parts[:6]]
                    out.write(f"INSERT INTO users (id, name, email, gender, register_date, occupation) VALUES ({u_id}, {sql_str(name)}, {sql_str(email)}, {sql_str(gender)}, {sql_str(reg_date)}, {sql_str(occupation)});\n")
    except FileNotFoundError:
        pass
