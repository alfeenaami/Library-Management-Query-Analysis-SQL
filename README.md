## Intelligent Library Data Management & Query Analytics

## Overview  
This project involves designing and analyzing a relational database to streamline library operations. It focuses on managing books, members, and loans while applying advanced SQL techniques to generate meaningful insights such as overdue tracking, borrow frequency, and member activity analysis.

## Database Schema  
The project operates on a schema containing three core tables:

Books: Stores book details including ID, title, author, genre, and publication date.

Members: Contains member information such as ID, name, contact details, and join date.

Loans: Records borrowing activity with loan dates, return dates, and loan status.

## Key SQL Implementation Details

Relational Joins: Combined books, members, and loans to generate detailed borrowing histories.

Aggregate Functions: Applied COUNT, AVG, MIN, MAX to calculate borrow statistics, overdue counts, and average loan durations.

Window Functions:

RANK(), DENSE_RANK(), ROW_NUMBER() used to build leaderboards for most borrowed books, active members, and popular genres.

Common Table Expressions (CTEs): Modular queries for overdue tracking, borrow counts, and identifying top members.

Subqueries: Compared borrow counts against averages to detect special cases (e.g., books borrowed more than average).

Data Cleaning: Converted inconsistent text dates into proper SQL DATE types and handled null values.

Grouping & Ordering: Used GROUP BY and ORDER BY for genre-level reporting and chronological loan analysis.

## Analytical Insights

Book Popularity: Identified top‑borrowed titles and genres.

Member Activity: Ranked members by borrow frequency and engagement.

Overdue Tracking: Generated reports on overdue loans for better management.

Borrow Trends: Compared individual activity against overall averages to highlight high‑volume borrowers.

## Technical Stack

Database Engine: MySQL / MariaDB

Scripting: Advanced SQL (joins, aggregates, window functions, CTEs, subqueries)

