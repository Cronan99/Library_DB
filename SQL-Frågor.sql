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
#// Slår ihop författarens namn till ett under "författare" och visar det tillsammans med publication_date från books

select b.title, concat(a.first_name, " ", a.last_name) as "Författare",  b.publication_date
from book b 
inner join author a 
	on a.author_id = b.author_id;

#-Hämta alla böcker som publicerats efter det senaste publiceringsåret av böcker som kom ut före år 2000.
#// Tar alla böcker och jämför deras publication_date med en subquery som tar första släppta boken efter år 2000

select * from book
	where publication_date >
		(
		select min(publication_date)
		from book
		where publication_date > 2000
		);

#-Uppdatara författarens namn i tabellen.
#// Uppdaterar author_id 2 till first_name "George"
	
update author
	set first_name = "George"
	where author_id = "2";

#-Ta bort en bok från databasen
#// Först tas kopplingen i kopplingstabellen book_genre bort för att sedan boken i book tabellen ska kunna tas bort
#// Det eftersom book_id är en främmande nyckel i tabellen book_genre.

delete from book_genre
	where book_id = (select book_id from book where title = "The Stranger");

delete from book b 
	where b.title = "The Stranger";

#-Hämta alla böcker som publicerats efter år 2000 tillsammans med författarens namn, förlaget och genrer
#// Med concat slår jag ihop författarens för och efternamn, och med group_concat grupperas genrer som boken har
#// Jag använder join med relevanta tabeller och kopplar samman de med primärnycklarna som finns i de
#// Med where visar jag enbart böcker som kommit ut senare än år 2000
#// slutligen grupperar jag alla kolumner förutom bookgenres som aggregerats med olika värden.

select b.title, concat(a.first_name, " ", a.last_name) as Author, group_concat(g.genre_name) as bookgenres , p.publisher_name, b.publication_date
from book b 
join author a 
	on b.author_id = a.author_id 
join publisher p 
	on b.publisher_id = p.publisher_id 
join book_genre bg 
	on b.book_id = bg.book_id 
join genre g 
	on bg.genre_id = g.genre_id 
where b.publication_date > "2000"
group by b.title, author, p.publisher_name, b.publication_date;


#-Visa författarens fullständiga namn, titlarna på deras böcker och vilken genre böckerna tillhör
#// Likt tidigare använder jag concat() och group_concat() för att skapa nya kolumner för samafogade datan
#// Därefter väljer jag ut relevanta tabeller och kopplar de samman
#// Sedan grupperar jag efter id och sorterar efter författarnamn

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
#// Jag concat() författarens namn och använder count() på b.book_id för att räkna antalet böcker och kallar det för
#// book_by_author. Jag grupperar efter author_id eftersom det är den icke_aggregerade cellerna och sorterar efter
#// books_by_author med desc (fallande) ordning.

select concat(a.first_name, " ", a.last_name) as author, count(b.book_id) as books_by_author
from author a
inner join book b 
	on b.author_id = a.author_id
group by a.author_id
order by books_by_author desc;

#-Antalet böcker inom varje genre
#// Jag hämtar genre namn och använder count() för att räkna böcker ifrån de relevanta tabellerna
#// genre och book_genre och grupperar resultatet med genre namnet.

select g.genre_name, count(bg.book_id) as books_in_genre
from genre g 
join book_genre bg 
	on g.genre_id = bg.genre_id
group by g.genre_name;

#-Genomsnittligt antal böcker per författare som är publicerat efter år 2000

select concat(a2.first_name, " ", a2.last_name) as book_author, avg(book_count) as avarage_books
from (
select a.author_id, count(b.book_id) as book_count
from book b
join author a
on b.author_id = a.author_id
where b.publication_date > 2000
group by a.author_id
) as counted
join author a2
on counted.author_id = a2.author_id
group by book_author;

select avg(book_count) as avarage_books_after_year_2000_per_author
from (
select a.author_id, count(b.book_id) as book_count
from book b
join author a
on b.author_id = a.author_id
where b.publication_date > 2000
group by a.author_id
) as counted;

#-skapa en stored procedure som tar ett årtal som parameter och returnerar alla böcker som publicerats
#-efter detta år. Döp den till get_books_after_year
#// Jag använder delimiter för att definera ny kodavgränsare och sedan create procedure där jag väljer
#// namn för proceduren och vilken typ av parameter som den tar in.
#// Följande query tar titel och publiceringsdatum från book tabellen så länge datumet är högre än vad
#// som skickades in som parameter
#// Proceduren sparas under procedures i databasen och kan användas genom att använda sig av "call"

delimiter //

create procedure get_books_after_year(in selected_year int)
begin
	
	select b.title, b.publication_date
	from book b
		where b.publication_date > selected_year
	order by b.publication_date asc;
	
end //

delimiter ;

#-Skapa en view som visar varje författares fullständiga namn, bokens titel och publiceringsår.
#-Döp den till author_books
#// Jag skapar en view där jag conat() på namnet och tar med titel och datum från tabellerna
#// author och book. view:en sparas i databasen för att kunna använda den i framtiden
#// som en virituell tabell.

create view author_books as
	select concat(a.first_name, " ", a.last_name) as book_author, b.title, b.publication_date
	from author a 
	join book b 
		on a.author_id = b.author_id;