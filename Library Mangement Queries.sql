



-- 															PROJECT TASKS
-- Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

-- Update an Existing Member's Address

UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103';

-- Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

DELETE FROM issued_status
WHERE issued_id =   'IS121';

-- Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT * FROM issued_status
WHERE issued_emp_id = 'E101'

-- List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT e.emp_name, 
	e.emp_id, 
	COUNT(i.*) AS number_of_books
FROM issued_status i
JOIN employees e
ON i.issued_emp_id = e.emp_id
GROUP BY e.emp_name, e.emp_id
HAVING COUNT(i.*) > 1
	ORDER BY number_of_books;

-- Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

CREATE TABLE book_issued_cnt AS
SELECT b.isbn isbn, 
	i.issued_book_name book_name, 
	COUNT (i.*)
FROM books b
JOIN issued_status i
ON b.isbn = i.issued_book_isbn
GROUP BY isbn, book_name

-- 												Data Analysis & Findings
-- Retrieve All Books in the "Classic" Category

SELECT * FROM books
WHERE category = 'Classic';

-- Find Total Rental Income by Category:

SELECT b.category category, 
	SUM (b.rental_price) total_sum, 
	COUNT (i.*) total_count
FROM issued_status i
JOIN books b
ON i.issued_book_isbn = b.isbn
GROUP BY category
ORDER BY total_sum

-- List Members Who Registered in the Last 180 Days:

SELECT * 
	FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';

-- List Employees with Their Branch Manager's Name and their branch details:

SELECT e.emp_id Employee_id, 
	e.emp_name Employee_name, 
	b.manager_id manager_id,
	b.branch_address address
FROM employees e
JOIN branch b
ON e.branch_id = b.branch_id

SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager
FROM employees as e1
JOIN 
branch as b
ON e1.branch_id = b.branch_id    
JOIN
employees as e2
ON e2.emp_id = b.manager_id

-- Create a Table of Books with Rental Price Above a Certain Threshold:

CREATE TABLE expensive_books AS
SELECT * FROM books
WHERE rental_price > 7.00;

-- Retrieve the List of Books Not Yet Returned

SELECT * 
FROM issued_status as ist
LEFT JOIN return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;

-- INSERT INTO book_issued in last 30 days
-- SELECT * from employees;
-- SELECT * from books;
-- SELECT * from members;
-- SELECT * from issued_status


INSERT INTO issued_status(issued_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, issued_emp_id)
VALUES
('IS151', 'C118', 'The Catcher in the Rye', CURRENT_DATE - INTERVAL '24 days',  '978-0-553-29698-2', 'E108'),
('IS152', 'C119', 'The Catcher in the Rye', CURRENT_DATE - INTERVAL '13 days',  '978-0-553-29698-2', 'E109'),
('IS153', 'C106', 'Pride and Prejudice', CURRENT_DATE - INTERVAL '7 days',  '978-0-14-143951-8', 'E107'),
('IS154', 'C105', 'The Road', CURRENT_DATE - INTERVAL '32 days',  '978-0-375-50167-0', 'E101');

-- Adding new column in return_status

ALTER TABLE return_status
ADD Column book_quality VARCHAR(15) DEFAULT('Good');

UPDATE return_status
SET book_quality = 'Damaged'
WHERE issued_id 
    IN ('IS112', 'IS117', 'IS118');
SELECT * FROM return_status;


ALTER TABLE return_status
ADD CONSTRAINT FK_Orders_Customers
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);

/* Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). 
Display the member's_id, member's name, book title, issue date, and days overdue.
*/

SELECT m.member_id, 
	m.member_name, 
	i.issued_book_name, 
	i.issued_date,
	CURRENT_DATE - i.issued_date days_overdue
FROM members m
JOIN issued_status i
ON m.member_id = i.issued_member_id
LEFT JOIN return_status r
ON i.issued_id = r.issued_id
WHERE r.return_date IS NULL
	    AND
    (CURRENT_DATE - i.issued_date) > 30
ORDER BY days_overdue;

/* Update Book Status on Return:
Write a query to update the status of books in the books table to "Yes" 
when they are returned (based on entries in the return_status table).
*/

CREATE OR REPLACE PROCEDURE add_return_records(p_return_id VARCHAR(10), p_issued_id VARCHAR(10), p_book_quality VARCHAR(10))
LANGUAGE plpgsql
AS $$

DECLARE
    v_isbn VARCHAR(50);
    v_book_name VARCHAR(80);
    
