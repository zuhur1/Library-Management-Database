/* Environment Setup */
-- Setting up environment
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET SQL_SAFE_UPDATES=0;


DROP DATABASE IF EXISTS `Library_Management_Database`;
CREATE DATABASE `Library_Management_Database`;
USE `Library_Management_Database`;

DROP TABLE IF EXISTS `Authors`;
CREATE TABLE Authors (
	AuthorID INT AUTO_INCREMENT PRIMARY KEY, 
    FirstName VARCHAR(50), 
    LastName VARCHAR(50), 
    Country VARCHAR(50)
    );

DROP TABLE IF EXISTS `Publishers`;
CREATE TABLE Publishers (
	PublisherID INT AUTO_INCREMENT PRIMARY KEY, 
    PublisherName VARCHAR(100),
    City VARCHAR(50),
    Country VARCHAR(70)
    );

DROP TABLE IF EXISTS `Genres`;
CREATE TABLE Genres (
	GenreID INT AUTO_INCREMENT PRIMARY KEY, 
    GenreName VARCHAR(50)
    );

DROP TABLE IF EXISTS `Books`;
CREATE TABLE Books (
	BookID INT AUTO_INCREMENT PRIMARY KEY, 
    Title VARCHAR(100) NOT NULL, 
    ISBN VARCHAR(100) UNIQUE,
    PublicationYear INT, 
    AuthorID INT NOT NULL,
    PublisherID INT,
    GenreID INT NOT NULL,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID), 
    FOREIGN KEY (PublisherID) REFERENCES Publishers(PublisherID),
    FOREIGN KEY (GenreID) REFERENCES Genres(GenreID)
    );
    
DROP TABLE IF EXISTS `Book_Copies`;
CREATE TABLE `Book_Copies`(
	CopyID INT AUTO_INCREMENT PRIMARY KEY, 
    BookID INT,
    FOREIGN KEY (BookID) REFERENCES Books(BookID), 
    ShelfLocation VARCHAR(50),
    Status VARCHAR(100), 
    PurchaseDate date
    );
    
DROP TABLE IF EXISTS `Members`;
CREATE TABLE `Members` (
	MemberID INT AUTO_INCREMENT PRIMARY KEY,
    LibraryCardNumber VARCHAR(20) UNIQUE NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100),
    Phone VARCHAR(50), 
    MembershipDate date NOT NULL,
    AccountStatus VARCHAR(20) DEFAULT 'Active'
    );
    

DROP TABLE IF EXISTS `Loans`;
CREATE TABLE `Loans` (
	LoanID INT AUTO_INCREMENT PRIMARY KEY,
    CopyID INT NOT NULL,
    MemberID INT NOT NULL,
    FOREIGN KEY (CopyID) REFERENCES Book_Copies(CopyID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    CheckoutDate date NOT NULL, 
    DueDate date NOT NULL, 
    ReturnDate date,
    CHECK (DueDate >= CheckoutDate)
    );


DROP TABLE IF EXISTS `Fines`;
CREATE TABLE `Fines` (
	FineID INT AUTO_INCREMENT PRIMARY KEY, 
    LoanID INT NOT NULL,
    FOREIGN KEY (LoanID) references Loans(LoanID),
    FineAmount decimal(6,2) NOT NULL, 
    Paid boolean default FALSE, 
    PaymentDate date
    );



