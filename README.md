# Library Management Database

## Overview
This Library Management Database is a relational database project designed to manage library operations including tracking book inventory, member status, loans, and accured fines.


## Database Structure

The database contains the following entities:

- Authors
- Publishers
- Genres
- Books
- Book_Copies
- Members
- Loans
- Fines

## ERD

Library Database ERD -> Check in ERDLMD file

## Data Source
The data used in this project is generated. 

### Database Design
- Primary keys and foreign keys
- Relational database structure
- Data integrity constraints

### SQL Analysis
Created KPI queries to analyze:
- Popular genres
- Most borrowed books
- Overdue loans
- Fine activity
- Member activity

### Views
Created reusable views for:
- Current loans
- Current Overdue Books
- Member Fine (payment/repayment) Summary

### Triggers
Implemented database automation:
- Prevent borrowing unavailable books
- Prevent delinquent members from borrowing
- Automatically update book status after returns
- Flag members with excessive unpaid fines 