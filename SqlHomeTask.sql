-- TASK 1
-- CREATE DATABSE BookstoreDB
CREATE DATABASE BookstoreDB;

USE BookstoreDB;

-- Authors Table
CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY,
    AuthorName VARCHAR(100)
);

-- Categories Table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50)
);

-- Book Table
CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(100),
    AuthorID INT,
    CategoryID INT,
    Price DECIMAL(10,2),
    StockQuantity INT,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    OrderDate DATE
);

-- OrderDetails Table
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    BookID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

-- Task 2
-- Insert Data in Auther Table 
INSERT INTO Authors (AuthorID, AuthorName)
VALUES 
(1,'Auth A'),
(2,'Auth B'),
(3,'Auth C'),
(4,'Auth D'),
(5,'Auth E');

-- Insert Data in Categories Table 
INSERT INTO Categories (CategoryID, CategoryName) VALUES
(1,'Fiction'),
(2,'Science'),
(3,'History'),
(4,'Philosophy'),
(5,'Technology');

-- Insert Data in Books Table 
INSERT INTO Books (BookID, Title, AuthorID, CategoryID, Price, StockQuantity) VALUES
(1,'Book 1', 1, 1, 200, 10),
(2,'Book 2', 2, 2, 150, 5),
(3,'Book 3', 3, 3, 300, 0),
(4,'Book 4', 4, 4, 175, 7),
(5,'Book 5', 5, 5, 200, 2),
(6,'Book 6', 1, 2, 250, 8),
(7,'Book 7', 2, 1, 300, 0),
(8,'Book 8', 3, 4, 500, 0),
(9,'Book 9', 4, 3, 150, 4),
(10,'Book 10', 5, 5, 200, 6);

-- Insert Data in Orders Table 
INSERT INTO Orders (OrderID,CustomerName, OrderDate) VALUES
(1,'Customer X', '2024-12-01'),
(2,'Customer Y', '2024-12-02'),
(3,'Customer Z', '2024-12-03');

-- Insert Data in OrderDetails Table
INSERT INTO OrderDetails (OrderDetailID, OrderID, BookID, Quantity)
VALUES 
(1, 1, 1, 2),
(2, 1, 2, 1),
(3, 2, 3, 1),
(4, 3, 4, 2),
(5, 1, 5, 1),
(6, 3, 9, 3),
(7, 2, 6, 2),
(8, 2, 7, 2);

-- Task 3
-- Basic Queries 

-- Retrieve all books along with their authors and categories
SELECT b.Title, a.AuthorName, c.CategoryName
FROM Books b
JOIN Authors a ON b.AuthorID = a.AuthorID
JOIN Categories c ON b.CategoryID = c.CategoryID;

-- Find books that are out of stock (StockQuantity = 0)
SELECT Title, StockQuantity
FROM Books
WHERE StockQuantity = 0;


-- Aggregate Function
-- Find the total revenue generated from all orders
SELECT SUM(b.Price * od.Quantity) AS TotalRevenue
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Books b ON od.BookID = b.BookID;

-- Get the number of books available in each category
SELECT c.CategoryName, COUNT(*) AS BookCount
FROM Books b
JOIN Categories c ON b.CategoryID = c.CategoryID
GROUP BY c.CategoryName;


-- Joins
-- List all orders along with customer name, order date, book titles, and quantity ordered
SELECT o.CustomerName, o.OrderDate, b.Title, od.Quantity
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Books b ON od.BookID = b.BookID
ORDER BY o.OrderID;

-- Subqueries
-- Find the most expensive book in the Science Fiction category
SELECT TOP 1 b.Title, b.Price
FROM Books b
WHERE b.CategoryID = 2
ORDER BY b.Price DESC;

-- List customers who have ordered more than 5 books in a single order
SELECT DISTINCT o.CustomerName
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY o.CustomerName
HAVING COUNT(*) > 5;


-- Advanced Queries
-- Identify authors whose books have generated revenue exceeding $500
SELECT DISTINCT a.AuthorName, SUM(b.Price * od.Quantity) AS Revenue
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Books b ON od.BookID = b.BookID
JOIN Authors a ON b.AuthorID = a.AuthorID
GROUP BY a.AuthorName
HAVING SUM(b.Price * od.Quantity) > 500;

-- Calculate the stock value (price × stock quantity) of all books and list the top 3 books by stock value
SELECT TOP 3 b.Title, b.Price * b.StockQuantity AS StockValue
FROM Books b
ORDER BY b.Price * b.StockQuantity DESC;
GO

-- Stored Procedure
-- Write a stored procedure GetBooksByAuthor that accepts an AuthorID as input and returns all books by that auther

CREATE PROCEDURE GetBooksByAuthor @AuthorID INT
AS
BEGIN
    SELECT b.Title, b.Price, b.StockQuantity
    FROM Books b
    WHERE b.AuthorID = @AuthorID;
END
EXEC GetBooksByAuthor 1; 
GO

-- View
-- Create view TopSellingBooks that lists the top 5 books based on total quantity sold.
CREATE VIEW TopSellingBooks AS
SELECT TOP 5 b.Title, SUM(od.Quantity) AS TotalSold
FROM Books b
JOIN OrderDetails od ON b.BookID = od.BookID
GROUP BY b.Title
ORDER BY TotalSold DESC;
GO

SELECT * FROM TopSellingBooks;

-- Indexes
-- Index on Books Table on Title Column 
CREATE INDEX idx_Books_Title ON Books(Title);


