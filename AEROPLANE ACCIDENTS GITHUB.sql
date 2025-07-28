USE Kaggle ;

 
DROP TABLE air_accident_victims ;

USE Kaggle ;

CREATE TABLE aeroplane_accidents_victims (
Year INT,
Victims INT
); 
SELECT * FROM aeroplane_accidents_victims ;
 
-- Most killed in which year maximum ---

SELECT year,victims
FROM aeroplane_accidents_victims 
GROUP BY Year,Victims
ORDER BY victims DESC
LIMIT 5 ;

-- Minimum victims (Bottom 5  yearly based )

SELECT year,Victims
FROM aeroplane_accidents_victims 
GROUP BY Year,Victims
ORDER BY victims 
LIMIT 5 ;

-- AVG killed annually ---

SELECT ROUND(AVG(victims),2)AS Killed_Victims
FROM aeroplane_accidents_victims ;

-- YOY of victims killed --

SELECT Year,CONCAT(ROUND((victims - Next_Victims) / Next_victims * 100.0 ,2),"%")as YOY
FROM (
SELECT year,victims, LEAD(victims) OVER(ORDER BY year )AS Next_Victims
FROM aeroplane_accidents_victims ) AS YOY ;

-- Moving average ---

SELECT 
  Year,
  Victims,
  ROUND(AVG(Victims) OVER (ORDER BY Year ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING), 2) AS Moving_Avg_3yr
FROM aeroplane_accidents_victims;

-- Contribution % of total victims ---

SELECT 
  Year,
  Victims,
  CONCAT(ROUND(100.0 * Victims / SUM(Victims) OVER (), 2),"%") AS Percent_Contribution
FROM aeroplane_accidents_victims;

-- TABLE 2 ----

USE Kaggle ;

CREATE TABLE Aircraft_Incident_Dataset  (
    
    Incident_Date DATE,
    Aircraft_Model VARCHAR(100),
    Aircraft_Registration_1 VARCHAR(50),
    Aircraft_Operator VARCHAR(100),
    Aircraft_Nature VARCHAR(50),
    Incident_Category VARCHAR(100),
    Incident_Causes VARCHAR(255),
    Incident_Location VARCHAR(150),
    Aircraft_Damage_Type VARCHAR(100),
     Incident_Time TIME,
    Aircraft_Engines VARCHAR(100),
    Onboard_Crew VARCHAR(100),
    Onboard_Passengers VARCHAR(100),
    Onboard_Total VARCHAR(100),
    Fatalities INT,
    Aircraft_First_Flight INT,
    Aircraft_Phase VARCHAR(100),
    Airport VARCHAR(100)
);

DROP TABLE IF EXISTS Aircraft_Incident_Dataset;

SELECT * FROM Aircraft_Incident_Dataset ;


-- Total Cases --
SELECT COUNT(*) AS Total_Incidents FROM Aircraft_Incident_Dataset;

-- Yearly trends of incidents ---

SELECT 
    YEAR(Incident_Date) AS Year,
    COUNT(*) AS Incident_Count
FROM Aircraft_Incident_Dataset
GROUP BY YEAR(Incident_Date)
ORDER BY Year DESC;

-- Mostly affected models ---

SELECT 
    Aircraft_Model,
    COUNT(*) AS Total_Incidents
FROM Aircraft_Incident_Dataset
GROUP BY Aircraft_Model
ORDER BY Total_Incidents DESC
LIMIT 10;

-- Incidents by category --

SELECT 
    Incident_Category,
    COUNT(*) AS Incident_Count
FROM Aircraft_Incident_Dataset
GROUP BY Incident_Category
ORDER BY Incident_Count DESC;

-- Damaged Severity ---

SELECT 
    Aircraft_Damage_Type,
    COUNT(*) AS Cases
FROM Aircraft_Incident_Dataset
GROUP BY Aircraft_Damage_Type
ORDER BY Cases DESC;

-- Causes Nature V/S Manufacturing Defect ---

SELECT 
    CASE 
        WHEN Incident_Causes LIKE '%bird%' OR Incident_Causes LIKE '%weather%' THEN 'Natural'
        ELSE 'Human/Machine'
    END AS Cause_Type,
    COUNT(*) AS Total_Incidents
FROM Aircraft_Incident_Dataset
GROUP BY Cause_Type;


