USE Kaggle;


CREATE TABLE delhi_bus_data (
    year INT,
    month VARCHAR(15),
    bus_type VARCHAR(50),
    is_electric INT,         -- 1 for Electric, 0 for Non-Electric
    is_manual INT,           -- 1 for Manual, 0 for Not Manual
    total_buses_launched INT,
    total_passengers INT,
    total_bus_stops INT
);


INSERT INTO delhi_bus_data 
(year, month, bus_type, is_electric, is_manual, total_buses_launched, total_passengers, total_bus_stops)
VALUES
(2024, 'Jan', 'Orange', 1, 0, 4, 6500, 50),
(2024, 'Jan', 'Green', 0, 1, 2, 4800, 35),
(2024, 'Feb', 'Blue', 0, 1, 3, 5200, 38),
(2024, 'Mar', 'Red', 0, 1, 5, 7000, 40),
(2024, 'Mar', 'Devi Express', 1, 0, 2, 3000, 25),

(2023, 'Jul', 'Orange', 1, 0, 3, 5800, 45),
(2023, 'Aug', 'Green', 0, 1, 4, 5100, 34),
(2023, 'Sep', 'Blue', 0, 1, 2, 4600, 28),
(2023, 'Oct', 'Red', 0, 1, 1, 4200, 30),
(2023, 'Dec', 'Devi Express', 1, 0, 3, 3100, 22);

SELECT * FROM delhi_bus_data ;

--  Count how mnay AC and NON AC buses were launched each year  --

SELECT  Year,bus_type,SUM(is_electric)AS AC_BUS ,SUM(is_manual)AS NON_AC ,SUM(total_buses_launched)AS launch
FROM delhi_bus_data  
GROUP BY Year,bus_type ;


--  Count how many  buses older than 30 years or 20 years --

SELECT  SUM(is_electric)AS AC_BUS ,SUM(is_manual)AS NON_AC ,SUM(total_buses_launched)AS launch,Year(current_date()) - Year AS age
FROM delhi_bus_data  
GROUP BY Year(current_date()) - Year ;



-- Total Buses by Bus type Yearly based --

SELECT year,SUM(total_buses_launched)AS total_buses,bus_type
FROM delhi_bus_data
GROUP BY year,bus_type
ORDER BY total_buses DESC ,year;

-- YOY % of buses launched ---

-- how many buses electric V/S Non electric--

SELECT bus_type,SUM(is_electric)AS Electric,SUM(is_manual)AS Non_AC
FROM delhi_bus_data
GROUP BY bus_type ; 

-- Total passengers per Bus type - Which bus type people prefer the most (most convenient) ? ---

SELECT SUM(total_passengers)as Total_passengers,bus_type
FROM delhi_bus_data
GROUP BY bus_type 
ORDER BY Total_passengers DESC ;

-- YOY % Passengers to see which bus perfromance improved or decreased over time ) ? --


-- TABLE 2 ---
											
CREATE TABLE performance_of_delhi_buses (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    bus_type VARCHAR(50),                            
    total_bus_stops INT,                             
    avg_wait_time_minutes DECIMAL(4,2),               
    avg_travel_time_per_stop_minutes DECIMAL(4,2),    
    total_passengers INT,                            
    actual_capacity INT,                             
    male_passengers INT,
    female_passengers INT,
    other_passengers INT,
    travel_date DATE,                                 
    travel_time TIME                                  
);

INSERT INTO performance_of_delhi_buses 
(bus_type, total_bus_stops, avg_wait_time_minutes, avg_travel_time_per_stop_minutes, total_passengers, actual_capacity, male_passengers, female_passengers, other_passengers, travel_date, travel_time)
VALUES 
('Orange', 18, 5.20, 6.30, 95, 60, 50, 40, 5, '2024-07-26', '08:30:00'),

('Green', 20, 4.50, 7.10, 80, 50, 45, 30, 5, '2024-07-26', '09:00:00'),

('Blue', 22, 6.00, 5.80, 110, 70, 60, 45, 5, '2024-07-26', '17:30:00'),

('Red', 15, 3.80, 6.50, 70, 45, 35, 30, 5, '2024-07-26', '18:15:00'),

('Devi', 25, 7.00, 8.10, 130, 80, 65, 60, 5, '2024-07-26', '20:00:00');



