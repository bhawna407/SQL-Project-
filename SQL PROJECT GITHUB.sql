USE Sales;
USE Kaggle;
USE Leetcode;
CREATE TABLE Emails (
email_id INT,
User_id INT,
Signup_date DATE
);

CREATE TABLE Texts (
text_id INT,
email_id INT,
Signup_action ENUM('Confirmed','Not_Confirmed')
);



CREATE TABLE Customer_Leetcode (
ID INT  auto_increment PRIMARY KEY,
Name VARCHAR(10),
Referee_id int
); 

INSERT INTO Customer_leetcode 
VALUES
(1,'WILL',null),
(2,'Jane',null),
(3,'Alex',2),
(4,'Bill',null),
(5,'Zack',1),
(6,'Mark',2);


SELECT * FROM Customer_leetcode;

SELECT name
FROM Customer_leetcode
WHERE Referee_id <>2 
OR Referee_id IS NULL;

-- bonus table leetcode ---

CREATE TABLE Employee_E1 (
empid INT PRIMARY KEY,
Name VARCHAR(10),
Supervisor INT,
Salary INT
);

INSERT INTO Employee_E1
VALUES
(3,'Brad',null,4000),
(1,'John',3,1000),
(2,'Dan',3,2000),
(4,'Thomas',3,4000);


CREATE TABLE BONUS (
Emp_id INT,
Bonus INT
);

INSERT INTO BONUS 
VALUES
(2,500),
(4,2000);


SELECT E.empId,Name
FROM Employee_E1 E
JOIN BONUS B
ON E.empId = B.Emp_id;

SELECT E.empId,Name,BONUS
FROM Employee_E1 E
LEFT JOIN  BONUS  B
ON E.empId = B.emp_Id
WHERE BONUS IS NULL
OR BONUS < 1000;

CREATE TABLE Students (
Student_id INT,
Student_Name VARCHAR(10)
);

INSERT INTO Students 
VALUES
(1,'Alice'),
(2,'Bob'),
(13,'John'),
(6,'Alex');

CREATE TABLE Examinations (
Student_id  INT,
Subject_Name VARCHAR(20)
);

INSERT INTO Examinations
VALUES
(1,'Math'),
(1,'Physics'),
(1,'Programming'),
(2,'Programming'),
(1,'Physics'),
(1,'Math'),
(13,'Math'),
(13,'Programming'),
(13,'Physics'),
(2,'Math'),
(1,'Math');

CREATE TABLE Subjects (
Subject_name VARCHAR(20)
);

INSERT INTO Subjects 
VALUES
('Maths'),
('Physics'),
('Programming');



SELECT Student_name,E.Student_id,SS.Subject_name,COUNT(SS.Subject_name)
FROM Students S
LEFT JOIN Examinations E
ON S.Student_id = E.Student_id
LEFT JOIN Subjects SS
ON E.Subject_name = SS.Subject_name
GROUP BY Student_name,S.Student_id,SS.Subject_name;

SELECT * FROM Sales.orders;



-- STORED PROCEDURE -----

SET @P_Customer_id = 12;



DELIMITER $$
CREATE PROCEDURE Averaged_sales ( 
P_Customer_id INT)
BEGIN 
SELECT  * 
FROM Sales.orders O
JOIN Sales.order_items OI
ON O.Order_id = OI.Order_id
WHERE Customer_id = P_Customer_id ;
END $$
DELIMITER ;

CALL Averages_sales  (@P_customer_id);


-- CREATE TRIGGERS ---


-- TO UPDATED BOOK COUNT WHEN BORROWED --

DELIMITER $$

CREATE TRIGGER BOOKS_PURCHASED_UPDATED
AFTER INSERT ON Sales.Books_Borrowed
FOR EACH ROW
BEGIN 
UPDATE Books_Borrowed 
SET Book_Id = Book_Id+1
WHERE Issue_Time = NOW() ;

END$$
DELIMITER ;


-- TO ADD RECORD IN BORROWED_BOOKS  ---

 DELIMITER $$
 
