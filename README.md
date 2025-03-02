# 📚 Library Systems Management


![cdad3563c90bf642f93b3896ae004535](https://github.com/user-attachments/assets/4c14d349-6d90-4bd4-ab57-c4cc8eb801dc)


## 📌 Project Overview
**Project Title:**  Library System Management 

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

## 🎯 Project Objectives
1. **Set up the Library Management System Database:** Create and populate the database with tables for branches, employees, members, books, issued status, and return status.  
2. **CRUD Operations:** – Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select):** – Utilize CTAS to create new tables based on query results. 
4. **Advanced SQL Queries:** – Utilize CTAS to create new tables based on query results.

## 🛠️ Technology Stack
- **Data Preparation & Loading** - Microsoft Excel
- **DBMS:** PostgreSQL 
- **Query Language:** SQL
- **SQL Queries**: DDL, DML, Aggregations, Joins, Subqueries, Window Functions, Stored Procedures 

---

### Data Source
- [Kaggle](www.kaggle.com)

---

## Project Structure

### 1. Database Setup
- **Database Creation:** Created a database named `library_db`.  
- **Table Creation:** Established tables for `branches`, `employees`, `members`, `books`, `issued_status`, and `return_status`. Each table includes relevant columns and relationships.
- **Inserting Values Into Table:** Insert data and values inside each created Tables