-- 2023 data
INSERT INTO performance_of_delhi_buses 
(bus_type, total_bus_stops, avg_wait_time_minutes, avg_travel_time_per_stop_minutes, total_passengers, actual_capacity, male_passengers, female_passengers, other_passengers, travel_date, travel_time)
VALUES 
('Orange', 18, 5.50, 6.00, 90, 60, 48, 38, 4, '2023-05-14', '07:45:00'),
('Green', 20, 4.20, 6.80, 75, 50, 42, 28, 5, '2023-10-21', '09:30:00'),
('Red', 15, 4.00, 6.30, 65, 45, 34, 28, 3, '2023-12-01', '18:00:00');


INSERT INTO performance_of_delhi_buses 
(bus_type, total_bus_stops, avg_wait_time_minutes, avg_travel_time_per_stop_minutes, total_passengers, actual_capacity, male_passengers, female_passengers, other_passengers, travel_date, travel_time)
VALUES 
('Blue', 22, 6.10, 5.70, 115, 70, 62, 48, 5, '2025-01-05', '08:20:00'),
('Devi', 25, 6.80, 8.00, 125, 80, 60, 60, 5, '2025-03-15', '19:00:00'),
('Green', 20, 4.70, 7.20, 85, 50, 44, 36, 5, '2025-06-10', '10:15:00');


-- AVG Waiting timing per bus type per month --- DO RAINS (WEATHER ) AFFECT PUBLIC  TRANSPORT PERFROMANCE ? --
-- ARE Buses late during rainy season, winters or festivals  and during some peak hours ---

SELECT monthname(travel_date)as Months,HOUR(travel_time) as Trvl_Hours,ROUND(AVG(avg_wait_time_minutes),2)AS Waiting_time,bus_type
FROM performance_of_delhi_buses 
GROUP BY months,bus_type,Trvl_Hours
ORDER BY months,Waiting_time;

-- Avg time taken by bus type to travel one stop to other --


  SELECT monthname(travel_Date)AS Months,bus_type,ROUND(AVG(avg_travel_time_per_stop_minutes),2)AS Time_between_stops
  FROM performance_of_delhi_buses 
  GROUP BY months,bus_type 
  ORDER BY Time_between_stops DESC ;
  
  
SELECT * FROM performance_of_delhi_buses ; 

-- Total Passengers by bus type -- which bus type people prefer the most --

SELECT bus_type,SUM(Total_passengers)AS Passengers
FROM performance_of_delhi_buses
GROUP BY bus_type 
ORDER BY Passengers DESC ;


-- Peak Hours and waiting time of buses --- Is overcrowded buses are nowdays very common does it due to availabilty of buses ---

SELECT bus_type,travel_time,SUM(total_passengers)AS Passengers,SUM(actual_capacity)AS Capacity,ROUND(AVG(avg_wait_time_minutes),2)AS Waiting_time
FROM performance_of_delhi_buses
GROUP BY travel_time,bus_type
ORDER BY Passengers DESC,waiting_time DESC ;

-- Gender based passengers distribution -- DOES PINK TICKET scheme  increased female passengers and to what % --

SELECT YEAR(travel_Date)AS year,SUM(female_passengers)AS female,SUM(male_passengers)AS male,SUM(total_passengers)AS total
FROM performance_of_delhi_buses
GROUP BY year ;

-- PART 2 : WHAT PERCENT OF TOTAL CUSTOMER IS MALE/FEMALE WHO HAVE MAX. PROPORTION --- 

WITH ALLS AS (
SELECT SUM(male_passengers)AS male,
SUM(total_passengers)AS total 
FROM performance_of_delhi_buses )

SELECT ROUND(100.0*total/male,2)
FROM ALLS;


-- Month based passengers buses perfromance --- SEASONS AFFETCT ?---

SELECT Monthname(travel_Date)AS Months,SUM(total_passengers) AS Passengers
FROM performance_of_delhi_buses 
GROUP BY Months 
ORDER BY Passengers DESC ;

-- Bus type and total bus stops --

SELECT bus_type,SUM(total_bus_stops)AS Bus_stops
FROM performance_of_delhi_buses 
GROUP BY bus_type 
ORDER BY Bus_stops DESC ; 

-- TABLE 3 ---

CREATE TABLE bus_stops_by_type (
    bus_type VARCHAR(50),
    bus_stop_name VARCHAR(100),
    total_passengers INT
);


INSERT INTO bus_stops_by_type (bus_type, bus_stop_name, total_passengers) VALUES
('Orange', 'Rajiv Chowk', 6800),
('Orange', 'Nehru Place', 5900),
('Orange', 'Vasant Vihar', 6300),

