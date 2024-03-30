/* Making SQL Table */

use churn;

select *
from 421_data_hw_final_v2;

SET SQL_SAFE_UPDATES = 0;

/* sales_order table*/

CREATE TABLE sales_order 
(
    orderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    PreferedOrderCat TEXT,
    OrderAmountHikeFromlastYear INT,
    OrderCount INT
);

INSERT INTO sales_order (CustomerID, PreferedOrderCat,OrderAmountHikeFromlastYear,OrderCount) 
SELECT CustomerID, PreferedOrderCat,OrderAmountHikeFromlastYear,OrderCount
FROM 421_data_hw_final_v2;

SELECT * 
FROM sales_order;

ALTER TABLE sales_order
MODIFY COLUMN PreferedOrderCat VARCHAR(30);

/* location table*/

CREATE TABLE location 
(
    CustomerID INT PRIMARY KEY,
    CityTier INT,
    WarehouseToHome TEXT
);

INSERT INTO location (CustomerID, CityTier, WarehouseToHome) 
SELECT CustomerID, CityTier,WarehouseToHome
FROM 421_data_hw_final_v2;

SELECT * 
FROM location;

ALTER TABLE location
MODIFY COLUMN WarehouseToHome VARCHAR(30);

/* complain table*/

CREATE TABLE complain
(
    CustomerID INT PRIMARY KEY,
    Complain INT 
);

INSERT INTO complain (CustomerID, Complain)
SELECT CustomerID, Complain
FROM 421_data_hw_final_v2;

SELECT * 
FROM complain;

/* satisfactionscore table*/

CREATE TABLE satisfactionscore 
(
    CustomerID INT PRIMARY KEY,
    SatisfactionScore INT
    
);

INSERT INTO satisfactionscore (CustomerID, SatisfactionScore)
SELECT CustomerID,SatisfactionScore
FROM 421_data_hw_final_v2;

SELECT * 
FROM satisfaction;

ALTER TABLE satisfactionscore
RENAME TO satisfaction;


/* user_interaction table*/
CREATE TABLE user_interaction 
(
    CustomerID INT PRIMARY KEY ,
    PreferredLoginDevice TEXT,
    HourSpendOnApp INT,
    NumberOfDeviceRegistered TEXT,
    DaySinceLastOrder INT
);

INSERT INTO user_interaction (CustomerID, PreferredLoginDevice,HourSpendOnApp,NumberOfDeviceRegistered,DaySinceLastOrder)
SELECT CustomerID, PreferredLoginDevice,HourSpendOnApp,NumberOfDeviceRegistered,DaySinceLastOrder
FROM 421_data_hw_final_v2;

select *
from user_interaction;

ALTER TABLE user_interaction
MODIFY COLUMN PreferredLoginDevice VARCHAR(30),
MODIFY COLUMN NumberOfDeviceRegistered VARCHAR(30);


/* customer table*/
CREATE TABLE customer 
(
    CustomerID INT PRIMARY KEY ,
    Churn TEXT,
    Tenure INT,
    CityTier TEXT,
    Gender TEXT,
    MaritalStatus TEXT,
    NumberOfAddress INT
);

ALTER TABLE customer
MODIFY COLUMN Churn VARCHAR(30),
MODIFY COLUMN CityTier VARCHAR(30),
MODIFY COLUMN Gender VARCHAR(30),
MODIFY COLUMN MaritalStatus VARCHAR(30);

INSERT INTO customer (CustomerID, Churn,Tenure,CityTier,Gender,MaritalStatus,NumberOfAddress)
SELECT CustomerID, Churn,Tenure,CityTier,Gender,MaritalStatus,NumberOfAddress
FROM 421_data_hw_final_v2;

select *
from customer;

/* payment table*/
CREATE TABLE payment 
(
    paymentID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    PreferredPaymentMode TEXT,
    CouponUsed INT,
    CashbackAmount INT
);

