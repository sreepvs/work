create database  Library_Database_Analysis;

use Library_Database_Analysis;

-- tbl_publisher
CREATE TABLE tbl_publisher (
    publisher_PublisherName VARCHAR(100) PRIMARY KEY,  
    publisher_PublisherAddress VARCHAR(255) NOT NULL,
    publisher_PublisherPhone VARCHAR(255)
);
select * from tbl_publisher;
   
-- tbl_book
CREATE TABLE tbl_book(
    book_BookID INT AUTO_INCREMENT PRIMARY KEY,
    book_Title VARCHAR(255) NOT NULL,
    book_PublisherName VARCHAR(50),  
    FOREIGN KEY (book_PublisherName) REFERENCES tbl_publisher(publisher_PublisherName)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);
select * from tbl_book;


-- tbl_book_authors
CREATE TABLE tbl_book_authors(book_authors_AuthorID SMALLINT AUTO_INCREMENT PRIMARY KEY,
                              book_authors_BookID INT NOT NULL ,
	                          book_authors_AuthorName VARCHAR(100) NOT NULL,
							  FOREIGN KEY (book_authors_BookID) REFERENCES tbl_book(book_BookID)
                                  ON DELETE CASCADE
                                  ON UPDATE CASCADE
);
select * from  tbl_book_authors;


--  tbl_borrower
CREATE TABLE tbl_borrower (borrower_CardNo  INT AUTO_INCREMENT PRIMARY KEY,
						   borrower_BorrowerName VARCHAR(100) NOT NULL,
                           borrower_BorrowerAddress	VARCHAR(255),
                           borrower_BorrowerPhone VARCHAR(20)

);
select * from tbl_borrower;


-- tbl_library_branch
CREATE TABLE tbl_library_branch (library_branch_BranchID TINYINT AUTO_INCREMENT PRIMARY KEY,
                                 library_branch_BranchName VARCHAR(100) NOT NULL,
                                 library_branch_BranchAddress VARCHAR(255)

);
select * from tbl_library_branch ;


-- TBL_BOOK_LOANS

CREATE TABLE tbl_book_loans(
    book_loans_LoansID INT AUTO_INCREMENT PRIMARY KEY,
    book_loans_BookID INT NOT NULL,
    book_loans_BranchID TINYINT NOT NULL, 
    book_loans_CardNo  INT NOT NULL,
    book_loans_DateOut VARCHAR(255),
    book_loans_DueDate VARCHAR(255),
    FOREIGN KEY (book_loans_BookID) REFERENCES tbl_book(book_BookID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (book_loans_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID ) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (book_loans_CardNo) REFERENCES tbl_borrower(borrower_CardNo) ON DELETE CASCADE ON UPDATE CASCADE
);
select * from tbl_book_loans;


--  tbl_book_copies
CREATE TABLE tbl_book_copies (book_copies_CopiesID INT AUTO_INCREMENT PRIMARY KEY, 
                             book_copies_BookID	INT NOT NULL,
                             book_copies_BranchID	TINYINT NOT NULL,
                             book_copies_No_Of_Copies INT NOT NULL,
                             FOREIGN KEY (book_copies_BookID) REFERENCES tbl_book(book_BookID) ON DELETE CASCADE ON UPDATE CASCADE,
                             FOREIGN KEY (book_copies_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID) ON DELETE CASCADE ON UPDATE CASCADE
                             
);
select * from tbl_book_copies;



                                  #Task Questions
# 1.How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
  
SELECT 
bc.book_copies_No_Of_Copies
FROM 
tbl_book_copies as bc
JOIN 
tbl_book as b ON bc.book_copies_BookID = b.book_BookID
JOIN 
tbl_library_branch as  lb ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE 
b.book_Title = 'The Lost Tribe'
AND 
lb.library_branch_BranchName = 'Sharpstown';

# 2.How many copies of the book titled "The Lost Tribe" are owned by each library branch?
SELECT 
lb.library_branch_BranchName, 
SUM(bc.book_copies_No_Of_Copies) AS total_copies
FROM 
tbl_book_copies bc
JOIN 
tbl_book b ON bc.book_copies_BookID = b.book_BookID
JOIN 
tbl_library_branch lb ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE 
b.book_Title = 'The Lost Tribe'
GROUP BY
 lb.library_branch_BranchName;

# 3. Retrieve the names of all borrowers who do not have any books checked out.
SELECT
 b.borrower_BorrowerName
FROM 
tbl_borrower b
LEFT JOIN 
tbl_book_loans bl ON b.borrower_CardNo = bl.book_loans_CardNo
WHERE
 bl.book_loans_LoansID IS NULL;

# 4.For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address. 
SELECT 
b.book_Title, 
br.borrower_BorrowerName, 
br.borrower_BorrowerAddress
FROM 
tbl_book_loans bl
JOIN 
tbl_book b ON bl.book_loans_BookID = b.book_BookID
JOIN 
tbl_borrower br ON bl.book_loans_CardNo = br.borrower_CardNo
JOIN 
tbl_library_branch lb ON bl.book_loans_BranchID = lb.library_branch_BranchID
WHERE 
lb.library_branch_BranchName = 'Sharpstown'
AND 
bl.book_loans_DueDate = "2/3/18";

# 5.For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
SELECT 
lb.library_branch_BranchName, 
COUNT(bl.book_loans_LoansID) AS total_books_loaned
FROM 
tbl_book_loans bl
JOIN 
tbl_library_branch lb ON bl.book_loans_BranchID = lb.library_branch_BranchID
GROUP BY 
lb.library_branch_BranchName;

#6. Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
SELECT br.borrower_BorrowerName, 
br.borrower_BorrowerAddress, 
COUNT(bl.book_loans_LoansID) AS books_checked_out
FROM 
tbl_borrower br
JOIN 
tbl_book_loans bl ON br.borrower_CardNo = bl.book_loans_CardNo
GROUP BY
 br.borrower_BorrowerName, br.borrower_BorrowerAddress
HAVING 
COUNT(bl.book_loans_LoansID) > 5;

#7. For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".
SELECT 
    b.book_Title,
    c.book_copies_No_Of_Copies
FROM 
    tbl_book AS b
JOIN 
    tbl_book_authors AS a ON b.book_BookID = a.book_authors_BookID
JOIN 
    tbl_book_copies AS c ON b.book_BookID = c.book_copies_BookID
JOIN 
    tbl_library_branch AS lb ON c.book_copies_BranchID = lb.library_branch_BranchID
WHERE 
    a.book_authors_AuthorName = 'Stephen King'
    AND lb.library_branch_BranchName = 'Central';