('Green', 'Anand Vihar ISBT', 7100),
('Green', 'Saket', 5600),
('Green', 'Mayur Vihar Phase 1', 6200),
('Green', 'Okhla NSIC', 5300),

('Red', 'AIIMS', 6700),
('Red', 'Lajpat Nagar', 6000),
('Red', 'Govindpuri', 5800),

('Blue', 'Dwarka Sector 21', 6900),
('Blue', 'Janakpuri West', 5700),
('Blue', 'Moti Nagar', 6400),
('Blue', 'Kirti Nagar', 6100),

('Devi Bus', 'Kashmere Gate', 7200),
('Devi Bus', 'Sarai Kale Khan', 6300),
('Devi Bus', 'Rohini East', 5900);


-- Most overcrowded bus stops --- are bus avaialble here on time ? ---

SELECT S.bus_type,bus_stop_name,ROUND(AVG(P.avg_wait_time_minutes),2)AS Wait_time,SUM(S.total_passengers)AS Passengers
FROM bus_stops_by_type S
Join performance_of_delhi_buses P
ON S.bus_type = P.bus_type
GROUP BY bus_type,bus_stop_name 
ORDER BY wait_time DESC ,Passengers DESC;


-- TABLE 4 BUSES FARE ---

CREATE TABLE bus_revenue (
    trip_date DATE,
    bus_type VARCHAR(20),
    revenue DECIMAL(10, 2),
    avg_fare DECIMAL(10, 2)
);



INSERT INTO bus_revenue (trip_date, bus_type, revenue, avg_fare) VALUES
('2022-01-15', 'Orange', 15000, 500),
('2022-03-20', 'Red', 12000, 450),
('2023-05-10', 'Green', 18000, 550),
('2023-07-22', 'Blue', 16000, 520),
('2024-02-18', 'Devi Bus', 20000, 600),
('2024-08-30', 'Orange', 17000, 510),
('2025-01-10', 'Red', 19000, 490),
('2025-03-28', 'Devi Bus', 21000, 630);


-- BUSES FARE BUS TYPE ACCORDINGLY ---

SELECT Bus_type,DATE_FORMAT(trip_date,'%m-%Y')AS Dates,SUM(revenue)AS Total_revenue 
FROM bus_revenue 
GROUP BY Bus_type, DATE_FORMAT(trip_date,'%m-%Y');


-- MOM % REVENUE --- Studies how much people acually uisng public transport does providing free tickets to womens led to loss ---

SELECT 
  bus_type,
  DATE_FORMAT(trip_date, '%Y-%m') AS month,
  SUM(revenue) AS monthly_revenue,
  ROUND(
    100.0 * (SUM(revenue) - LAG(SUM(revenue)) OVER (PARTITION BY bus_type ORDER BY DATE_FORMAT(trip_date, '%Y-%m')))
    / NULLIF(LAG(SUM(revenue)) OVER (PARTITION BY bus_type ORDER BY DATE_FORMAT(trip_date, '%Y-%m')), 0), 2
  ) AS mom_growth_percent
FROM 
  bus_revenue
GROUP BY 
  bus_type, DATE_FORMAT(trip_date, '%Y-%m')
ORDER BY 
  bus_type, month;

-- Total customer distribution from which stops mainly -- Peak hrs done ---


-- Buses failure & their causes & how often does these occur ---

CREATE TABLE bus_failures (
    failure_date DATE,
    bus_type VARCHAR(30),
    failure_type VARCHAR(50),
    cause_description TEXT,
    total_buses_affected INT,
    buses_fully_maintained INT,
    buses_pending_maintenance INT
);


INSERT INTO bus_failures (
    failure_date, bus_type, failure_type, cause_description,
    total_buses_affected, buses_fully_maintained, buses_pending_maintenance
) VALUES
('2023-08-15', 'Orange', 'Engine Overheating', 'Radiator clogged due to poor maintenance.', 7, 5, 2),
('2023-11-10', 'Red', 'Brake Malfunction', 'Brake oil leak noticed after long route.', 6, 4, 2),
('2024-03-25', 'Green', 'Battery Drain', 'Battery drained after improper overnight charging.', 5, 3, 2),
('2024-06-18', 'Blue', 'Transmission Issues', 'Gearbox issues in high-mileage buses.', 4, 3, 1),
('2025-07-20', 'Red', 'Engine Overheating', 'Coolant leak led to engine failure in peak traffic.', 8, 5, 3),
('2025-07-20', 'Green', 'Brake Malfunction', 'Worn-out brake pads on older buses.', 5, 4, 1),
('2025-07-21', 'Blue', 'Battery Drain', 'Unexpected battery drop during route.', 4, 2, 2),
('2025-07-21', 'Orange', 'Fuel Leakage', 'Cracked fuel line in CNG compartment.', 3, 2, 1),
('2025-07-22', 'Red', 'AC Compressor Failure', 'Compressor failure in high-temp conditions.', 6, 3, 3),
('2025-07-22', 'Devi Bus', 'Electrical Short', 'Short circuit in dashboard wiring.', 2, 1, 1);


