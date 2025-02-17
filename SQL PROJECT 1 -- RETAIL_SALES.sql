---- CREATE TABLE ------
DROP TABLE IF EXISTS RETAIL_SALES ;
CREATE TABLE RETAIL_SALES
(
	transactions_id	INT PRIMARY KEY, 
	sale_date DATE,	
	sale_time TIME,
	customer_id	INT,
	gender VARCHAR(15),	
	age	 INT,
	category VARCHAR(15),
	quantiy INT,	
	price_per_unit	FLOAT,
	cogs	FLOAT,
	total_sale FLOAT

)
--- DATA CLEANING --- 
SELECT * FROM RETAIL_SALES;

SELECT COUNT(*) FROM RETAIL_SALES;

SELECT * FROM RETAIL_SALES 
 WHERE 
transactions_id IS NULL OR 	
sale_date	IS  NULL OR
sale_time	IS  NULL OR
customer_id	IS  NULL OR 
gender	    IS  NULL OR
category	IS  NULL OR
quantiy	    IS  NULL OR
price_per_unit	 IS  NULL OR
cogs		IS  NULL OR
total_sale  IS  NULL ;

SELECT * FROM RETAIL_SALES;
--DELETE FROM RETAIL_SALES WHERE quantiy IS  NULL;

------- DATA EXPLORATION ------

-- HOW MANY SALES/RECORDS WE HAVE .. ?

SELECT COUNT(*) AS TOTAL_SALE FROM RETAIL_SALES;

-- HOW MANY UNIQUE CUSTOMERS WE HAVE .. ? 

SELECT COUNT(DISTINCT CUSTOMER_ID) AS CUSTOMERS FROM RETAIL_SALES;

-- HOW MANY CATEGORIES WE HAVE .. ? 

SELECT DISTINCT CATEGORY FROM RETAIL_SALES;

SELECT * FROM RETAIL_SALES ORDER BY 1;

--- DATA ANALYSIS & BUSINESS KEY PROBLEMS AND ANSWERS ---

--- 1...Write a SQL query to retrieve all columns for sales made on '2022-11-05'

SELECT * FROM RETAIL_SALES WHERE SALE_DATE = TO_DATE('05-11-2022','DD-MM-YYYY');

/* 2... Write a SQL query to retrieve all transactions where the category is 'Clothing' 
and the quantity sold is more than 4 in the month of Nov-2022 */

SELECT * FROM RETAIL_SALES 
WHERE CATEGORY = 'Clothing'
AND quantiy >= 4
AND TO_CHAR(SALE_DATE,'YYYY-MM') = '2022-11' ORDER BY 1;

-- Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
CATEGORY , 
COUNT(*) AS TOTAL_ORDERS,
SUM (TOTAL_SALE) AS NET_SALES 
FROM  RETAIL_SALES
GROUP BY 1; 

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT ROUND(AVG(AGE),2) AS AVG_AGE FROM RETAIL_SALES WHERE  CATEGORY ='Beauty';

--Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM RETAIL_SALES WHERE TOTAL_SALE > 1000;

/* Write a SQL query to find the total number of transactions (transaction_id) 
made by each gender in each category. */

select distinct category,gender, count (transactions_id) from RETAIL_SALES
group by category,gender  ;

/* Write a SQL query to calculate the average sale for each month. Find out best selling month in each year*/

select * from 
(select to_char(sale_date,'MM') as month,
to_char(sale_date,'yyyy') as year ,
round(avg(total_sale)::numeric,2) avg_sale,
rank() over(partition by to_char(sale_date,'yyyy') order by round(avg(total_sale)::numeric,2)   desc) as rn
from 
retail_sales  
group by 1,2) as x
where x.rn=1;

/*Write a SQL query to find the top 5 customers based on the highest total sales */

select customer_id , 
sum(total_sale) 
from RETAIL_SALES 
group by customer_id
order by 1,2 desc
limit 5;

/*Write a SQL query to find the number of unique customers who purchased items from each category*/

select  count(distinct customer_id), category from retail_sales group by 2 order by 1; 

/*Write a SQL query to create each shift and number of orders
(Example Morning <12, Afternoon Between 12 & 17, Evening >17):*/


SELECT * FROM RETAIL_SALES;

with cte 
as
(select 
 case when extract (hour from sale_time)< 12 then 'Morning'
 	  when extract (hour from sale_time) between 12 and 17 then 'Afternoon'
 	  else 'Evening'
 end as shift 
from retail_sales
)
select 
shift ,count(*)
from cte  
group by shift 
order by 2;


