CREATE TRIGGER BOOKS_ISSUED 
AFTER INSERT ON Sales.Library
FOR EACH ROW
BEGIN
INSERT INTO Sales.Books_Borrowed (Customer_id,Book_name,issue_time)
VALUES
(NEW.Customer_id,NEW.Book_name,NOW());
END $$
DELIMITER ;


-- DROP TABLE --

DROP TABLE Library;



CREATE TABLE Library (
Customer_id INT ,
Book_Name VARCHAR(20),
Issue_Time TIME
);

ALTER TABLE Library                       -- CHANGE DATA TYPE ----
MODIFY COLUMN  Book_Name  VARCHAR(20);


INSERT INTO   Library (customer_id,Book_name,Issue_time)
VALUES
(1,'Goosebum', '10:00'),
(12,'Mac_Liney','12:30'),
(25,'Train_To_Truth','12:30'),
(30,'Two_States','12:45');


INSERT INTO Library
VALUES
(45,'GUKESH_CHESS_PLAYER','10:15'),
(20,'SYED_HUSSAIN','3:30'),
(35,'HOMETWONLAND','4:45'),
(15,'TOO_FAR_AWAY','4:50');





CREATE TABLE Books_Borrowed (
Customer_id INT,
Book_name VARCHAR(10),
Issue_time TIME
);

SELECT * FROM Books_Borrowed;
SELECT * FROM Library;



USE Kaggle;
CREATE TABLE Supermarket_Sales (
ROW_ID INT,
Order_ID VARCHAR(100),
Order_Date DATE,
Ship_Date DATE,
Ship_Mode VARCHAR(50),
Customer_ID VARCHAR(100),
Customer_Name VARCHAR(200),
Segment VARCHAR(60),
Country VARCHAR(100),
City VARCHAR(100),
State VARCHAR(50),
Postal_Code INT,
Region VARCHAR(50),
Product_ID VARCHAR(100),
Category VARCHAR(255),
Sub_Category VARCHAR(100),
Product_Name VARCHAR(100),
Sales INT
);


SELECT * FROM Supermarket_Sales;

DROP TABLE IF EXISTS Flights ;

DROP TABLE IF EXISTS flights;

CREATE TABLE flights (
    flight_id INT PRIMARY KEY,
    airline_name VARCHAR(100),
    flight_name VARCHAR(100),
    departure_time DATETIME,
    arrival_time DATETIME,
    available_seats INT
);

INSERT INTO flights (flight_id, airline_name, flight_name, departure_time, arrival_time, available_seats)
VALUES 
(202, 'Air India', 'AI-101', '2025-05-22 10:00:00', '2025-05-22 12:00:00', 5),
(203, 'IndiGo', '6E-505', '2025-05-23 14:30:00', '2025-05-23 16:45:00', 3);



CREATE TABLE customers_Flight (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15)
);


INSERT INTO customers_Flight (customer_id, customer_name, email, phone)
VALUES 
(101, 'Bhawna Sharma', 'bhawna@example.com', '9876543210'),
(102, 'Raj Mehra', 'raj@example.com', '9123456789');



DROP PROCEDURE BookSeat;

-- ERROR HANDLING ---

DELIMITER $$



CREATE PROCEDURE BookSeat(
    IN in_customer_id INT,
    IN in_flight_id INT
)
BEGIN
    DECLARE v_available_seats INT;
    DECLARE v_flight_exists INT;
    DECLARE v_customer_exists INT;

    -- Check if flight exists
    SELECT COUNT(*) INTO v_flight_exists
    FROM flights
    WHERE flight_id = in_flight_id;

    -- Check if customer exists
    SELECT COUNT(*) INTO v_customer_exists
    FROM customers
    WHERE customer_id = in_customer_id;

    -- Custom error if any condition fails
    IF v_flight_exists = 0 OR v_customer_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Registration failed: Invalid Customer ID or Flight ID';
    END IF;

    -- Check seat availability
    SELECT available_seats INTO v_available_seats
    FROM flights
    WHERE flight_id = in_flight_id;

    IF v_available_seats <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Registration failed: No seats available';
    END IF;

    -- Proceed with booking
    START TRANSACTION;
        UPDATE flights
        SET available_seats = available_seats - 1
        WHERE flight_id = in_flight_id;

        INSERT INTO bookings (customer_id, flight_id, booking_date)
        VALUES (in_customer_id, in_flight_id, NOW());
    COMMIT;

    SELECT 'Seat successfully booked' AS message;

