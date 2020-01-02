-- 1. Create a new table named 'bajaj1' containing the date, close price, 20 Day MA and 50 Day MA. (This has to be done for all 6 stocks)

/* The table consists of Date, Closing Price, 20 Days Moving Average and 50 Days Moving Average.
Moving Averages are calculated using windowing functionality of MySQL by creating a window consisting of current and 19/49 preceding rows.
For rows where moving avearage is not applicable, NULL is inserted.*/


-- Bajaj Auto
SET SESSION sql_mode = '';
DROP TABLE IF EXISTS Bajaj_Auto1;
CREATE TABLE Bajaj_Auto1
SELECT Date,
       Close_Price,
       IF(ROW_NUMBER() OVER W > 19, AVG(Close_Price) OVER (ORDER BY Date ROWS 19 PRECEDING), NULL) 20_Day_MA,
       IF(ROW_NUMBER() OVER W > 49, AVG(Close_Price) OVER (ORDER BY Date ROWS 49 PRECEDING), NULL) 50_Day_MA
FROM Bajaj_Auto
WINDOW W AS (ORDER BY Date);


-- Eicher Motors
SET SESSION sql_mode = '';
DROP TABLE IF EXISTS Eicher_Motors1;
CREATE TABLE Eicher_Motors1
SELECT Date,
       Close_Price,
       IF(ROW_NUMBER() OVER W > 19, AVG(Close_Price) OVER (ORDER BY Date ROWS 19 PRECEDING), NULL) 20_Day_MA,
       IF(ROW_NUMBER() OVER W > 49, AVG(Close_Price) OVER (ORDER BY Date ROWS 49 PRECEDING), NULL) 50_Day_MA
FROM Eicher_Motors
WINDOW W AS (ORDER BY Date);


-- Hero Motocorp
SET SESSION sql_mode = '';
DROP TABLE IF EXISTS Hero_Motocorp1;
CREATE TABLE Hero_Motocorp1
SELECT Date,
       Close_Price,
       IF(ROW_NUMBER() OVER W > 19, AVG(Close_Price) OVER (ORDER BY Date ROWS 19 PRECEDING), NULL) 20_Day_MA,
       IF(ROW_NUMBER() OVER W > 49, AVG(Close_Price) OVER (ORDER BY Date ROWS 49 PRECEDING), NULL) 50_Day_MA
FROM Hero_Motocorp
WINDOW W AS (ORDER BY Date);


-- Infosys
SET SESSION sql_mode = '';
DROP TABLE IF EXISTS Infosys1;
CREATE TABLE Infosys1
SELECT Date,
       Close_Price,
       IF(ROW_NUMBER() OVER W > 19, AVG(Close_Price) OVER (ORDER BY Date ROWS 19 PRECEDING), NULL) 20_Day_MA,
       IF(ROW_NUMBER() OVER W > 49, AVG(Close_Price) OVER (ORDER BY Date ROWS 49 PRECEDING), NULL) 50_Day_MA
FROM Infosys
WINDOW W AS (ORDER BY Date);


-- TCS
SET SESSION sql_mode = '';
DROP TABLE IF EXISTS TCS1;
CREATE TABLE TCS1
SELECT Date,
       Close_Price,
       IF(ROW_NUMBER() OVER W > 19, AVG(Close_Price) OVER (ORDER BY Date ROWS 19 PRECEDING), NULL) 20_Day_MA,
       IF(ROW_NUMBER() OVER W > 49, AVG(Close_Price) OVER (ORDER BY Date ROWS 49 PRECEDING), NULL) 50_Day_MA
FROM TCS
WINDOW W AS (ORDER BY Date);


-- TVS Motors
SET SESSION sql_mode = '';
DROP TABLE IF EXISTS TVS_Motors1;
CREATE TABLE TVS_Motors1
SELECT Date,
       Close_Price,
       IF(ROW_NUMBER() OVER W > 19, AVG(Close_Price) OVER (ORDER BY Date ROWS 19 PRECEDING), NULL) 20_Day_MA,
       IF(ROW_NUMBER() OVER W > 49, AVG(Close_Price) OVER (ORDER BY Date ROWS 49 PRECEDING), NULL) 50_Day_MA
FROM TVS_Motors
WINDOW W AS (ORDER BY Date);




-- 2. Create a master table containing the date and close price of all the six stocks. (Column header for the price is the name of the stock)

DROP TABLE IF EXISTS Master;
CREATE TABLE Master AS (
  SELECT 
    B.Date AS Date, 
    B.Close_Price AS Bajaj_Auto, 
    E.Close_Price AS Eicher_Motors, 
    H.Close_Price AS Hero_Motorcorp, 
    I.Close_Price AS Infosys, 
    TC.Close_Price AS TCS, 
    TV.Close_Price AS TVS_Motors 
  FROM 
    Bajaj_Auto B 
    INNER JOIN Eicher_Motors E ON B.Date = E.Date 
    INNER JOIN Hero_Motocorp H ON E.Date = H.Date 
    INNER JOIN Infosys I ON H.Date = I.Date 
    INNER JOIN TCS TC ON I.Date = TC.Date 
    INNER JOIN TVS_Motors TV ON TC.Date = TV.Date
);




