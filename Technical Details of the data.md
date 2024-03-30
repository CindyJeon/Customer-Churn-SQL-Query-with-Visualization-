
**[ E-Commerce Customer Churn Data Set Explanation]**

**1.	Discussion of how I converted the dataset into tables**. 

I structured database by creating seven tables to capture different aspects of my data. The tables and the characteristics of the tables are as below.
This structure will allow for a comprehensive representation of the dataset, enabling me to analyze different dimensions of customer behavior and business performance. The relationships between these tables, established through keys, will be essential for querying and gaining insights across the various aspects of the data. 

1). Customer Table
   - Contains personal information such as gender, marriage status, tenure, churn status.

2). User Interaction Table
   - Captures data related to how users interact with the app and the number of devices registered on the site.

3 / 4) Satisfaction and Complain Table
   - Stores information about customer satisfaction and any complaints they may have.

5). Location Table
   - Includes city tier for customers' houses and the distance of the warehouse to customers' homes.

6). Sales Order Table
   - Provides details on the number of orders each customer made and tracks sales increases compared to the previous year.

7). Payment Information Table
   - Contains data related to payment methods preferred by customers, coupon usage, and cashback received with purchases.

**2.	Challenges faced during importing of the data and how I overcome these data importation challenges**. 

1).	Data type error when importing to SQL
-	First of all, my computer is mac, so I had to change xlxs. file to JSON type. However, when I converted the file type to JSON, the data were transferred to the empty cells, resulting in the data being corrupted. It turned out that I had many cells without data.

2).	Dealing with missing values
-	I had to update those empty cells with  ‘NULL’ values instead of  removing them.
-	There were 1856 missing values and the rows with the number of missing values were exactly the same as 1856 which means that all the missing values are in the different rows.
-	Total number of raws of the data was 5630 but the rows with missing values were 33% which is one third of the data; therefore, I did not delete the rows with missing values but decided to keep them for the sake of reliability of the data. 
. The number of missing values: 1856
. The number of rows with missing values: 1856
. The percentage of the missing values out of the total data : 33%      

3).	The number of limit rows in mySQL
-	Since this is my first time using SQL, I did not realize there was a limits in the rows, but I was able to change the limit from 1000 to 10000 since my data has 55630 rows. 

4).	Issues with selecting primary keys
-	Although the primary key is expected to be a unique identifier, I initially overlooked this requirement, resulting in the selecting of columns that lacked this uniqueness attribute. Consequently, I encountered difficulties storing data in the tables I had created. To fix this issue, I modified the primary keys to the unique identifier criterion, specifically using 'CustomerID' in certain tables. This adjustment successfully resolved the problem. Additionally, I learned that I could create new columns as primary keys and that I can assign numerical values to it. This experience was very intriguing yet vital lesson in managing SQL tables. 

**3.	A complete data dictionary for every table in your database**. 

<img width="950" alt="image" src="https://github.com/CindyJeon/ecommerce/assets/157195682/a49349cf-7782-4828-9ab7-47a01b263866">
<img width="928" alt="image" src="https://github.com/CindyJeon/ecommerce/assets/157195682/7dec20a9-e094-4306-9f84-c543368d7bc9">
<img width="928" alt="image" src="https://github.com/CindyJeon/ecommerce/assets/157195682/f37c32ce-ce0a-4e5f-a95f-d72d93ff2e25">


