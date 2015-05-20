create table if not exists books
(
  id integer primary key autoincrement,
  title text not null,
  subtitle text,
  publisher_id integer
);

create table if not exists publishers
(
  id integer primary key autoincrement,
  name text not null,
  url text not null
);

create table if not exists authors
(
  id integer primary key autoincrement,
  name text not null
);

create table if not exists book_author
(
  book_id integer not null,
  author_id integer not null,
  primary key (book_id, author_id)
);

create table if not exists user
(
  id integer primary key autoincrement,
  account_name text not null,
  name text not null
);

create table if not exists reviews
(
  id integer primary key autoincrement,
  book_id integer not null,
  user_id integer not null,
  score integer not null,
  body text,
  update_at date
);
