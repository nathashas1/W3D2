PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER NOT NULL PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
  -- FOREIGN KEY (ques_id) REFERENCES questions(id)
);


CREATE TABLE questions (
  id INTEGER NOT NULL PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id)
);


CREATE TABLE question_follows (
  id INTEGER NOT NULL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER NOT NULL PRIMARY KEY,
  body TEXT NOT NULL,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)

);

CREATE TABLE question_likes (
  id INTEGER NOT NULL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);


INSERT INTO
  users(fname,lname)
VALUES
("Nathasha","Surendran"),
("Jin", "Wu"),
("Ronil", "Bhatia");

INSERT INTO
  questions(title, body, user_id)
VALUES
("Hello World", "We are the A/a student", 1),
("Who am I?", "I am Jin the A/a student", 2),
("Question 3?", "No one likes this question", 3);

INSERT INTO
  replies(body,question_id,user_id)
VALUES
("Good Question", 1, 1),
("2nd answer", 1, 1),
("Bad Question", 2, 2);

INSERT INTO
  question_likes(question_id, user_id)
VALUES
(1, 2),
(2, 1),
(1, 3);


INSERT INTO
  question_follows(question_id, user_id)
VALUES
(1, 2),
(2, 1),
(1, 3);
