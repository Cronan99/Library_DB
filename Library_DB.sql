create database if not exists library_db;
use library_db;

drop table if exists book_genre;
drop table if exists book;
drop table if exists author;
drop table if exists publisher;
drop table if exists genre;

create table author
(
	author_id int primary key auto_increment,
	first_name varchar(50) not null,
	last_name varchar(50) not null,
	birth_date int
);

create table book
(
	book_id int primary key auto_increment,
	title varchar(100) not null,
	publication_date int,
	author_id int not null,
	publisher_id int not null
);

create table publisher
(
	publisher_id int primary key auto_increment,
	publisher_name varchar(100) not null,
	location varchar(100)
);

create table genre
(
	genre_id int primary key auto_increment,
	genre_name varchar(50)
);

create table book_genre
(
	book_id int not null,
	genre_id int not null
);

alter table book
	add constraint fk_author_id_author foreign key (author_id)
		references author(author_id);
	
alter table book
	add constraint fk_publisher_id_publisher foreign key (publisher_id)
		references publisher(publisher_id);
	
alter table book_genre
	add constraint fk_book_id_book foreign key (book_id)
		references book(book_id);

alter table book_genre
	add constraint fk_genre_id_genre foreign key (genre_id)
		references genre(genre_id);

insert into genre (genre_name)
	values("Fantasy"),
		("Adventure"),
		("Detective Fiction"),
		("Horror"),
		("Dystopian"),
		("Science Fiction"),
		("Thriller"),
		("Mystery"),
		("Classic");
	
insert into publisher (publisher_name, location)
	values("Penguin Books", "New York"),
		  ("HarperCollins", "London"),
		  ("Vintage Books", "San Francisco");
		 
insert into author (first_name, last_name, birth_date)
	values("J.K.", "Rowling", "1965"),
		  ("George", "Orwell", "1903"),
		  ("J.R.R.", "Tolkien", "1892"),
		  ("Mark", "Twain", "1835"),
		  ("Isaac", "Asimov", "1920"),
		  ("Arthur", "Conan Doyle", "1859"),
		  ("Agatha", "Christie", "1890"),
		  ("Philip", "K. Dick", "1928"),
		  ("Stephen", "King", "1947"),
		  ("Suzanne", "Collins", "1962"),
		  ("George", "R.R. Martin", "1948"),
		  ("Harlan", "Coben", "1962");
		 
INSERT INTO book (title, publication_date, author_id, publisher_id)
VALUES
    ("Harry Potter and the Philosopher's Stone", "1997", 
        (SELECT author_id FROM author WHERE first_name = "J.K." AND last_name = "Rowling"),
        (SELECT publisher_id FROM publisher WHERE publisher_name = "HarperCollins"));
INSERT INTO book (title, publication_date, author_id, publisher_id)
VALUES
    ("1984", "1949", 
        (SELECT author_id FROM author WHERE first_name = "George" AND last_name = "Orwell"),
        (SELECT publisher_id FROM publisher WHERE publisher_name = "Penguin Books"));
INSERT INTO book (title, publication_date, author_id, publisher_id)
VALUES        
    ("The Hobbit", "1937", 
        (SELECT author_id FROM author WHERE first_name = "J.R.R." AND last_name = "Tolkien"),
        (SELECT publisher_id FROM publisher WHERE publisher_name = "HarperCollins"));
INSERT INTO book (title, publication_date, author_id, publisher_id)
VALUES        
    ("The Adventures of Tom Sawyer", "1876", 
        (SELECT author_id FROM author WHERE first_name = "Mark" AND last_name = "Twain"),
        (SELECT publisher_id FROM publisher WHERE publisher_name = "Vintage Books"));
INSERT INTO book (title, publication_date, author_id, publisher_id)
VALUES        
    ("Foundation", "1951", 
        (SELECT author_id FROM author WHERE first_name = "Isaac" AND last_name = "Asimov"),
        (SELECT publisher_id FROM publisher WHERE publisher_name = "Penguin Books"));
INSERT INTO book (title, publication_date, author_id, publisher_id)
VALUES        
    ("The Hound of the Baskervilles", "1902", 
        (SELECT author_id FROM author WHERE first_name = "Arthur" AND last_name = "Conan Doyle"),
        (SELECT publisher_id FROM publisher WHERE publisher_name = "Penguin Books"));
INSERT INTO book (title, publication_date, author_id, publisher_id)
VALUES        
    ("Murder on the Orient Express", "1934", 
        (SELECT author_id FROM author WHERE first_name = "Agatha" AND last_name = "Christie"),
        (SELECT publisher_id FROM publisher WHERE publisher_name = "HarperCollins"));
INSERT INTO book (title, publication_date, author_id, publisher_id)
VALUES        
    ("Do Androids Dream of Electric Sheep?", "1968", 
        (SELECT author_id FROM author WHERE first_name = "Philip" AND last_name = "K. Dick"),
        (SELECT publisher_id FROM publisher WHERE publisher_name = "Vintage Books"));
INSERT INTO book (title, publication_date, author_id, publisher_id)
VALUES        
    ("The Shining", "1977", 
        (SELECT author_id FROM author WHERE first_name = "Stephen" AND last_name = "King"),
        (SELECT publisher_id FROM publisher WHERE publisher_name = "Vintage Books"));
INSERT INTO book (title, publication_date, author_id, publisher_id)
VALUES        
    ("The Hunger Games", "2008", 
        (SELECT author_id FROM author WHERE first_name = "Suzanne" AND last_name = "Collins"),
        (SELECT publisher_id FROM publisher WHERE publisher_name = "HarperCollins"));
INSERT INTO book (title, publication_date, author_id, publisher_id)
VALUES        
    ("A Game of Thrones", "1996", 
        (SELECT author_id FROM author WHERE first_name = "George" AND last_name = "R.R. Martin"),
        (SELECT publisher_id FROM publisher WHERE publisher_name = "HarperCollins"));
INSERT INTO book (title, publication_date, author_id, publisher_id)
VALUES        
    ("The Stranger", "2015", 
        (SELECT author_id FROM author WHERE first_name = "Harlan" AND last_name = "Coben"),
        (SELECT publisher_id FROM publisher WHERE publisher_name = "Penguin Books"));
INSERT INTO book (title, publication_date, author_id, publisher_id)
VALUES        
    ("The Woods", "2007", 
        (SELECT author_id FROM author WHERE first_name = "Harlan" AND last_name = "Coben"),
        (SELECT publisher_id FROM publisher WHERE publisher_name = "Penguin Books"));
       
insert into book_genre (book_id, genre_id)
	values
	("1", "1"),
	("2", "3"),
	("3", "1"),
	("4", "2"),
	("5", "6"),
	("6", "3"),
	("7", "3"),
	("8", "6"),
	("9", "1"),
	("9", "4"),
	("10", "2"),
	("10", "5"),
	("11", "1"),
	("12", "3"),
	("12", "7"),
	("13", "7"),
	("13", "8");