SELECT * FROM bus_failures ;

-- Monthly basis buses failure and count of bus failure cases --

SELECT monthname(failure_date)AS Months,Bus_type,failure_type,cause_description,SUM(total_buses_affected)AS bus_failures
FROM bus_failures 
GROUP BY monthname(failure_date),Bus_type,failure_type,cause_description
ORDER BY bus_failures DESC ;


-- How often does these failures occur ?  MOM % --- Use Lag 

SELECT monthname(failure_date)AS Months,Bus_type,failure_type,cause_description,SUM(total_buses_affected)AS bus_failures
FROM bus_failures 
GROUP BY monthname(failure_date),Bus_type,failure_type,cause_description
ORDER BY bus_failures DESC ;

-- Moving Average ---

SELECT monthname(failure_date),failure_type,ROUND(AVG(total_buses_affected) OVER(ORDER BY failure_date  ROWS BETWEEN  2 PRECEDING AND  CURRENT ROW ),2) AS Frequently
FROM bus_failures ;

-- HOW many buses are mantained out of total and how many still pending ?  --

SELECT * FROM bus_failures ;

SELECT bus_type, SUM(total_buses_affected)AS total_buses,SUM(buses_fully_maintained)AS maintained,SUM(buses_pending_maintenance)AS pending
FROM bus_failures
GROUP BY bus_type ;


-- DELHI METRO PERFROMANCE ---

CREATE TABLE delhi_metro (
    year INT,
    month INT,
    metro_line VARCHAR(50),
    station_name VARCHAR(100),
    total_metros_operated INT,
    total_passengers INT,
    male_passengers INT,
    female_passengers INT,
    fare_collected DECIMAL(10, 2)
);


DROP TABLE delhi_metro  ;

TRUNCATE delhi_metro; 

INSERT INTO delhi_metro (
  year, month, metro_line, station_name,
  total_metros_operated, total_passengers,
  male_passengers, female_passengers,
  fare_collected
) VALUES
-- Red Line
(2024,1,'Red','Dilshad Garden',8000,90000,54000,36000,1350000.00),
(2024,1,'Red','Kashmere Gate',8000,110000,66000,44000,1650000.00),
(2024,1,'Red','Welcome',8000,95000,57000,38000,1425000.00),
(2024,1,'Red','Seelampur',8000,85000,51000,34000,1275000.00),
(2024,1,'Red','Tis Hazari',8000,78000,47000,31000,1170000.00),
(2024,1,'Red','Pul Bangash',8000,72000,43000,29000,1080000.00),
(2024,1,'Red','Netaji Subhash Place',8000,100000,60000,40000,1500000.00),
(2024,1,'Red','Kanhaiya Nagar',8000,65000,39000,26000,975000.00),
(2024,1,'Red','Pitampura',8000,70000,42000,28000,1050000.00),
(2024,1,'Red','Rithala',8000,75000,45000,30000,1125000.00),
(2024,2,'Red','Dilshad Garden',8200,92000,55200,36800,1380000.00),
(2024,2,'Red','Kashmere Gate',8200,112000,67200,44800,1680000.00),
(2024,2,'Red','Welcome',8200,97000,58200,38800,1455000.00),
(2024,2,'Red','Seelampur',8200,86000,51600,34400,1290000.00),
(2024,2,'Red','Tis Hazari',8200,80000,48000,32000,1200000.00),
(2024,2,'Red','Pul Bangash',8200,74000,44400,29600,1110000.00),
(2024,2,'Red','Netaji Subhash Place',8200,102000,61200,40800,1530000.00),
(2024,2,'Red','Kanhaiya Nagar',8200,67000,40200,26800,1005000.00),
(2024,2,'Red','Pitampura',8200,72000,43200,28800,1080000.00),
(2024,2,'Red','Rithala',8200,77000,46200,30800,1155000.00),

