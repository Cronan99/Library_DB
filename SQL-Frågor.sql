use library_db;

#SQL-frågor:

#-Hämta alla böcker som publicerats före år 1950.
#// Jämför alla år med 1950 och visar alla böcker med år mindre än 1950.

select * from book
	where publication_date < 1950;

#-Hämta alla genrer som innehåller ordet "Classic".
#// Hämtar alla genrer som har classis någonstans i namnet

select * from genre g
	where genre_name like("%Classic%");

#-Hämta alla böcker av en specifik författare, t.ex. "George Orwell"
#// Joinar boktabellen och författartabellen där author_id matchar på platsen där förnamn och efternamn matchar "sökningen"

select * from book b
inner join author a 
	on b.author_id = a.author_id 
where a.first_name = "George" and a.last_name = "Orwell";

#-Hämta alla böcker som publicerats av ett specifikt förlag och ordna de efter puliceringsår
#// Joinar publisher och böcker och hämtar enbart med specifikt namn och ordnar listan efter ökande publication_date

select * from book b
inner join publisher p 
	on p.publisher_id = b.publisher_id 
where p.publisher_name = "HarperCollins"
order by b.publication_date asc;

#-Hämta alla böcker tillsammans med deras författare och publiceringsår


select b.title, concat(a.first_name, " ", a.last_name) as "Författare",  b.publication_date
from book b 
inner join author a 
	on a.author_id = b.author_id;

#-Hämta alla böcker som publicerats efter det senaste publiceringsåret av böcker som kom ut före år 2000.

select * from book
	where publication_date >
		(
		select min(publication_date)
		from book
		where publication_date > 2000
		);

#-Uppdatara författarens namn i tabellen.
	
update author
	set first_name = "George"
	where author_id = "2";

#-Ta bort en bok från databasen

delete from book_genre
	where book_id = (select book_id from book where title = "The Stranger");

delete from book b 
	where b.title = "The Stranger";

#-Hämta alla böcker som publicerats efter år 2000 tillsammans med författarens namn, förlaget och genrer

select b.title, concat(a.first_name, " ", a.last_name) as Author, g.genre_name, p.publisher_name, b.publication_date
from book b 
join author a 
	on b.author_id = a.author_id 
join publisher p 
	on b.publisher_id = p.publisher_id 
join book_genre bg 
	on b.book_id = bg.book_id 
join genre g 
	on bg.genre_id = g.genre_id 
where b.publication_date > "2000";

#-Visa författarens fullständiga namn, titlarna på deras böcker och vilken genre böckerna tillhör

select concat(a.first_name, " ", a.last_name) as author, b.title,
group_concat(g.genre_name order by g.genre_name separator ", ") as genre
from author a 
join book b 
	on b.author_id = a.author_id 
join book_genre bg 
	on bg.book_id = b.book_id 
join genre g 
	on bg.genre_id = g.genre_id
group by a.author_id, b.book_id
order by author;

#-Antalet böcker varje författare har skrivit, sortera i fallande ordning

select concat(a.first_name, " ", a.last_name) as author, count(b.book_id) as books_by_author
from author a
inner join book b 
	on b.author_id = a.author_id
group by a.author_id
order by books_by_author desc;

#-Antalet böcker inom varje genre

select g.genre_name, count(bg.book_id) as books_in_genre
from genre g 
join book_genre bg 
	on g.genre_id = bg.genre_id
group by g.genre_name;

#-Genomsnittligt antal böcker per författare som är publicerat efter år 2000

select avg(book_count) as avarage_books
from (
select count(b.book_id) as book_count
from book b
)


#-skapa en stored procedure som tar ett årtal som parameter och returnerar alla böcker som publicerats
#-efter detta år. Döp den till get_books_after_year

#-Skapa en view som visar varje författares fullständiga namn, bokens titel och publiceringsår.
#-Döp den till author_books