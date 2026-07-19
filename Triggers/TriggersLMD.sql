-- Setting up environment
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;

USE `Library_Management_Database`;

-- Triggers --
# Trigger 1: Marks overdue books as "Lost" after 30 days
/* the event that triggers this action is anytime there is an update to the loans table */
DELIMITER //
CREATE TRIGGER AFTER_UPDATE_Loans_MarkBookLost
AFTER UPDATE ON Loans
FOR EACH ROW
BEGIN
IF NEW.ReturnDate IS NULL 
AND DATEDIFF(CURDATE(), NEW.DueDate) > 30 THEN
UPDATE Book_Copies
SET Status = 'Lost'
WHERE CopyID = NEW.CopyID;
END IF;
END //
DELIMITER ;


DELIMITER //

#Trigger 2: Check how much member owes after each fine, if they owe more than $40, they are now deliquent status
CREATE TRIGGER AFTER_INSERT_Fines_CheckMemberFines
AFTER INSERT ON Fines
FOR EACH ROW
BEGIN
DECLARE total_unpaid_fines DECIMAL(6,2);
DECLARE member_number INT;

-- 1. determine the member who received the fine
SELECT MemberID
INTO member_number
FROM Loans
WHERE LoanID = NEW.LoanID;

-- 2. calculate unpaid fines
SELECT SUM(FineAmount)
INTO total_unpaid_fines
FROM Fines f
JOIN Loans l
ON f.LoanID = l.LoanID
WHERE l.MemberID = member_number
AND f.Paid = FALSE;

-- 3. Update member status
IF total_unpaid_fines >= 40 THEN
UPDATE Members
SET AccountStatus = 'Delinquent'
WHERE MemberID = member_number;

END IF;

END //

DELIMITER ;

# Trigger 3: Check if a member is deliqenut before allowing them to loan a book

DELIMITER //

CREATE TRIGGER BEFORE_INSERT_Loans_PreventDelinquentLoans

BEFORE INSERT ON Loans

FOR EACH ROW
BEGIN
DECLARE member_status VARCHAR(20);

SELECT AccountStatus
INTO member_status
FROM Members
WHERE MemberID = NEW.MemberID;

IF member_status = 'Delinquent' THEN

SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Member account is delinquent. Clear fines before borrowing books.';

END IF;
END //

DELIMITER ;


DELIMITER //
#Trigger 4: Prevent Borrowing unavailable books
CREATE TRIGGER BEFORE_INSERT_Loans_CheckBookAvailability

BEFORE INSERT ON Loans

FOR EACH ROW

BEGIN

DECLARE book_status VARCHAR(100);

SELECT Status
INTO book_status
FROM Book_Copies
WHERE CopyID = NEW.CopyID;


IF book_status <> 'Available' THEN

SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Book is currently unavailable';

END IF;

END//
DELIMITER ;

DELIMITER //

#Trigger 5: Automatically mark returned books as available

CREATE TRIGGER AFTER_UPDATE_Loans_UpdateBookStatus
AFTER UPDATE ON Loans
FOR EACH ROW
BEGIN
IF NEW.ReturnDate IS NOT NULL THEN
UPDATE Book_Copies
SET Status='Available'
WHERE CopyID = NEW.CopyID;
END IF;

END;