-- Yellow Line
(2024,1,'Yellow','Samaypur Badli',9000,130000,78000,52000,1950000.00),
(2024,1,'Yellow','Kashmere Gate',9000,140000,84000,56000,2100000.00),
(2024,1,'Yellow','Chandni Chowk',9000,120000,72000,48000,1800000.00),
(2024,1,'Yellow','New Delhi',9000,150000,90000,60000,2250000.00),
(2024,1,'Yellow','Rajiv Chowk',9000,160000,96000,64000,2400000.00),
(2024,1,'Yellow','Central Secretariat',9000,110000,66000,44000,1650000.00),
(2024,1,'Yellow','INA',9000,100000,60000,40000,1500000.00),
(2024,1,'Yellow','AIIMS',9000,95000,57000,38000,1425000.00),
(2024,1,'Yellow','Hauz Khas',9000,105000,63000,42000,1575000.00),
(2024,1,'Yellow','HUDA City Centre',9000,125000,75000,50000,1875000.00),
(2024,2,'Yellow','Samaypur Badli',9200,132000,79200,52800,1980000.00),
(2024,2,'Yellow','Kashmere Gate',9200,142000,85200,56800,2130000.00),
(2024,2,'Yellow','Chandni Chowk',9200,122000,73200,48800,1830000.00),
(2024,2,'Yellow','New Delhi',9200,152000,91200,60800,2280000.00),
(2024,2,'Yellow','Rajiv Chowk',9200,162000,97200,64800,2430000.00),
(2024,2,'Yellow','Central Secretariat',9200,112000,67200,44800,1680000.00),
(2024,2,'Yellow','INA',9200,102000,61200,40800,1530000.00),
(2024,2,'Yellow','AIIMS',9200,97000,58200,38800,1455000.00),
(2024,2,'Yellow','Hauz Khas',9200,107000,64200,42800,1605000.00),
(2024,2,'Yellow','HUDA City Centre',9200,127000,76200,50800,1905000.00),

-- Magenta Line (10 stations from mapsofindia list) :contentReference[oaicite:1]{index=1}
(2024,1,'Magenta','Janakpuri West',8500,140000,84000,56000,2100000.00),
(2024,1,'Magenta','Dabri Mor - Janakpuri South',8500,130000,78000,52000,1950000.00),
(2024,1,'Magenta','Dashrath Puri',8500,120000,72000,48000,1800000.00),
(2024,1,'Magenta','Palam',8500,115000,69000,46000,1725000.00),
(2024,1,'Magenta','Sadar Bazaar Cantonment',8500,110000,66000,44000,1650000.00),
(2024,1,'Magenta','Terminal 1 IGI Airport',8500,135000,81000,54000,2025000.00),
(2024,1,'Magenta','Vasant Vihar',8500,125000,75000,50000,1875000.00),
(2024,1,'Magenta','Munirka',8500,115000,69000,46000,1725000.00),
(2024,1,'Magenta','RK Puram',8500,118000,70800,47200,1770000.00),
(2024,1,'Magenta','Hauz Khas',8500,130000,78000,52000,1950000.00),
(2024,2,'Magenta','Janakpuri West',8700,142000,85200,56800,2130000.00),
(2024,2,'Magenta','Dabri Mor - Janakpuri South',8700,132000,79200,52800,1980000.00),
(2024,2,'Magenta','Dashrath Puri',8700,122000,73200,48800,1830000.00),
(2024,2,'Magenta','Palam',8700,117000,70200,46800,1755000.00),
(2024,2,'Magenta','Sadar Bazaar Cantonment',8700,112000,67200,44800,1680000.00),
(2024,2,'Magenta','Terminal 1 IGI Airport',8700,137000,82200,54800,2055000.00),
(2024,2,'Magenta','Vasant Vihar',8700,127000,76200,50800,1905000.00),
(2024,2,'Magenta','Munirka',8700,117000,70200,46800,1755000.00),
(2024,2,'Magenta','RK Puram',8700,120000,72000,48000,1800000.00),
(2024,2,'Magenta','Hauz Khas',8700,132000,79200,52800,1980000.00);

INSERT INTO delhi_metro (
  year, month, metro_line, station_name,
  total_metros_operated, total_passengers,
  male_passengers, female_passengers,
  fare_collected
) VALUES