### Database & Table Creation
```sql
  -- Create the database
CREATE DATABASE library_db;

-- Drop and recreate the "Branch" table
DROP TABLE IF EXISTS branch;
CREATE TABLE branch (
    branch_id VARCHAR(50) PRIMARY KEY,
    manager_id VARCHAR(50),
    branch_address VARCHAR(100),
    contact_no VARCHAR(15)
);

-- Drop and recreate the "Employee" table
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
    emp_id VARCHAR(50) PRIMARY KEY,
    emp_name VARCHAR(100),
    position VARCHAR(50),
    salary DECIMAL(10, 2),
    branch_id VARCHAR(50),
    FOREIGN KEY (branch_id) REFERENCES branch(branch_id)
);

-- Drop and recreate the "Members" table
DROP TABLE IF EXISTS members;
CREATE TABLE members (
    member_id VARCHAR(50) PRIMARY KEY,
    member_name VARCHAR(100),
    member_address VARCHAR(200),
    reg_date DATE
);

-- Drop and recreate the "Books" table
DROP TABLE IF EXISTS books;
CREATE TABLE books (
    isbn VARCHAR(50) PRIMARY KEY,
    book_title VARCHAR(100),
    category VARCHAR(50),
    rental_price DECIMAL(10, 2),
    status VARCHAR(20),
    author VARCHAR(100),
    publisher VARCHAR(100)
);

-- Drop and recreate the "IssueStatus" table
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status (
    issued_id VARCHAR(50) PRIMARY KEY,
    issued_member_id VARCHAR(50),
    issued_book_name VARCHAR(100),
    issued_date DATE,
    issued_book_isbn VARCHAR(50),
    issued_emp_id VARCHAR(50),
    FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
    FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn)
);

-- Drop and recreate the "ReturnStatus" table
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status (
    return_id VARCHAR(50) PRIMARY KEY,
    issued_id VARCHAR(50),
    return_book_name VARCHAR(100),
    return_date DATE,
    return_book_isbn VARCHAR(50),
    FOREIGN KEY (return_book_isbn) REFERENCES books(isbn)
);
```
### Inserting Values:
Insert data and values inside each created Tables
```sql
INSERT INTO members(member_id, member_name, member_address, reg_date) 
VALUES
('C101', 'Alice Johnson', '123 Main St', '2021-05-15'),
('C102', 'Bob Smith', '456 Elm St', '2021-06-20'),
('C103', 'Carol Davis', '789 Oak St', '2021-07-10'),
('C104', 'Dave Wilson', '567 Pine St', '2021-08-05'),
('C105', 'Eve Brown', '890 Maple St', '2021-09-25'),
('C106', 'Frank Thomas', '234 Cedar St', '2021-10-15'),
('C107', 'Grace Taylor', '345 Walnut St', '2021-11-20'),
('C108', 'Henry Anderson', '456 Birch St', '2021-12-10'),
('C109', 'Ivy Martinez', '567 Oak St', '2022-01-05'),
('C110', 'Jack Wilson', '678 Pine St', '2022-02-25'),
('C118', 'Sam', '133 Pine St', '2024-06-01'),    
('C119', 'John', '143 Main St', '2024-05-01');
SELECT * FROM members;


-- Insert values into each branch table
INSERT INTO branch(branch_id, manager_id, branch_address, contact_no) 
VALUES
('B001', 'E109', '123 Main St', '+919099988676'),
('B002', 'E109', '456 Elm St', '+919099988677'),
('B003', 'E109', '789 Oak St', '+919099988678'),
('B004', 'E110', '567 Pine St', '+919099988679'),
('B005', 'E110', '890 Maple St', '+919099988680');
SELECT * FROM branch;


-- Insert values into each employees table
INSERT INTO employees(emp_id, emp_name, position, salary, branch_id) 
VALUES
('E101', 'John Doe', 'Clerk', 60000.00, 'B001'),
('E102', 'Jane Smith', 'Clerk', 45000.00, 'B002'),
('E103', 'Mike Johnson', 'Librarian', 55000.00, 'B001'),
('E104', 'Emily Davis', 'Assistant', 40000.00, 'B001'),
('E105', 'Sarah Brown', 'Assistant', 42000.00, 'B001'),
('E106', 'Michelle Ramirez', 'Assistant', 43000.00, 'B001'),
('E107', 'Michael Thompson', 'Clerk', 62000.00, 'B005'),
('E108', 'Jessica Taylor', 'Clerk', 46000.00, 'B004'),
('E109', 'Daniel Anderson', 'Manager', 57000.00, 'B003'),
('E110', 'Laura Martinez', 'Manager', 41000.00, 'B005'),
('E111', 'Christopher Lee', 'Assistant', 65000.00, 'B005');
SELECT * FROM employees;


-- Inserting into books table 
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher) 
VALUES
('978-0-553-29698-2', 'The Catcher in the Rye', 'Classic', 7.00, 'yes', 'J.D. Salinger', 'Little, Brown and Company'),
('978-0-330-25864-8', 'Animal Farm', 'Classic', 5.50, 'yes', 'George Orwell', 'Penguin Books'),
('978-0-14-118776-1', 'One Hundred Years of Solitude', 'Literary Fiction', 6.50, 'yes', 'Gabriel Garcia Marquez', 'Penguin Books'),
('978-0-525-47535-5', 'The Great Gatsby', 'Classic', 8.00, 'yes', 'F. Scott Fitzgerald', 'Scribner'),
('978-0-141-44171-6', 'Jane Eyre', 'Classic', 4.00, 'yes', 'Charlotte Bronte', 'Penguin Classics'),
('978-0-307-37840-1', 'The Alchemist', 'Fiction', 2.50, 'yes', 'Paulo Coelho', 'HarperOne'),
('978-0-679-76489-8', 'Harry Potter and the Sorcerers Stone', 'Fantasy', 7.00, 'yes', 'J.K. Rowling', 'Scholastic'),
('978-0-7432-4722-4', 'The Da Vinci Code', 'Mystery', 8.00, 'yes', 'Dan Brown', 'Doubleday'),
('978-0-09-957807-9', 'A Game of Thrones', 'Fantasy', 7.50, 'yes', 'George R.R. Martin', 'Bantam'),
('978-0-393-05081-8', 'A Peoples History of the United States', 'History', 9.00, 'yes', 'Howard Zinn', 'Harper Perennial'),
('978-0-19-280551-1', 'The Guns of August', 'History', 7.00, 'yes', 'Barbara W. Tuchman', 'Oxford University Press'),
('978-0-307-58837-1', 'Sapiens: A Brief History of Humankind', 'History', 8.00, 'no', 'Yuval Noah Harari', 'Harper Perennial'),
('978-0-375-41398-8', 'The Diary of a Young Girl', 'History', 6.50, 'no', 'Anne Frank', 'Bantam'),
('978-0-14-044930-3', 'The Histories', 'History', 5.50, 'yes', 'Herodotus', 'Penguin Classics'),
('978-0-393-91257-8', 'Guns, Germs, and Steel: The Fates of Human Societies', 'History', 7.00, 'yes', 'Jared Diamond', 'W. W. Norton & Company'),
('978-0-7432-7357-1', '1491: New Revelations of the Americas Before Columbus', 'History', 6.50, 'no', 'Charles C. Mann', 'Vintage Books'),
('978-0-679-64115-3', '1984', 'Dystopian', 6.50, 'yes', 'George Orwell', 'Penguin Books'),
('978-0-14-143951-8', 'Pride and Prejudice', 'Classic', 5.00, 'yes', 'Jane Austen', 'Penguin Classics'),
('978-0-452-28240-7', 'Brave New World', 'Dystopian', 6.50, 'yes', 'Aldous Huxley', 'Harper Perennial'),
('978-0-670-81302-4', 'The Road', 'Dystopian', 7.00, 'yes', 'Cormac McCarthy', 'Knopf'),
('978-0-385-33312-0', 'The Shining', 'Horror', 6.00, 'yes', 'Stephen King', 'Doubleday'),
('978-0-451-52993-5', 'Fahrenheit 451', 'Dystopian', 5.50, 'yes', 'Ray Bradbury', 'Ballantine Books'),
('978-0-345-39180-3', 'Dune', 'Science Fiction', 8.50, 'yes', 'Frank Herbert', 'Ace'),
('978-0-375-50167-0', 'The Road', 'Dystopian', 7.00, 'yes', 'Cormac McCarthy', 'Vintage'),
('978-0-06-025492-6', 'Where the Wild Things Are', 'Children', 3.50, 'yes', 'Maurice Sendak', 'HarperCollins'),
('978-0-06-112241-5', 'The Kite Runner', 'Fiction', 5.50, 'yes', 'Khaled Hosseini', 'Riverhead Books'),
('978-0-06-440055-8', 'Charlotte''s Web', 'Children', 4.00, 'yes', 'E.B. White', 'Harper & Row'),
('978-0-679-77644-3', 'Beloved', 'Fiction', 6.50, 'yes', 'Toni Morrison', 'Knopf'),
('978-0-14-027526-3', 'A Tale of Two Cities', 'Classic', 4.50, 'yes', 'Charles Dickens', 'Penguin Books'),
('978-0-7434-7679-3', 'The Stand', 'Horror', 7.00, 'yes', 'Stephen King', 'Doubleday'),
('978-0-451-52994-2', 'Moby Dick', 'Classic', 6.50, 'yes', 'Herman Melville', 'Penguin Books'),
('978-0-06-112008-4', 'To Kill a Mockingbird', 'Classic', 5.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.'),
('978-0-553-57340-1', '1984', 'Dystopian', 6.50, 'yes', 'George Orwell', 'Penguin Books'),
('978-0-7432-4722-5', 'Angels & Demons', 'Mystery', 7.50, 'yes', 'Dan Brown', 'Doubleday'),
('978-0-7432-7356-4', 'The Hobbit', 'Fantasy', 7.00, 'yes', 'J.R.R. Tolkien', 'Houghton Mifflin Harcourt');


-- inserting into issued table
INSERT INTO issued_status(issued_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, issued_emp_id) 
VALUES
('IS106', 'C106', 'Animal Farm', '2024-03-10', '978-0-330-25864-8', 'E104'),
('IS107', 'C107', 'One Hundred Years of Solitude', '2024-03-11', '978-0-14-118776-1', 'E104'),
('IS108', 'C108', 'The Great Gatsby', '2024-03-12', '978-0-525-47535-5', 'E104'),
('IS109', 'C109', 'Jane Eyre', '2024-03-13', '978-0-141-44171-6', 'E105'),
('IS110', 'C110', 'The Alchemist', '2024-03-14', '978-0-307-37840-1', 'E105'),
('IS111', 'C109', 'Harry Potter and the Sorcerers Stone', '2024-03-15', '978-0-679-76489-8', 'E105'),
('IS112', 'C109', 'A Game of Thrones', '2024-03-16', '978-0-09-957807-9', 'E106'),
('IS113', 'C109', 'A Peoples History of the United States', '2024-03-17', '978-0-393-05081-8', 'E106'),
('IS114', 'C109', 'The Guns of August', '2024-03-18', '978-0-19-280551-1', 'E106'),
('IS115', 'C109', 'The Histories', '2024-03-19', '978-0-14-044930-3', 'E107'),
('IS116', 'C110', 'Guns, Germs, and Steel: The Fates of Human Societies', '2024-03-20', '978-0-393-91257-8', 'E107'),
('IS117', 'C110', '1984', '2024-03-21', '978-0-679-64115-3', 'E107'),
('IS118', 'C101', 'Pride and Prejudice', '2024-03-22', '978-0-14-143951-8', 'E108'),
('IS119', 'C110', 'Brave New World', '2024-03-23', '978-0-452-28240-7', 'E108'),
('IS120', 'C110', 'The Road', '2024-03-24', '978-0-670-81302-4', 'E108'),
('IS121', 'C102', 'The Shining', '2024-03-25', '978-0-385-33312-0', 'E109'),
('IS122', 'C102', 'Fahrenheit 451', '2024-03-26', '978-0-451-52993-5', 'E109'),
('IS123', 'C103', 'Dune', '2024-03-27', '978-0-345-39180-3', 'E109'),
('IS124', 'C104', 'Where the Wild Things Are', '2024-03-28', '978-0-06-025492-6', 'E110'),
('IS125', 'C105', 'The Kite Runner', '2024-03-29', '978-0-06-112241-5', 'E110'),
('IS126', 'C105', 'Charlotte''s Web', '2024-03-30', '978-0-06-440055-8', 'E110'),
('IS127', 'C105', 'Beloved', '2024-03-31', '978-0-679-77644-3', 'E110'),
('IS128', 'C105', 'A Tale of Two Cities', '2024-04-01', '978-0-14-027526-3', 'E110'),
('IS129', 'C105', 'The Stand', '2024-04-02', '978-0-7434-7679-3', 'E110'),
('IS130', 'C106', 'Moby Dick', '2024-04-03', '978-0-451-52994-2', 'E101'),
('IS131', 'C106', 'To Kill a Mockingbird', '2024-04-04', '978-0-06-112008-4', 'E101'),
('IS132', 'C106', 'The Hobbit', '2024-04-05', '978-0-7432-7356-4', 'E106'),
('IS133', 'C107', 'Angels & Demons', '2024-04-06', '978-0-7432-4722-5', 'E106'),
('IS134', 'C107', 'The Diary of a Young Girl', '2024-04-07', '978-0-375-41398-8', 'E106'),
('IS135', 'C107', 'Sapiens: A Brief History of Humankind', '2024-04-08', '978-0-307-58837-1', 'E108'),
('IS136', 'C107', '1491: New Revelations of the Americas Before Columbus', '2024-04-09', '978-0-7432-7357-1', 'E102'),
('IS137', 'C107', 'The Catcher in the Rye', '2024-04-10', '978-0-553-29698-2', 'E103'),
('IS138', 'C108', 'The Great Gatsby', '2024-04-11', '978-0-525-47535-5', 'E104'),
('IS139', 'C109', 'Harry Potter and the Sorcerers Stone', '2024-04-12', '978-0-679-76489-8', 'E105'),
('IS140', 'C110', 'Animal Farm', '2024-04-13', '978-0-330-25864-8', 'E102');


-- inserting into return table
INSERT INTO return_status(return_id, issued_id, return_date) 
VALUES
('RS101', 'IS101', '2023-06-06'),
('RS102', 'IS105', '2023-06-07'),
('RS103', 'IS103', '2023-08-07'),
('RS104', 'IS106', '2024-05-01'),
('RS105', 'IS107', '2024-05-03'),
('RS106', 'IS108', '2024-05-05'),
('RS107', 'IS109', '2024-05-07'),
('RS108', 'IS110', '2024-05-09'),
('RS109', 'IS111', '2024-05-11'),
('RS110', 'IS112', '2024-05-13'),
('RS111', 'IS113', '2024-05-15'),
('RS112', 'IS114', '2024-05-17'),
('RS113', 'IS115', '2024-05-19'),
('RS114', 'IS116', '2024-05-21'),
('RS115', 'IS117', '2024-05-23'),
('RS116', 'IS118', '2024-05-25'),
('RS117', 'IS119', '2024-05-27'),
('RS118', 'IS120', '2024-05-29');
SELECT * FROM issued_status;



SELECT * FROM branch
SELECT * FROM members
SELECT * FROM books;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM return_status
```
---

