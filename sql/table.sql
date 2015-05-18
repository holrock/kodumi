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
