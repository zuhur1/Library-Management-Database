-- Setting up environment
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET SQL_SAFE_UPDATES=0;

USE `Library_Management_Database`;

-- VIEWS --

# Current Loans View (using left join)
DROP VIEW IF EXISTS `CurrentLoans`;
CREATE VIEW CurrentLoans AS

SELECT
    l.LoanID,
    CONCAT(m.FirstName,' ',m.LastName) AS Member,
    b.Title,
    l.CheckoutDate,
    l.DueDate
FROM Loans l

LEFT JOIN Members m
ON l.MemberID = m.MemberID

LEFT JOIN Book_Copies bc
ON l.CopyID = bc.CopyID

LEFT JOIN Books b
ON bc.BookID = b.BookID

WHERE l.ReturnDate IS NULL;

SELECT * FROM CurrentLoans;

# Overdue Books 

DROP VIEW IF EXISTS `OverdueLoans`;
CREATE VIEW OverdueLoans AS

SELECT
    l.LoanID,
    CONCAT(m.FirstName, ' ', m.LastName) AS MemberName,
    b.Title,
    l.CheckoutDate,
    l.DueDate,
    DATEDIFF(CURDATE(), l.DueDate) AS DaysOverdue

FROM Loans l

JOIN Members m
ON l.MemberID = m.MemberID

JOIN Book_Copies bc
ON l.CopyID = bc.CopyID

JOIN Books b
ON bc.BookID = b.BookID

WHERE l.ReturnDate IS NULL
AND l.DueDate < CURDATE();

# Member Fine Summary
DROP VIEW IF EXISTS `MemberFineSummary`;
CREATE VIEW MemberFineSummary AS

SELECT
    m.MemberID,
    CONCAT(m.FirstName, ' ', m.LastName) AS MemberName,
    COUNT(f.FineID) AS TotalFines,
    SUM(f.FineAmount) AS TotalAmountOwed,
    SUM(CASE WHEN f.Paid = TRUE THEN f.FineAmount ELSE 0 END) AS AmountPaid,
    SUM(CASE WHEN f.Paid = FALSE THEN f.FineAmount ELSE 0 END) AS OutstandingBalance

FROM Members m

JOIN Loans l
ON m.MemberID = l.MemberID

JOIN Fines f
ON l.LoanID = f.LoanID

GROUP BY
    m.MemberID,
    m.FirstName,
    m.LastName;