INSERT INTO payment (CustomerID, PreferredPaymentMode,CouponUsed,CashbackAmount)
SELECT CustomerID, PreferredPaymentMode,CouponUsed,CashbackAmount
FROM 421_data_hw_final_v2;

select *
from payment;

ALTER TABLE payment
MODIFY COLUMN PreferredPaymentMode VARCHAR(30);

////////////////* 8 business quesions */////////////////////////

/* Q1. The relationship between Churn and complain / satisfaction level */

/*  complain & churn */
SELECT
    complain,
    COUNT(*) AS ChurnCount
FROM customer c
INNER JOIN complain cp ON c.customerid = cp.customerid
WHERE churn = 1
GROUP BY complain
ORDER BY complain;

/*  satisfaction & churn */
SELECT
    SatisfactionScore,
    COUNT(*) AS ChurnCount
FROM customer c
INNER JOIN satisfaction s ON c.customerid = s.customerid
WHERE churn = 1
GROUP BY SatisfactionScore
ORDER BY SatisfactionScore;

/* Q2. The relationship between tenure & Churn status*/


/* tenure& churn*/
SELECT
	CASE 
        WHEN tenure < 5 THEN 'Less than 5yr'
        WHEN tenure >= 5 AND tenure <= 10 THEN '5-10yr'
        WHEN tenure > 10 AND tenure <= 20 THEN '10-20yr'
        WHEN tenure > 20 THEN 'Over 20yr'
        ELSE 'others'
    END AS Tenure_Range,
    CONCAT(ROUND((COUNT(customerid) / (SELECT COUNT(*) FROM customer)) * 100, 1), '%') AS Cust_Portion,
    CONCAT(ROUND((SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) / (SELECT COUNT(*) FROM customer WHERE churn = 1)) * 100, 1), '%') AS Churn_Portion,
    CONCAT(ROUND((SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) / COUNT(CASE WHEN churn = 1 THEN 1 ELSE 0 END)) * 100, 1), '%') AS Churn_Rate
FROM customer
GROUP BY Tenure_Range
ORDER BY
    CASE 
        WHEN Tenure_Range = 'Less than 5yr' THEN 1
        WHEN Tenure_Range = '5-10yr' THEN 2
        WHEN Tenure_Range = '10-20yr' THEN 3
        WHEN Tenure_Range = 'Over 20yr' THEN 4
        ELSE 5
    END;
    
    
/* tenure& churn only less than 5yrs */
SELECT
	Tenure,
    CONCAT(ROUND((COUNT(customerid) / (SELECT COUNT(*) FROM customer)) * 100, 1), '%') AS Cust_Portion,
    CONCAT(ROUND((SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) / (SELECT COUNT(*) FROM customer WHERE churn = 1)) * 100, 1), '%') AS Churn_Portion,
    CONCAT(ROUND((SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) / COUNT(CASE WHEN churn = 1 THEN 1 ELSE 0 END)) * 100, 1), '%') AS Churn_Rate
FROM customer
WHERE tenure < 5
GROUP BY Tenure
ORDER BY Tenure;   
    
    
 /* Q3)	The relationship between tenure and customer satisfaction */

SELECT
    SatisfactionScore,
    Less_than_5yr,
    `5-10yr` AS "5-10yr",
    `10-20yr` AS "10-20yr",
    `Over_20yr` AS "Over 20yr",
    Others
FROM (
    SELECT
        SatisfactionScore,
        SUM(CASE WHEN Tenure_Range = 'Less than 5yr' THEN 1 ELSE 0 END) AS Less_than_5yr,
        SUM(CASE WHEN Tenure_Range = '5-10yr' THEN 1 ELSE 0 END) AS `5-10yr`,
        SUM(CASE WHEN Tenure_Range = '10-20yr' THEN 1 ELSE 0 END) AS `10-20yr`,
        SUM(CASE WHEN Tenure_Range = 'Over 20yr' THEN 1 ELSE 0 END) AS `Over_20yr`,
        SUM(CASE WHEN Tenure_Range = 'others' THEN 1 ELSE 0 END) AS Others
    FROM (
        SELECT
            s.SatisfactionScore,
            CASE 
                WHEN c.tenure < 5 THEN 'Less than 5yr'
                WHEN c.tenure >= 5 AND c.tenure <= 10 THEN '5-10yr'
                WHEN c.tenure > 10 AND c.tenure <= 20 THEN '10-20yr'
                WHEN c.tenure > 20 THEN 'Over 20yr'
                ELSE 'others'
            END AS Tenure_Range
        FROM customer c
        INNER JOIN satisfaction s ON c.customerid = s.customerid
    ) AS Subquery
    GROUP BY SatisfactionScore
) AS PivotTable
ORDER BY SatisfactionScore;
   