BEGIN
    -- all your logic and code
    -- inserting into returns based on users input
    INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
    VALUES
    (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

    SELECT 
        issued_book_isbn,
        issued_book_name
        INTO
        v_isbn,
        v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    RAISE NOTICE 'Thank you for returning the book: %', v_book_name;
    
END;
$$


-- Testing FUNCTION add_return_records

issued_id = IS135
ISBN = WHERE isbn = '978-0-307-58837-1'

SELECT * FROM books
WHERE isbn = '978-0-307-58837-1';

SELECT * FROM issued_status
WHERE issued_book_isbn = '978-0-307-58837-1';

SELECT * FROM return_status
WHERE issued_id = 'IS135';

-- calling function 
CALL add_return_records('RS138', 'IS135', 'Good');

-- calling function 
CALL add_return_records('RS148', 'IS140', 'Good');

/* Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of books issued, 
the number of books returned, and the total revenue generated from book rentals.
*/

CREATE TABLE branch_performance
	AS
SELECT b.branch_id branch_id,
	b.branch_address branch_address,
	b.manager_id manager_id,
	COUNT (i.issued_id) total_issued,
	COUNT (r.return_id) total_returned,
	SUM (bk.rental_price) total_revenue
FROM issued_status i
JOIN employees e
	ON i.issued_emp_id = e.emp_id
JOIN branch b
	ON e.branch_id = b.branch_id
LEFT JOIN return_status r
	ON i.issued_id = r.issued_id
JOIN books bk
    ON i.issued_book_isbn = bk.isbn
GROUP BY 1,2,3;

SELECT * FROM Branch_performance

/* CTAS: Create a Table of Active Members
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members 
who have issued at least one book in the last 2 months.
*/

CREATE TABLE active_members
	AS
SELECT m.member_id,
	m.member_name,
	i.issued_book_name
FROM members m
JOIN issued_status i
ON i.issued_member_id = m.member_id
WHERE issued_date > CURRENT_DATE - INTERVAL '2 month'

/* Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues. 
Display the employee name, number of books processed, and their branch.
*/


SELECT e.emp_name employee_name,
	b.*,
	COUNT (ist.issued_id) number_of_books
FROM issued_status ist
JOIN employees e
ON ist.issued_emp_id = e.emp_id
JOIN branch b
ON e.branch_id = b.branch_id
GROUP BY 1,2

/* Identify Members Issuing High-Risk Books
Write a query to identify members who have issued books more than twice with the status "damaged" in the books table. 
Display the member name, book title, and the number of times they've issued damaged books.
*/

SELECT 
    m.member_name AS member_name,
    b.book_title AS book_title,
    COUNT(ist.issued_id) AS damaged_count
FROM issued_status ist
JOIN members m
    ON ist.issued_member_id = m.member_id
JOIN books b
    ON ist.issued_book_isbn = b.isbn
WHERE b.status = 'damaged'
GROUP BY m.member_name, b.book_title
HAVING COUNT(ist.issued_id) > 2;

/*  Create Table As Select (CTAS) Objective: Create a CTAS (Create Table As Select) query 
to identify overdue books and calculate fines.
Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. 
The table should include: The number of overdue books. The total fines, with each day's fine calculated at $0.50. 
The number of books issued by each member. 
The resulting table should show: Member ID Number of overdue books Total fines
*/

CREATE TABLE overdue_fines AS
SELECT member_id, total_issued_books, overdue_books, overdue_books * 0.5 total_fines
FROM (SELECT m.member_id,
    COUNT(CASE 
            WHEN CURRENT_DATE > (ist.issued_date + INTERVAL '30 days') AND rs.return_id IS NULL 
            THEN 1 
        END) AS overdue_books,
    COUNT(ist.issued_id) AS total_issued_books
FROM issued_status ist
JOIN members m
    ON ist.issued_member_id = m.member_id
LEFT JOIN return_status rs
    ON ist.issued_id = rs.issued_id
GROUP BY m.member_id
	ORDER BY 2) sub

/* Create a stored procedure to manage the status of books in a library system. 
Description: Write a stored procedure that updates the status of a book in the library based on its issuance. 
The procedure should function as follows: The stored procedure should take the book_id as an input parameter. 
The procedure should first check if the book is available (status = 'yes'). 
If the book is available, it should be issued, and the status in the books table should be updated to 'no'. 
If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.
*/

CREATE OR REPLACE PROCEDURE issue_book(p_issued_id VARCHAR(10), p_issued_member_id VARCHAR(30), p_issued_book_isbn VARCHAR(30), p_issued_emp_id VARCHAR(10))
LANGUAGE plpgsql
AS $$

DECLARE
-- all the variabable
    v_status VARCHAR(10);

BEGIN
-- all the code
    -- checking if book is available 'yes'
    SELECT 
        status 
        INTO
        v_status
    FROM books
    WHERE isbn = p_issued_book_isbn;

    IF v_status = 'yes' THEN

        INSERT INTO issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
        VALUES
        (p_issued_id, p_issued_member_id, CURRENT_DATE, p_issued_book_isbn, p_issued_emp_id);

        UPDATE books
            SET status = 'no'
        WHERE isbn = p_issued_book_isbn;

        RAISE NOTICE 'Book records added successfully for book isbn : %', p_issued_book_isbn;


    ELSE
        RAISE NOTICE 'Sorry to inform you the book you have requested is unavailable book_isbn: %', p_issued_book_isbn;
    END IF;
END;
$$

-- Testing The function
SELECT * FROM books;
-- "978-0-553-29698-2" -- yes
-- "978-0-375-41398-8" -- no
SELECT * FROM issued_status;

CALL issue_book('IS155', 'C108', '978-0-553-29698-2', 'E104');
CALL issue_book('IS156', 'C108', '978-0-375-41398-8', 'E104');

SELECT * FROM books
WHERE isbn = '978-0-375-41398-8'

