-- 🔵 Blue Line — 5 stations Feb 2024
(2024, 2, 'Blue', 'Dwarka Sector 21',     10000, 160000, 96000, 64000, 2400000.00),
(2024, 2, 'Blue', 'Rajouri Garden',       10000, 150000, 90000, 60000, 2250000.00),
(2024, 2, 'Blue', 'Karol Bagh',           10000, 145000, 87000, 58000, 2175000.00),
(2024, 2, 'Blue', 'Noida Sector 15',      10000, 155000, 93000, 62000, 2325000.00),
(2024, 2, 'Blue', 'Vaishali',             10000, 158000, 94800, 63200, 2370000.00),

-- 🟢 Green Line — 5 stations Feb 2024
(2024, 2, 'Green', 'Inderlok',            7000, 90000, 54000, 36000, 1350000.00),
(2024, 2, 'Green', 'Ashok Park Main',     7000, 88000, 52800, 35200, 1320000.00),
(2024, 2, 'Green', 'Mundka',              7000, 92000, 55200, 36800, 1380000.00),
(2024, 2, 'Green', 'Nangloi',             7000, 89000, 53400, 35600, 1335000.00),
(2024, 2, 'Green', 'Kirti Nagar',         7000, 88000, 52800, 35200, 1320000.00),

-- 🟣 Violet Line — 5 stations Jan 2024
(2024, 1, 'Violet', 'Kashmere Gate',      8500, 110000, 66000, 44000, 1650000.00),
(2024, 1, 'Violet', 'ITO',                8500, 105000, 63000, 42000, 1575000.00),
(2024, 1, 'Violet', 'Lajpat Nagar',       8500, 115000, 69000, 46000, 1725000.00),
(2024, 1, 'Violet', 'Kalkaji Mandir',     8500, 112000, 67200, 44800, 1680000.00),
(2024, 1, 'Violet', 'Mandi House',        8500, 118000, 70800, 47200, 1770000.00),

-- 🟠 Airport Express (Orange) — 5 stations Jan 2024
(2024, 1, 'Airport Express', 'New Delhi',      5000, 60000, 36000, 24000, 1200000.00),
(2024, 1, 'Airport Express', 'Shivaji Stadium',5000, 58000, 35000, 23000, 1160000.00),
(2024, 1, 'Airport Express', 'Dhaula Kuan',     5000, 59000, 35400, 23600, 1180000.00),
(2024, 1, 'Airport Express', 'Aerocity',        5000, 59500, 35700, 23800, 1190000.00),
(2024, 1, 'Airport Express', 'IGI Airport',     5000, 61000, 36600, 24400, 1220000.00),

-- 🩷 Pink Line — 5 stations Feb 2024
(2024, 2, 'Pink', 'Majlis Park', 9500, 130000, 78000, 52000, 1950000.00),
(2024, 2, 'Pink', 'Netaji Subhash Place', 9500, 135000, 81000, 54000, 2025000.00),
(2024, 2, 'Pink', 'Rajouri Garden', 9500, 132000, 79200, 52800, 1980000.00),
(2024, 2, 'Pink', 'Lajpat Nagar', 9500, 140000, 84000, 56000, 2100000.00),
(2024, 2, 'Pink', 'Shiv Vihar',9500, 145000, 87000, 58000, 2175000.00),


-- ⚫ Grey Line — 5 stations Jan 2024
(2024, 1, 'Grey', 'Dwarka',               3000, 50000, 30000, 20000, 1500000.00),
(2024, 1, 'Grey', 'Nangli',               3000, 48000, 28800, 19200, 1440000.00),
(2024, 1, 'Grey', 'Najafgarh',            3000, 49000, 29400, 19600, 1470000.00),
(2024, 1, 'Grey', 'Dhansa Bus Stand',     3000, 46000, 27600, 18400, 1380000.00),
(2024, 1, 'Grey', 'Nangli Dairy',         3000, 47000, 28200, 18800, 1410000.00);



-- Total metro per Metro line ---

SELECT * FROM delhi_metro ;

-- TABLE B delhi_metro  ----


CREATE TABLE delhi_metro (
    year INT,
    month INT,
    metro_line VARCHAR(50),
    station_name VARCHAR(100),
    total_metros_operated INT,
    total_passengers INT,
    male_passengers INT,
    female_passengers INT,
    fare_collected DECIMAL(10, 2),
    time_of_day TIME
);

-- Total metro launched  --

SELECT year,month,metro_line,SUM(total_metros_operated)AS metro_launched
FROM delhi_metro 
GROUP BY year,month,metro_line ; 


-- Total Passengers per metro line -- 