SELECT 
    CASE 
        WHEN HOUR(Incident_Time) BETWEEN 5 AND 11 THEN 'Morning'
        WHEN HOUR(Incident_Time) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN HOUR(Incident_Time) BETWEEN 18 AND 21 THEN 'Evening'
        ELSE 'Night'
    END AS Time_Slot,
    COUNT(*) AS Incident_Count
FROM Aircraft_Incident_Dataset
GROUP BY Time_Slot;

-- Detailed Time ---

SELECT incident_time,
    COUNT(*) AS Incident_Count
FROM Aircraft_Incident_Dataset
GROUP BY incident_time 
ORDER BY Incident_Count DESC 
LIMIT 10 ;

-- Fatalities V/S Survivours --

SELECT 
    YEAR(Incident_Date) AS Year,
    SUM(Fatalities) AS Total_Killed,
    SUM(Onboard_Total) - SUM(Fatalities) AS Total_Survivors
FROM Aircraft_Incident_Dataset
GROUP BY YEAR(Incident_Date)
ORDER BY Year;

-- High Risk Airports --

SELECT 
    Airport,
    COUNT(*) AS Incident_Count
FROM Aircraft_Incident_Dataset
GROUP BY Airport
ORDER BY Incident_Count DESC
LIMIT 10;

-- Most Dangerous Phase of flight --

SELECT 
    Aircraft_Phase,
    COUNT(*) AS Incident_Count,incident_causes
FROM Aircraft_Incident_Dataset
GROUP BY Aircraft_Phase,incident_causes 
ORDER BY Incident_Count DESC
LIMIT 5 ;

-- Monthly aircraft accidents per models --

SELECT 
  DATE_FORMAT(Incident_Date, '%Y-%m') AS Month_Year,
  Aircraft_Model,
  COUNT(*) AS Total_Incidents
FROM Aircraft_Incident_Dataset
GROUP BY Month_Year, Aircraft_Model
ORDER BY Month_Year DESC ;


-- YOY % --

WITH yearly_data AS (
  SELECT 
    YEAR(Incident_Date) AS Year,
    COUNT(*) AS Incidents
  FROM Aircraft_Incident_Dataset
  GROUP BY YEAR(Incident_Date)
)
SELECT 
  Year,
  Incidents,
  CONCAT(ROUND(((Incidents - LAG(Incidents) OVER (ORDER BY Year)) * 100.0) / 
        NULLIF(LAG(Incidents) OVER (ORDER BY Year), 0), 2),"%") AS YoY_Change_Percent
FROM yearly_data
ORDER BY year DESC;


-- Models With Maximum Damage ---

SELECT 
  Aircraft_Model,
  Aircraft_Damage_Type,
  COUNT(*) AS Count
FROM Aircraft_Incident_Dataset
GROUP BY Aircraft_Model, Aircraft_Damage_Type
ORDER BY Count DESC;

-- Types of incidents per year --

SELECT 
  YEAR(Incident_Date) AS Year,
  Incident_Category,
  COUNT(*) AS Total
FROM Aircraft_Incident_Dataset
GROUP BY Year, Incident_Category
ORDER BY Year DESC , Total DESC;

-- Total categories Count --

SELECT 
  Incident_Category,
  COUNT(*) AS Total_Cases
FROM Aircraft_Incident_Dataset
GROUP BY Incident_Category
ORDER BY Total_Cases DESC;

-- Most Common Causes per incidents --

WITH ranked_causes AS (
  SELECT 
    Incident_Category,
    Incident_Causes,
    COUNT(*) AS Cause_Count,
    ROW_NUMBER() OVER (PARTITION BY Incident_Category ORDER BY COUNT(*) DESC) AS rn
  FROM Aircraft_Incident_Dataset
  GROUP BY Incident_Category, Incident_Causes
)
SELECT Incident_Category, Incident_Causes, Cause_Count
FROM ranked_causes
WHERE rn = 1;


-- Models with most manufacturing related incidents causes --

SELECT 
  Aircraft_Model,
  COUNT(*) AS Manufacturing_Issues
FROM Aircraft_Incident_Dataset
WHERE LOWER(Incident_Causes) LIKE '%engine%'
GROUP BY Aircraft_Model
ORDER BY Manufacturing_Issues DESC
LIMIT 5;


-- Models name where accident occur due to pilot inefficiency --

SELECT 
  Aircraft_Model,
  COUNT(*) AS Pilot_Error_Cases
