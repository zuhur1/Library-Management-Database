/* Environment Setup */
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET SQL_SAFE_UPDATES=0;

USE `Library_Management_Database`;

-- KPIS --

# KPI 1: Total Books

SELECT COUNT(*) AS TotalBooks FROM Books;

# KPI 2: Currently Checked Out Books

SELECT 
	COUNT(*) AS BooksCheckedOut
FROM Loans
WHERE ReturnDate IS NULL;

# KPI 3: How many Books are currently Available

SELECT
	COUNT(*) AS AvailableCopies
FROM Book_Copies
WHERE Status = 'Available';

# KPI 4: Members with Overdue Books

SELECT
    m.MemberID,
    CONCAT(m.FirstName, ' ', m.LastName) AS MemberName,
    COUNT(l.LoanID) AS OverdueBooks
FROM Members m
JOIN Loans l
    ON m.MemberID = l.MemberID
WHERE l.ReturnDate IS NULL
AND l.DueDate < CURDATE()
GROUP BY 
    m.MemberID,
    m.FirstName,
    m.LastName
ORDER BY OverdueBooks DESC;

# KPI 5: Overdue Books Rate

SELECT
ROUND(
    SUM(CASE 
        WHEN ReturnDate IS NULL 
        AND DueDate < CURDATE()
        THEN 1 ELSE 0 END)
    /
    COUNT(*) * 100,
2) AS OverdueRate
FROM Loans;

# KPI 6: Most Borrowed Books

SELECT
    b.Title,
    COUNT(l.LoanID) AS TimesBorrowed
FROM Books b
JOIN Book_Copies bc
ON b.BookID = bc.BookID
JOIN Loans l
ON bc.CopyID = l.CopyID
GROUP BY b.Title
ORDER BY TimesBorrowed DESC;

# KPI 7: Popular Genres

SELECT
    g.GenreName,
    COUNT(l.LoanID) AS BorrowCount
FROM Genres g
JOIN Books b
ON g.GenreID = b.GenreID
JOIN Book_Copies bc
ON b.BookID = bc.BookID
JOIN Loans l
ON bc.CopyID = l.CopyID
GROUP BY g.GenreName
ORDER BY BorrowCount DESC;