SELECT metro_line,SUM(total_passengers)AS passengers_ct,SUM(female_passengers) AS Female,
SUM(male_passengers)AS male
FROM delhi_metro 
GROUP BY metro_line ;


-- Passengers per metro line stations -- FIND THE MOST CROWDED STATIONS ---


WITH ALLS AS (
SELECT  metro_line,station_name,SUM(total_passengers)AS Passengers_ct
FROM delhi_metro 
GROUP BY metro_line,station_name ) ,

TOP_3 AS (
SELECT metro_line,station_name,Passengers_ct,ROW_NUMBER() OVER(Partition BY Metro_line  ORDER BY Passengers_ct DESC) AS Rankx
FROM ALLS 
GROUP BY metro_line,station_name,passengers_ct ) 

SELECT metro_line,station_name,Passengers_ct
FROM TOP_3
WHERE Rankx <=3 ;



-- Revenue per Year per metro line ---

SELECT  year,metro_line,SUM(fare_collected)as Revenue
FROM delhi_metro 
GROUP BY Year,metro_line
ORDER BY Revenue DESC ;



-- Revenue per stations of each metro line find the TOP 3 --



SELECT  metro_line,station_name,SUM(fare_collected)AS Revenue
FROM delhi_metro 
GROUP BY metro_line,station_name
ORDER BY Revenue DESC
LIMIT 3 ; 	


-- ALSO SHOW WHAT CONTRIBUTION   EG 20% FROM THIS STATION AND 80% FROM THIS ----)



-- Count of Metro stations per metro lines --- ( To chehck in which year new stations added ) and that too which line ---


SELECT Year, metro_line, COUNT(Station_name)AS Total_stations
FROM delhi_metro
GROUP BY year,metro_line 
ORDER BY Total_stations DESC ;



-- table 2 ----

CREATE TABLE metro_speed_performance (
    travel_date DATE,
    metro_line VARCHAR(50),
    station_name VARCHAR(50),
    waiting_time_min INT,
    travel_time_between_stations_min INT
    );

DROP TABLE metro_travel_timings ;

-- Insert values ---

INSERT INTO metro_speed_performance (
  travel_date, metro_line, station_name,
  waiting_time_min, travel_time_between_stations_min
) VALUES
-- RED LINE
('2024-01-05', 'Red Line', 'Rithala', 4, 3),
('2024-01-18', 'Red Line', 'Netaji Subhash Place', 5, 4),
('2024-01-27', 'Red Line', 'Kashmere Gate', 3, 5),
('2024-01-30', 'Red Line', 'Welcome', 4, 3),
('2024-01-31', 'Red Line', 'Shahdara', 5, 4),

-- BLUE LINE
('2024-02-03', 'Blue Line', 'Dwarka Sector 21', 6, 4),
('2024-02-11', 'Blue Line', 'Rajouri Garden', 5, 5),
('2024-02-17', 'Blue Line', 'Karol Bagh', 4, 4),
('2024-02-24', 'Blue Line', 'Yamuna Bank', 6, 6),
('2024-02-28', 'Blue Line', 'Noida Sector 16', 5, 5),

-- YELLOW LINE
('2024-03-04', 'Yellow Line', 'Samaypur Badli', 4, 4),
('2024-03-09', 'Yellow Line', 'Vishwavidyalaya', 3, 5),
('2024-03-18', 'Yellow Line', 'Rajiv Chowk', 6, 5),
('2024-03-23', 'Yellow Line', 'Central Secretariat', 4, 4),
('2024-03-31', 'Yellow Line', 'Huda City Centre', 5, 6),

-- MAGENTA LINE
('2024-04-02', 'Magenta Line', 'Janakpuri West', 5, 5),
('2024-04-08', 'Magenta Line', 'Hauz Khas', 4, 4),
('2024-04-14', 'Magenta Line', 'Nehru Enclave', 6, 5),
('2024-04-20', 'Magenta Line', 'Okhla NSIC', 5, 6),
('2024-04-27', 'Magenta Line', 'Botanical Garden', 5, 5),

-- VIOLET LINE
('2024-05-01', 'Violet Line', 'Kashmere Gate', 5, 4),
('2024-05-07', 'Violet Line', 'ITO', 3, 4),
('2024-05-13', 'Violet Line', 'Lajpat Nagar', 4, 5),
('2024-05-21', 'Violet Line', 'Kalkaji Mandir', 6, 6),
('2024-05-29', 'Violet Line', 'Faridabad', 5, 5),