FROM Aircraft_Incident_Dataset
WHERE LOWER(Incident_Causes) LIKE '%loss of control%'
GROUP BY Aircraft_Model
ORDER BY Pilot_Error_Cases DESC
LIMIT 5 ;


-- Does age of aeroplanes affect the chances of incidents ---

SELECT 
  YEAR(Incident_Date) - Aircraft_First_Flight AS Aircraft_Age,
  COUNT(*) AS Total_Incident_Cases
FROM Aircraft_Incident_Dataset
WHERE Aircraft_First_Flight IS NOT NULL
GROUP BY Aircraft_Age
ORDER BY Aircraft_Age;


-- Models that have least no. of cases ---

SELECT 
  Aircraft_Model,
  COUNT(*) AS Total_Incidents
FROM 
  Aircraft_Incident_Dataset
WHERE 
  Aircraft_Model IS NOT NULL
GROUP BY 
  Aircraft_Model
ORDER BY 
  Total_Incidents ASC
LIMIT 5 ;



-- TABLE 3 : FLIGHT RATES AND DURATION --- 

CREATE TABLE Indian_Airlines (
  S_NO INT ,
  airline VARCHAR(100),
  flight VARCHAR(50),
  source_city VARCHAR(100),
  departure_time VARCHAR(20),
  stops VARCHAR(50),
  arrival_time VARCHAR(20),
  destination_city VARCHAR(100),
  class VARCHAR(20),
  duration FLOAT,
  days_left INT,
  price INT
);

DROP TABLE IF EXISTS Indian_Airlines ;

SELECT * FROM Indian_Airlines ;

-- Most Expensive Airline ---

SELECT airline, ROUND(AVG(price), 2) AS avg_price
FROM Indian_Airlines 
GROUP BY airline
ORDER BY avg_price DESC
LIMIT 1;

-- Cheapeast Route per class ---

SELECT source_city, destination_city, class, MIN(price) AS min_price
FROM flights
GROUP BY source_city, destination_city, class;

-- Average Price by number of stops --


SELECT stops, ROUND(AVG(price), 2) AS avg_price
FROM Indian_Airlines 
GROUP BY stops
ORDER BY avg_price;


-- No. of days V/S price rates --

SELECT days_left, ROUND(AVG(price), 2) AS avg_price
FROM Indian_Airlines 
GROUP BY days_left
ORDER BY days_left;

-- Most Freqeuent Destination --

SELECT destination_city, COUNT(*) AS total_flights
FROM Indian_Airlines 
GROUP BY destination_city
ORDER BY total_flights DESC
LIMIT 5;


-- Price trend  by departure timing ---

SELECT departure_time, ROUND(AVG(price), 2) AS avg_price
FROM Indian_Airlines 
GROUP BY departure_time
ORDER BY avg_price DESC;

-- Duration V/S price Insight --


SELECT 
  CASE 
    WHEN duration <= 2 THEN 'Short'
    WHEN duration BETWEEN 2 AND 4 THEN 'Medium'
    ELSE 'Long'
  END AS duration_type,
  ROUND(AVG(price), 2) AS avg_price
FROM Indian_Airlines 
GROUP BY duration_type;


-- Class Wise Pricing --

SELECT class, ROUND(AVG(price), 2) AS avg_price
FROM Indian_Airlines 
GROUP BY class;


-- Most Popular Airlines --

SELECT airline, COUNT(*) AS total_flights
FROM Indian_Airlines 
GROUP BY airline
ORDER BY total_flights DESC;


-- Routes with Highest fares --

SELECT source_city, destination_city, MAX(price) AS max_price
FROM Indian_Airlines 
GROUP BY source_city, destination_city
ORDER BY max_price DESC
LIMIT 1;


-- Shortest flight --

SELECT * 
FROM Indian_Airlines 
ORDER BY duration ASC 
LIMIT 1;

-- Longest flight
SELECT * 
FROM Indian_Airlines 
ORDER BY duration DESC 
LIMIT 1;


-- Flight Bookings based on timings --

SELECT 
  arrival_time,
  COUNT(*) AS flight_count
FROM Indian_Airlines 
GROUP BY arrival_time;


-- Flight price Comaprison b/w different Airlines -- ( CORRECT THIS ) ----

SELECT 
  source_city, 
  destination_city, 
  airline, 
  ROUND(AVG(price),2) AS price_difference
FROM Indian_Airlines 
GROUP BY source_city, destination_city, airline
ORDER BY price_difference DESC ;


SELECT * FROM Indian_Airlines ;

   