## 2. CRUD Operations
- **Create:** Inserted sample records into the books table.
- **Read:** Retrieved and displayed data from various tables.
- **Update:** Updated records in the employees table.
- **Delete:** Removed records from the members table as needed.

**Task 1. Create a New Book Record** -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
```sql
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
```
**Task 2:** Update an Existing Member's Address
```sql
UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103';
```
**Task 3:** Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
```sql
DELETE FROM issued_status
WHERE issued_id =   'IS121';
```
**Task 4:** Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101'
```
**Task 5:** List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
```sql
SELECT e.emp_name, 
	e.emp_id, 
	COUNT(i.*) AS number_of_books
FROM issued_status i
JOIN employees e
ON i.issued_emp_id = e.emp_id
GROUP BY e.emp_name, e.emp_id
HAVING COUNT(i.*) > 1
	ORDER BY number_of_books;
```
## 3. CTAS Create Table As Select
- **Task 6:** Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
```sql
CREATE TABLE book_issued_cnt AS
SELECT b.isbn isbn, 
	i.issued_book_name book_name, 
	COUNT (i.*)
FROM books b
JOIN issued_status i
ON b.isbn = i.issued_book_isbn
GROUP BY isbn, book_name
```
---

## Key Analysis & Findings
The following SQL queries were used to address specific questions:
#### 1. Find Total Rental Income by Category:
```sql
SELECT b.category category, 
	SUM (b.rental_price) total_sum, 
	COUNT (i.*) total_count