END $$

DELIMITER ;
CALL Bookseat (202,102);




-- 2nd TRIAL ERROR HANDLING ---

DELIMITER $$

CREATE PROCEDURE Flight_Bookings_INDIA(
    IN P_customer_id INT,
    IN P_Flight_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN 
        ROLLBACK;
        SELECT 'Flight booking Failed !';
    END;

    START TRANSACTION;

    SET @Seats = (SELECT Seats_available FROM Flights WHERE Flight_id = P_Flight_id);

    IF @Seats IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Flight ID does not exist';
    END IF;

    IF @Seats <= 0 THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Seats not available for this Flight';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Customers WHERE Customer_id = P_Customer_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Customer does not exist';
    END IF;

    UPDATE Flights
    SET Seats_available = Seats_available - 1
    WHERE Flight_id = P_Flight_id;

    INSERT INTO Bookings (Customer_id, Flight_id, booking_Date)
    VALUES (P_Customer_id, P_Flight_id, NOW());

    COMMIT;
    SELECT 'Flight booked Successfully !';
END $$

DELIMITER ;

CREATE TABLE Customers (
    Customer_id INT PRIMARY KEY,
    Customer_name VARCHAR(100),
    Email VARCHAR(100)
);

CREATE TABLE Flights (
    Flight_id INT PRIMARY KEY,
    Flight_name VARCHAR(100),
    Source VARCHAR(50),
    Destination VARCHAR(50),
    Seats_available INT
);

CREATE TABLE Bookings (
    Booking_id INT AUTO_INCREMENT PRIMARY KEY,
    Customer_id INT,
    Flight_id INT,
    Booking_Date DATETIME,
    FOREIGN KEY (Customer_id) REFERENCES Customers(Customer_id),
    FOREIGN KEY (Flight_id) REFERENCES Flights(Flight_id)
);

INSERT INTO Customers (Customer_id, Customer_name, Email) VALUES
(1, 'Amit Sharma', 'amit@example.com'),
(2, 'Bhawna Singh', 'bhawna@example.com'),
(3, 'Ravi Kumar', 'ravi@example.com'),
(4, 'Sneha Patel', 'sneha@example.com'),
(5, 'Arjun Mehta', 'arjun@example.com');


INSERT INTO Flights (Flight_id, Flight_name, Source, Destination, Seats_available) VALUES
(101, 'Indigo 6E101', 'Delhi', 'Mumbai', 3),
(102, 'Air India AI202', 'Mumbai', 'Chennai', 5),
(103, 'SpiceJet SG303', 'Kolkata', 'Delhi', 2),
(104, 'GoAir G405', 'Bangalore', 'Hyderabad', 0),
(105, 'Vistara UK505', 'Delhi', 'Goa', 4);

SELECT * FROM Flights;

CALL Flight_Bookings_INDIA (3,105);
CALL Flight_Bookings_INDIA (3,101);


DROP PROCEDURE Flight_Booking_IND;

-- PRACTICE BY ME ---

DELIMITER $$

CREATE PROCEDURE FLight_Booking_IND (
IN P_Flight_id INT,
IN P_Customer_id INT)
BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
ROLLBACK;
SELECT 'Regsitarion Failed 1';
END;
START TRANSACTION;
SET @seats = (SELECT Available_seats FROM Flights WHERE Flight_id = P_Flight_ID);

IF @Seats IS NULL THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT ='No Flight Exists';
END IF;

IF @Seats <= 0 THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Seats not available for this Flight';
    END IF;

IF NOT EXISTS(SELECT 1 FROM Customers) THEN 
SIGNAL SQLSTATE '45000' 
SET MESSAGE_TEXT = 'Customer not exists';
END IF;


UPDATE Flights
SET Available_seats = avaialable_Seats -1
WHERE Flight_id = P_Flight_id;

INSERT INTO Bookings (Customer_id,Flight_Id,BookingDate)
VALUES
(P_Customer_Id,Flight_id,NOW());

COMMIT;
SELECT 'Registration Successful !';
END $$
DELIMITER ;

CALL Flight_Booking_IND (1,102);

USE Leetcode;
SHOW TABLES ;
USE your_database_name;
SELECT * FROM `byjus downfall` ;

-- BYJUS DOWNDFALL TREND ---

SELECT * FROM `byjus downfall`;

SELECT `Fiscal Year`,Revenue,`Net Loss`,`Total Expenses`
FROM `byjus downfall`
ORDER BY Revenue DESC ,`Net Loss` DESC
LIMIT 1;

-- PROFIT AND LOSS OVER THE YEARS --

SELECT `Fiscal Year`,`Net Loss`,`Total Expenses` - Revenue AS Profit
FROM `byjus downfall`;

-- ONLINE V/S OFFLINE CLASSES ---

USE Leetcode;
SHOW Tables;



SELECT * 
FROM `online & offline class byjus`;

-- ONLINE STUDENTS --

SELECT COUNT(`online students`)AS Online_Class 
FROM `online & offline class byjus`;

-- Offline CLASSES --

SELECT COUNT(`offline (Aakash)`)
FROM `online & offline class byjus`;

-- RETUNRING MEMBERS IN ONLINE CLASSES --

SELECT COUNT(`offline (Aakash)`)AS Online_Class ,COUNT(`Repeat Customers`)AS Repeat_Students
FROM `online & offline class byjus`;


SELECT COUNT(`online students`),COUNT(`Repeat Customers`)AS Repeat_Students
FROM `online & offline class byjus`;


-- NEW CUSTOMERS ONLINE V/S OFFLINE CLASSES --

SELECT COUNT(`online students`),COUNT(`New Customers`)AS Repeat_Students
FROM `online & offline class byjus`;

SELECT COUNT(`offline (Aakash)`)AS Offlline,COUNT(`New Customers`)AS Repeat_Students
FROM `online & offline class byjus`;

-- MOM / YOY SALES --

WITH YOY AS (
SELECT `Fiscal Year`,Revenue,
LAG(Revenue) OVER(ORDER BY  `Fiscal Year`) AS Last_year
FROM `byjus downfall` ),

YOY_A AS 
(SELECT `Fiscal Year`,(Revenue  - Last_year) AS REVENUE_YOY
FROM YOY )

SELECT `Fiscal Year`,REVENUE_YOY
FROM YOY_A
ORDER BY REVENUE_YOY  DESC
LIMIT 1;

-- Customer satisfaction score --
USE Leetcode;

CREATE TABLE Customer_Satisfaction (
Platform VARCHAR(50),
2021_Score  INT,
2022_Score 	INT ,
2023_Score INT 
);

SELECT * 
FROM Customer_Satisfaction ;

DROP TABLE Customer_Satisfaction ;




-- CODING NINJAS ---

Create table If Not Exists cinema (seat_id SERIAL primary key, free bool);

insert into cinema (seat_id, free) values ('1', '1');
insert into cinema (seat_id, free) values ('2', '0');
insert into cinema (seat_id, free) values ('3', '1');
insert into cinema (seat_id, free) values ('4', '1');
insert into cinema (seat_id, free) values ('6', '1');



-- SQL PROJECT ---

-- Main channel table
CREATE TABLE youtube_channels (
    channel_id INT PRIMARY KEY,
    channel_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    subscribers VARCHAR(100) NOT NULL,
    avg_views VARCHAR(200) NOT NULL,
    nox_score DECIMAL(10,2) NOT NULL
);

-- Video details table
CREATE TABLE channel_videos (
    video_id INT PRIMARY KEY,
    channel_id INT NOT NULL,
    video_title VARCHAR(255) NOT NULL,
    upload_date DATE NOT NULL,
    views BIGINT NOT NULL,
    likes BIGINT NOT NULL,
    comments INT NOT NULL,
    FOREIGN KEY (channel_id) REFERENCES youtube_channels(channel_id)
);

-- Engagement metrics table
CREATE TABLE channel_engagement (
    engagement_id INT PRIMARY KEY,
    channel_id INT NOT NULL,
    likes_per_video DECIMAL(10,2) NOT NULL,
    comments_per_video DECIMAL(10,2) NOT NULL,
    shares_per_video DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (channel_id) REFERENCES youtube_channels(channel_id)
);

-- Revenue table
CREATE TABLE channel_revenue (
    revenue_id INT PRIMARY KEY,
    channel_id INT NOT NULL,
    monthly_revenue DECIMAL(15,2) NOT NULL,
    yearly_revenue DECIMAL(15,2) NOT NULL,
    FOREIGN KEY (channel_id) REFERENCES youtube_channels(channel_id)
);

INSERT INTO youtube_channels VALUES
(1, 'TechWorld', 'Technology', '2.1M', '350K', 8.7),
(2, 'FitWithMe', 'Fitness', '1.5M', '220K', 7.9),
(3, 'Cook&Eat', 'Food', '3.2M', '410K', 9.2),
(4, 'EduVibes', 'Education', '2.9M', '360K', 8.8),
(5, 'GamerSpot', 'Gaming', '5M', '750K', 9.5),
(6, 'TravelBug', 'Travel', '1.8M', '270K', 8.0),
(7, 'StylePoint', 'Fashion', '2.4M', '310K', 8.3),
(8, 'MindSet', 'Motivation', '1.2M', '190K', 7.5),
(9, 'MusicAura', 'Music', '4.1M', '680K', 9.1),
(10, 'ArtNest', 'Art', '900K', '130K', 7.2);



INSERT INTO channel_videos VALUES
(101, 1, 'Top 5 AI Tools in 2025', '2025-03-10', 410000, 25000, 900),
(102, 1, 'Build a PC Under 50K', '2025-02-25', 380000, 22000, 750),
(103, 2, 'Full Body Workout', '2025-04-01', 290000, 19000, 620),
(104, 3, 'Paneer Butter Masala', '2025-03-18', 500000, 32000, 1100),
(105, 4, 'SQL in 30 Minutes', '2025-04-10', 360000, 27000, 850),
(106, 5, 'Top 10 PS5 Games', '2025-02-10', 800000, 65000, 1800),
(107, 6, 'Top 5 Hidden Destinations', '2025-04-15', 250000, 15000, 550),
(108, 7, 'Summer Lookbook 2025', '2025-03-22', 310000, 20000, 700),
(109, 8, 'How to Stay Positive', '2025-04-05', 180000, 12000, 400),
(110, 9, 'Best Relaxing Songs', '2025-04-08', 720000, 56000, 1300);




INSERT INTO channel_engagement VALUES
(201, 1, 24000.00, 800.00, 320.00),
(202, 2, 18500.00, 620.00, 210.00),
(203, 3, 31000.00, 1000.00, 430.00),
(204, 4, 26500.00, 870.00, 300.00),
(205, 5, 64000.00, 1700.00, 780.00),
(206, 6, 14000.00, 500.00, 200.00),
(207, 7, 19500.00, 700.00, 280.00),
(208, 8, 11000.00, 400.00, 150.00),
(209, 9, 53000.00, 1200.00, 550.00),
(210, 10, 12500.00, 300.00, 120.00);


INSERT INTO channel_revenue VALUES
(301, 1, 12000.00, 144000.00),
(302, 2, 9500.00, 114000.00),
(303, 3, 17500.00, 210000.00),
(304, 4, 14000.00, 168000.00),
(305, 5, 32000.00, 384000.00),
(306, 6, 9800.00, 117600.00),
(307, 7, 11500.00, 138000.00),
(308, 8, 7000.00, 84000.00),
(309, 9, 28500.00, 342000.00),
(310, 10, 6000.00, 72000.00);

Select * from channel_revenue;
select * from channel_videos;
select * from channel_engagement;
select * from youtube_channels;

-- TOP 5 CHANNELS WITH MOST SUBSCRIBERS ---
select channel_name,subscribers
FROM (
 select channel_name,subscribers,ROW_NUMBER() OVER(ORDER BY subscribers DESC)AS RANX 
from youtube_channels ) top_channels
WHERE RANX <=5 ;

-- TOTAL YEARLY / MONTHLY REVENUE ---
select channel_name,SUM(monthly_revenue)AS monthly_revenue
from youtube_channels  C
JOIN channel_revenue R
 ON C.channel_id = R.channel_id
 GROUP BY channel_name;

-- GROWTH PERCENTAGE MONTHLY REVENUE ---
select channel_name,monthly_revenue
from channel_revenue  R
JOIN youtube_channels C
ON R.channel_id = C.channel_id;


-- WHICH CATEGORY VIDEOS MOSTLY WATCHED ---
select  category,avg_views
from youtube_channels;


-- TOP 3 CATEGORIES VIDEOS WATCHED MOST LAST YEAR (2023) ---
WITH CATEGORY_CHANNELS AS (
select  category,avg_views,DENSE_RANK() OVER(ORDER BY avg_views)AS RANX
from youtube_channels )
SELECT category,avg_views
FROM CATEGORY_CHANNELS
WHERE RANX <=3 ;

-- WHICH YOUTUBE VIDEO GOT MOST LIKE IN 2023 -- 
 select video_title,views
 from channel_videos
 ORDER BY views DESC
 LIMIT 1;
 
 -- WHICH CHANNEL UPLOADS THE MOST VIDEO PER MONTH OR IN A YEAR ---
 select channel_name,MONTH(upload_date)AS Month ,COUNT(video_title)AS monthly_uploads
 FROM channel_videos V
 JOIN youtube_channels C
 ON V.channel_id = C.channel_id
 GROUP BY channel_name,MONTH(upload_date);
 
 -- WHICH YEAR (MONTH) HAS MAX. VIDEOS UPLOADED --
 
 select monthname(upload_date)AS Month ,COUNT(video_title)AS monthly_uploads
 FROM channel_videos 
 GROUP BY monthname(upload_date);
 
 -- AVERAGE LIKES,COMMENT,VIEWS PER ALL CHANNELS ---
 
 select channel_name,likes_per_video,comments_per_video,shares_per_video 
 from channel_engagement E
 JOIN youtube_channels C
 ON E.channel_id = C.channel_id
 ORDER BY likes_per_video DESC,comments_per_video DESC ;
 
 -- LIST CHANNELS THAT HAVE NOX SCORE HIGHER THAN 8 ? ---
 select channel_name,Nox_score
 FROM youtube_channels
 WHERE Nox_score >= 8;
 
 -- Total number of videos per channels ---
 
 select category,count(channel_name)as Channel_counts
 FROM  youtube_channels 
 GROUP BY category;
 
 -- Channel name that starts with S ---
 
 Select channel_name
 from youtube_channels
 WHERE channel_name LIKE 'S%';
 
 -- FIND THE TOP 3 video that shared the most --
 WITH Shares_rank AS (
 select video_title,shares_per_video,ROW_NUMBER() OVER(ORDER BY shares_per_video)AS RANX
 from channel_engagement E
 Join channel_videos V
 ON E.channel_id = V.channel_id )
 
 SELECT video_title,shares_per_video
 from shares_rank
 where RANX <=3 ;
 
 
 -- Which Youtube channels have lowest subscribers ---
 
 select channel_name,likes_per_video,comments_per_video
 from youtube_Channels C
 JOIN channel_engagement E
 ON C.channel_id = E.channel_id
 ORDER BY subscribers ASC
 LIMIT 3;
 
 
 -- TOTAL VIEWS , LIKES , COMMENTS PER catgeory --
 
 select category,likes_per_video,comments_per_video
 from youtube_channels C
 JOIN channel_engagement E
 ON C.channel_id = E.channel_id;
 
 -- Which category generates maximum revenue (yearly)per channel  -- 
 
 select category,channel_name,ROUND(yearly_revenue)AS yearly_revenue
 from youtube_Channels C
 JOIN channel_revenue R
 ON C.channel_id = R.channel_id 
 ORDER BY yearly_revenue DESC 
 LIMIT 3 ;
 
 -- Which youtube channel have high total engagement but a low Nox score ? -- 
 
 select channel_name,subscribers,Nox_score
 from youtube_channels C
 Join channel_engagement E
 ON C.channel_id = E.channel_id
 
 