-- PINK LINE
('2024-06-03', 'Pink Line', 'Majlis Park', 4, 4),
('2024-06-10', 'Pink Line', 'South Extension', 5, 5),
('2024-06-18', 'Pink Line', 'Hazrat Nizamuddin', 6, 6),
('2024-06-24', 'Pink Line', 'Mayur Vihar Phase 1', 4, 5),
('2024-06-30', 'Pink Line', 'Shiv Vihar', 5, 4),

-- GREY LINE
('2024-07-02', 'Grey Line', 'Dwarka', 4, 3),
('2024-07-08', 'Grey Line', 'Nangli', 5, 4),
('2024-07-15', 'Grey Line', 'Najafgarh', 4, 5),
('2024-07-22', 'Grey Line', 'Dhansa Bus Stand', 6, 6),
('2024-07-28', 'Grey Line', 'Najafgarh', 5, 4),

-- AIRPORT EXPRESS
('2024-08-04', 'Airport Express', 'New Delhi', 3, 6),
('2024-08-12', 'Airport Express', 'Shivaji Stadium', 4, 6),
('2024-08-18', 'Airport Express', 'Dhaula Kuan', 5, 5),
('2024-08-24', 'Airport Express', 'Delhi Aerocity', 4, 6),
('2024-08-30', 'Airport Express', 'IGI Airport T3', 5, 7);




-- AVG waiting time taken by metro ---


SELECT * FROM  metro_speed_performance;


SELECT metro_line, Round(AVG(waiting_time_min),2)AS Waiting_Time
FROM   metro_speed_performance
GROUP BY metro_line ;


-- Avg time took to travel from one stop to other ---

SELECT Metro_line,ROUND(AVG(travel_time_between_stations_min),2)AS Travel_time
FROM  metro_speed_performance
GROUP BY Metro_line
ORDER BY Travel_time DESC ;


-- Does months affect the waiting time or speed performance of metroes --

 SELECT Monthname(travel_date)AS Months, metro_line,ROUND( AVG(waiting_time_min),2) AS Waiting_time
 FROM  metro_speed_performance
 GROUP BY Monthname(travel_date),metro_line 
ORDER BY waiting_time DESC ;


-- Most Traveled stations name as per each metro line ---

WITH ALLS AS (
SELECT M. metro_line,M.station_name,SUM(total_passengers )AS most_traveled
FROM  metro_speed_performance P
Join  delhi_metro M 
ON P.metro_line = M.metro_line
GROUP BY M .metro_line,M.station_name ),

TOP_3 AS (
SELECT metro_line,station_name,most_traveled,ROW_NUMBER() OVER(PARTITION BY metro_line ORDER BY most_traveled DESC )AS Rankx
FROM ALLS  )

SELECT metro_line,station_name,most_traveled
FROM TOP_3
WHERE Rankx =1 ;

   
   
   SELECT * FROM delhi_metro ;
   SELECT * FROM  metro_speed_performance ; 



-- Waiting time at peak hours ---

ALTER TABLE delhi_metro
ADD COLUMN metro_time TIME ;





-- Waiting time or travel time at crowded stations ---


SELECT P.metro_line,P.station_name,ROUND(AVG(waiting_time_min),2)AS Waiting_time,SUM(total_passengers)AS Passengers
FROM  metro_speed_performance  P
Join  delhi_metro M
ON P.metro_line = M.metro_line 
GROUP BY P.metro_line,P.station_name
ORDER BY Waiting_time DESC
LIMIT 5 ;


-- Passengers Monthly  MOM % --- During festival or rainy season people prefer rapido or cab more -- 

SELECT  Monthname(travel_date)AS Months,SUM(total_passengers)AS Passengers
FROM metro_speed_performance p
jOIN delhi_metro M
ON P.metro_line = M.metro_line 
GROUP BY Months ; 


-- MOM %   Passengers per metro line -- Yellow Line passegners increased by 15% in August 2024 ---

WITH ALLS AS (
SELECT Monthname(travel_date)as Months,P.metro_line,SUM(total_passengers)AS Ct_passengers
FROM metro_speed_performance p
jOIN delhi_metro M
ON P.metro_line = M.metro_line 
GROUP BY Months,P.metro_line),

MOM AS (
SELECT Months,metro_line,Ct_passengers,LEAD(Ct_passengers) OVER(ORDER BY Ct_passengers) AS Nxt
FROM ALLS )

SELECT months,metro_line,Nxt - Ct_passengers AS MOM_Growth
FROM MOM 
ORDER BY months ;