FROM issued_status i
JOIN books b
ON i.issued_book_isbn = b.isbn
GROUP BY category
ORDER BY total_sum
```
#### 2. List Members Who Registered in the Last 180 Days:
```sql
SELECT * 
	FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';
```
#### 3. List Employees with Their Branch Manager's Name and their branch details:
```sql
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
```
#### 4. Retrieve the List of Books Not Yet Returned:
```sql
SELECT * 
FROM issued_status as ist
LEFT JOIN return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;
```
#### 5. Insert New Values Into Table:
```sql
INSERT INTO issued_status(issued_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, issued_emp_id)
VALUES
('IS151', 'C118', 'The Catcher in the Rye', CURRENT_DATE - INTERVAL '24 days',  '978-0-553-29698-2', 'E108'),
('IS152', 'C119', 'The Catcher in the Rye', CURRENT_DATE - INTERVAL '13 days',  '978-0-553-29698-2', 'E109'),
('IS153', 'C106', 'Pride and Prejudice', CURRENT_DATE - INTERVAL '7 days',  '978-0-14-143951-8', 'E107'),
('IS154', 'C105', 'The Road', CURRENT_DATE - INTERVAL '32 days',  '978-0-375-50167-0', 'E101');
```
#### 6.  Adding new column in return_status
```sql
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
```
#### 7. Identify Members with Overdue Books: 
A query to identify members who have overdue books over a 30-day return period.
```sql
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
```
#### 8. Update Book Status on Return: 
A query to update the status of books in the books table to "Yes" 
```sql
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
```

#### 9. Branch Performance Report: 
A query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals
```sql
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
```
#### 10. CTAS: Create a Table of Active Members
Using the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.
```sql
CREATE TABLE active_members
	AS