/* Q4.The relationship between preferred order category and Churn.*/
SELECT
PreferedOrderCat,
COUNT(*) AS ChurnCount
FROM customer c
INNER JOIN sales_order so ON c.customerid = so.customerid
WHERE churn = 1
GROUP BY PreferedOrderCat
ORDER BY 1;

/*Q5)Which MartialStatus has the highest Churn rate */
SELECT
    MaritalStatus,
    COUNT(*) AS TotalCustomers,
    SUM(churn = 1) AS ChurnCount,
    CONCAT(ROUND((SUM(churn = 1) / COUNT(*)) * 100, 1), '%') AS ChurnPercentage
FROM customer
GROUP BY MaritalStatus
ORDER BY ChurnCount DESC;


/*Q6)Marital status&product category and churn */
SELECT
    MaritalStatus,
    PreferedOrderCat,
    COUNT(*) AS ChurnCount,
    CONCAT(ROUND((COUNT(*) / (SELECT COUNT(*) FROM customer WHERE churn = 1)) * 100, 1), '%') AS ChurnPercentage
FROM customer c
INNER JOIN sales_order so ON so.customerid = c.customerid
WHERE churn = 1
GROUP BY MaritalStatus, PreferedOrderCat
ORDER BY 1, 2;


/* Q7) daysincelastorder & churn */
SELECT
    last_order_days,
    COUNT(*) AS TotalCustomers,
    COUNT(CASE WHEN churn = 1 THEN 1 END) AS ChurnCount,
    CONCAT(ROUND((COUNT(CASE WHEN churn = 1 THEN 1 END) / COUNT(*)) * 100, 1), '%') AS ChurnPercentage
FROM (
    SELECT
        CASE 
            WHEN daysincelastorder < 5 THEN 'Less than 5days'
            WHEN daysincelastorder >= 5 AND daysincelastorder <= 10 THEN '5-10days'
            ELSE 'more than 10days'
        END AS last_order_days,
        churn
    FROM customer c
    INNER JOIN user_interaction ui ON c.customerid = ui.customerid
) AS Subquery
GROUP BY last_order_days
ORDER BY
    CASE 
        WHEN last_order_days = 'Less than 5days' THEN 1
        WHEN last_order_days = '5-10days' THEN 2
        ELSE 3
    END;



/* Q8)	The relationship between cashback amount and Churn, and the relationship with complain and cash back?*/

SELECT
    warehousetohome,
    COUNT(*) AS TotalCustomers,
    SUM(churn = 1) AS ChurnCount,
    CONCAT(ROUND((COUNT(*) / (SELECT COUNT(*) FROM customer WHERE churn = 1)) * 100, 1), '%') AS ChurnPercentage
FROM customer c
INNER JOIN location l ON c.customerid = l.customerid 
GROUP BY warehousetohome
ORDER BY ChurnPercentage ASC;

SELECT
    warehousetohome,
    COUNT(*) AS TotalCustomers,
    SUM(churn = 1) AS ChurnCount,
    CONCAT(ROUND((SUM(churn = 1) / (SELECT COUNT(*) FROM customer WHERE churn = 1)) * 100, 1), '%') AS ChurnPercentage
FROM customer c
INNER JOIN location l ON c.customerid = l.customerid 
GROUP BY warehousetohome
ORDER BY ChurnPercentage ASC;



