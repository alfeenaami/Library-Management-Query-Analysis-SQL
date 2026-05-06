use octdemo;
select * from books;

select * from members;
update members set join_date= str_to_date(join_date,'%m/%d/%Y');
alter table members modify join_date date;

select * from loans;
update loans set loan_date= str_to_date(loan_date,"%d/%m/%Y");
alter table loans modify loan_date date;

update loans set due_date= str_to_date(due_date,"%m/%d/%Y");
alter table loans modify due_date date;

-- Retrieve all books ordered by published_year from newest to oldest.
select * from books order by published_year desc;

-- List all members ordered by join_date in ascending order.
select * from members order by join_date asc;

-- Get all loans ordered by due_date, showing the top 3  earliest due date first.
select * from loans order by due_date asc limit 3 ;

-- Retrieve book title, author, genre ordered alphabetically by title.
select title,author,genre from books order by title asc;

-- List all overdue loans ordered by loan_date descending.
select * from loans where status="overdue" order by loan_date desc;

-- Count the number of books in each genre.
select genre,count(*) from books group by genre;

-- Find genres that have more than 3 books.
select genre,count(*) as book_count from books group by genre having book_count>3;

-- Count the number of loans made by each member.
select member_id ,count(*) as loan_count from loans group by member_id;

-- Find members who have made more than 2 loans.
select member_id, count(*) as loan_count from loans group by member_id having loan_count>2;

-- Count the number of loans for each status (borrowed, returned, overdue).
select status, COUNT(*) as loan_count from loans group by status;

-- Find genres where the average published year is after 1990.
select genre, round(AVG(published_year),2) as avg_year from books group by  genre having avg_year> 1990;

-- Find the total number of books in the library.
select count(*) from books;

-- Find the oldest and newest published book.
select min(published_year) as oldest ,max(published_year) as newest from books;

-- Find the maximum and minimum available copies among all books.
SELECT MAX(available_copies) AS max_available,
       MIN(available_copies) AS min_available
FROM books;

-- Calculate the average number of copies per book.
SELECT AVG(total_copies) AS avg_copies
FROM books;

-- Count how many loans are currently overdue.
SELECT COUNT(*) AS overdue_loans
FROM loans
WHERE status = 'overdue';

-- Find the average total_copies per genre.
SELECT genre, AVG(total_copies) AS avg_total_copies
FROM books
GROUP BY genre;

-- List all loan records with member full name and book title.
select l.loan_id, m.first_name, m.last_name, b.title
from loans l
join members m on l.member_id = m.member_id
join books b on l.book_id = b.book_id;
 
-- Find all members who have borrowed books, showing member name + book title + loan status. 
select m.first_name, m.last_name, b.title, l.status
from loans l
join members m on l.member_id = m.member_id
join books b on l.book_id = b.book_id;

-- List all books along with the number of times they have been borrowed.
select l.loan_id, m.first_name, m.last_name, b.title
from loans l
join members m on l.member_id = m.member_id
join books b on l.book_id = b.book_id;

-- Find all overdue loans with member name, book title, and due date.
select m.first_name, m.last_name, b.title, l.due_date
from loans l
join members m on l.member_id = m.member_id
join books b on l.book_id = b.book_id
where l.status = 'overdue';

-- List members who borrowed books in the Fantasy genre.
select distinct m.first_name, m.last_name
from loans l
join members m on l.member_id = m.member_id
join books b on l.book_id = b.book_id
where b.genre = 'fantasy';

-- Find members who borrowed books and returned them late (return_date > due_date).
select m.first_name, m.last_name, b.title, l.loan_date, l.due_date, l.return_date
from loans l
join members m on l.member_id = m.member_id
join books b on l.book_id = b.book_id
where l.status = 'returned' and l.return_date > l.due_date;

-- Rank books by number of times borrowed 
select b.title, count(l.loan_id) as times_borrowed,
rank() over (order by count(l.loan_id) desc) as book_rank
from loans l
join books b on l.book_id = b.book_id
group by b.title;

-- Rank members by number of loans taken.
select m.first_name, m.last_name, count(l.loan_id) as loan_count,
       rank() over (order by count(l.loan_id) desc) as member_rank
from loans l
join members m on l.member_id = m.member_id
group by m.first_name, m.last_name;

-- Find the top 3 most borrowed books using RANK().
select b.title, count(l.loan_id) as times_borrowed,
       rank() over (order by count(l.loan_id) desc) as book_rank
from loans l
join books b on l.book_id = b.book_id
group by b.title
having book_rank <= 3;


-- Use ROW_NUMBER() to assign a unique number to each loan per member ordered by loan_date.
select m.first_name, m.last_name, l.loan_id, l.loan_date,
       row_number() over (partition by m.member_id order by l.loan_date) as loan_number
from loans l
join members m on l.member_id = m.member_id;

-- Use DENSE_RANK() to rank genres by total number of books.
select genre, count(*) as book_count,
dense_rank() over (order by count(*) desc) as genre_rank
from books
group by genre;

-- Use a CTE to find all members who have overdue loans.
with overdue_loans as (
    select member_id
    from loans
    where status = 'overdue'
)
select m.first_name, m.last_name
from overdue_loans o
join members m on o.member_id = m.member_id;

-- Use a CTE to calculate each book's borrow count, then filter books borrowed more than 2 times.
with book_borrow_count as (
    select book_id, count(*) as borrow_count
    from loans
    group by book_id
)
select b.title, borrow_count
from book_borrow_count bc
join books b on bc.book_id = b.book_id
where borrow_count > 2;

-- Use a CTE to find the top 5 most active members by number of loans.
with member_loans as (
    select member_id, count(*) as loan_count
    from loans
    group by member_id
)
select m.first_name, m.last_name, ml.loan_count
from member_loans ml
join members m on ml.member_id = m.member_id
order by ml.loan_count desc
limit 5;
-- Use a CTE to find books never borrowed.
with borrowed_books as (
    select distinct book_id
    from loans
)
select b.title
from books b
left join borrowed_books bb on b.book_id = bb.book_id
where bb.book_id is null;

-- Use a CTE with JOIN to list overdue members along with their book titles and how many days overdue
with overdue_loans as (
    select loan_id, member_id, book_id, due_date
    from loans
    where status = 'overdue'
)
select m.first_name, m.last_name, b.title,
       datediff(curdate(), o.due_date) as days_overdue
from overdue_loans o
join members m on o.member_id = m.member_id
join books b on o.book_id = b.book_id;