-- 3. Use the table created in Part(1) to generate buy and sell signal. Store this in another table named 'bajaj2'. Perform this operation for all stocks.


/* The table consists of Date, Close Price and Signal. Signal was derived using moving averages calculated in previous steps.
Signal is generated only when there is a crossing point i.e. 20 days MA crosses the 50 days MA otherwise signal is HOLD.
To identify crossing points, previous row data along with current row is considered.*/


-- Bajaj Auto
DROP TABLE IF EXISTS Bajaj_Auto2;
CREATE TABLE Bajaj_Auto2
SELECT Date, Close_Price,
CASE
	WHEN `20_Day_MA` > `50_Day_MA` AND LAG(`20_Day_MA`,1) OVER W <= LAG(`50_Day_MA`,1) OVER W THEN 'BUY'
    WHEN `20_Day_MA` < `50_Day_MA` AND LAG(`20_Day_MA`,1) OVER W >= LAG(`50_Day_MA`,1) OVER W THEN 'SELL'
    ELSE 'HOLD'
END AS `Signal`
FROM Bajaj_Auto1
WINDOW W AS (ORDER BY Date);


-- Eicher Motors
DROP TABLE IF EXISTS Eicher_Motors2;
CREATE TABLE Eicher_Motors2
SELECT Date, Close_Price,
CASE
	WHEN `20_Day_MA` > `50_Day_MA` AND LAG(`20_Day_MA`,1) OVER W <= LAG(`50_Day_MA`,1) OVER W THEN 'BUY'
    WHEN `20_Day_MA` < `50_Day_MA` AND LAG(`20_Day_MA`,1) OVER W >= LAG(`50_Day_MA`,1) OVER W THEN 'SELL'
    ELSE 'HOLD'
END AS `Signal`
FROM Eicher_Motors1
WINDOW W AS (ORDER BY Date);


-- Hero Motorcorp
DROP TABLE IF EXISTS Hero_Motocorp2;
CREATE TABLE Hero_Motocorp2
SELECT Date, Close_Price,
CASE
	WHEN `20_Day_MA` > `50_Day_MA` AND LAG(`20_Day_MA`,1) OVER W <= LAG(`50_Day_MA`,1) OVER W THEN 'BUY'
    WHEN `20_Day_MA` < `50_Day_MA` AND LAG(`20_Day_MA`,1) OVER W >= LAG(`50_Day_MA`,1) OVER W THEN 'SELL'
    ELSE 'HOLD'
END AS `Signal`
FROM Hero_Motocorp1
WINDOW W AS (ORDER BY Date);


-- Infosys
DROP TABLE IF EXISTS Infosys2;
CREATE TABLE Infosys2
SELECT Date, Close_Price,
CASE
	WHEN `20_Day_MA` > `50_Day_MA` AND LAG(`20_Day_MA`,1) OVER W <= LAG(`50_Day_MA`,1) OVER W THEN 'BUY'
    WHEN `20_Day_MA` < `50_Day_MA` AND LAG(`20_Day_MA`,1) OVER W >= LAG(`50_Day_MA`,1) OVER W THEN 'SELL'
    ELSE 'HOLD'
END AS `Signal`
FROM Infosys1
WINDOW W AS (ORDER BY Date);


-- TCS
DROP TABLE IF EXISTS TCS2;
CREATE TABLE TCS2
SELECT Date, Close_Price,
CASE
	WHEN `20_Day_MA` > `50_Day_MA` AND LAG(`20_Day_MA`,1) OVER W <= LAG(`50_Day_MA`,1) OVER W THEN 'BUY'
    WHEN `20_Day_MA` < `50_Day_MA` AND LAG(`20_Day_MA`,1) OVER W >= LAG(`50_Day_MA`,1) OVER W THEN 'SELL'
    ELSE 'HOLD'
END AS `Signal`
FROM TCS1
WINDOW W AS (ORDER BY Date);


-- TVS Motors
DROP TABLE IF EXISTS TVS_Motors2;
CREATE TABLE TVS_Motors2
SELECT Date, Close_Price,
CASE
	WHEN `20_Day_MA` > `50_Day_MA` AND LAG(`20_Day_MA`,1) OVER W <= LAG(`50_Day_MA`,1) OVER W THEN 'BUY'
    WHEN `20_Day_MA` < `50_Day_MA` AND LAG(`20_Day_MA`,1) OVER W >= LAG(`50_Day_MA`,1) OVER W THEN 'SELL'
    ELSE 'HOLD'
END AS `Signal`
FROM TVS_Motors1
WINDOW W AS (ORDER BY Date);




-- 4. Create a User defined function, that takes the date as input and returns the signal for that particular day (Buy/Sell/Hold) for the Bajaj stock.

/*Following function searches the input date in the table and returns the respective BUY, SELL or HOLD Signal*/

-- Function definition
DROP FUNCTION IF EXISTS Action_Signal;
DELIMITER $$
CREATE FUNCTION Action_Signal (d Date) RETURNS VARCHAR(4) DETERMINISTIC
BEGIN
	SET @s = NULL;
	SELECT `Signal` INTO @s FROM Bajaj_Auto2 WHERE Date = d;
RETURN @s;
END $$
DELIMITER ;

-- Function call
SELECT Action_Signal('2016-01-18');