SELECT m.member_id,
	m.member_name,
	i.issued_book_name
FROM members m
JOIN issued_status i
ON i.issued_member_id = m.member_id
WHERE issued_date > CURRENT_DATE - INTERVAL '2 month'
```
#### 11. Find Employees with the Most Book Issues Processed
A query to find the top 3 employees who have processed the most book issues. 
```sql
SELECT e.emp_name employee_name,
	b.*,
	COUNT (ist.issued_id) number_of_books
FROM issued_status ist
JOIN employees e
ON ist.issued_emp_id = e.emp_id
JOIN branch b
ON e.branch_id = b.branch_id
GROUP BY 1,2
```
#### 12. Identifying Members Issuing High-Risk Books
A query to identify members who have issued books more than twice with the status "damaged" in the books table. 
```sql
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
```
#### 13. Creating a Table As Select (CTAS) Objective:
A CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days, with each day's fine calculated at $0.50. 
```sql
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
```
#### 14. Creating a stored procedure to manage the status of books in a library system. 
A stored procedure that updates the status of a book in the library based on its issuance. 
The procedure should function as follows: The stored procedure should take the book_id as an input parameter. 
The procedure should first check if the book is available (status = 'yes'). 
If the book is available, it should be issued, and the status in the books table should be updated to 'no'. 
If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.
```sql
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
```
## Reports
- Database Schema: Detailed table structures and relationships.
- Data Analysis: Insights into book categories, employee salaries, member registration trends, and issued books.
- Summary Reports: Aggregated data on high-demand books and employee performance.

  
## Conclusion
This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.

---

## 📌 About Me
Hi, I'm Oluwatosin Amosu Bolaji, a Data Analyst skilled in SQL, Power BI, and Excel. I enjoy turning complex datasets into actionable insights through data visualization and business intelligence techniques.

- **🔹 Key Skills:** Data Analysis | SQL Queries | Power BI Dashboards | Data Cleaning | Reporting
- **🔹 Passionate About:** Data storytelling, problem-solving, and continuous learning

- **📫 Let's connect!**
- 🔗 [Linkedin](www.linkedin.com/in/oluwatosin-amosu-722b88141) | 🌐 [Portfolio](https://github.com/Tbrown1998?tab=repositories) | 📩 oluwabolaji60@gmail.com
