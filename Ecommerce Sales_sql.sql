create database capstone;
use capstone;
show tables;
describe ecommerce_sales;
describe last_6_month;
ALTER TABLE last_6_month 
CHANGE COLUMN product_id  id int;

show tables;
# we have 2 tables , where in table name ecommerce_sales we have product_id , 
# product_name,category , price, reviews_score, review_count amd sales of 1st 6 months 
# and in the 2nd half sales information is present in the table last_6_ month 

SHOW COLUMNS FROM ecommerce_sales;
SHOW COLUMNS FROM last_6_month;

# creating a table 
CREATE TABLE data AS
SELECT ecommerce_sales.*, last_6_month.*
FROM ecommerce_sales
LEFT JOIN last_6_month
ON ecommerce_sales.product_id = last_6_month.id
UNION
SELECT ecommerce_sales.*, last_6_month.*
FROM ecommerce_sales
RIGHT JOIN last_6_month
ON ecommerce_sales.product_id = last_6_month.id;

show tables;
select * from data;

select category , sales_month_1+sales_month_2+sales_month_3+sales_month_4+sales_month_5+sales_month_6 as fisrt_6_months_sales from data group by category ;
select category , count(product_id) from data group by category;
select category , count(product_id) ,avg((sales_month_1+sales_month_2+sales_month_3+sales_month_4+sales_month_5+sales_month_6 )) from data group by category;

 



CREATE  or replace VIEW fisrt_half_2nd_half_avg_sales as SELECT 
    category,
    (AVG(sales_month_1) + AVG(sales_month_2) + AVG(sales_month_3) + 
     AVG(sales_month_4) + AVG(sales_month_5) + AVG(sales_month_6)) / 6 AS avg_of_1st_6month ,
     (AVG(sales_month_7) + AVG(sales_month_8) + AVG(sales_month_9) + 
     AVG(sales_month_10) + AVG(sales_month_11) + AVG(sales_month_12)) / 6 AS avg_of_last_6month
FROM data GROUP BY category;
    
    select * from data; 
    drop view cat_1st_6months;
    
create view revenue as SELECT product_id,product_name,
    category,price,review_count,review_score,
    sales_month_1 * price AS revenue_month_1,
    sales_month_2 * price AS revenue_month_2,
    sales_month_3 * price AS revenue_month_3,
    sales_month_4 * price AS revenue_month_4,
    sales_month_5 * price AS revenue_month_5,
    sales_month_6 * price AS revenue_month_6,
    sales_month_7 * price AS revenue_month_7,
    sales_month_8 * price AS revenue_month_8,
    sales_month_9 * price AS revenue_month_9,
    sales_month_10 * price AS revenue_month_10,
    sales_month_11* price AS revenue_month_11,
    sales_month_12 * price AS revenue_month_12
FROM  data; 

select * from data;
select distinct category from data;

# category count 
select category ,count(product_id) from data group by category ;

# missing value check 
Select * FROM data WHERE category is null;
select * from data where price is null or review_score is null ;

#Q1 : Total Annual Sales per Product
SELECT 
    product_name,
    category,
    SUM(sales_month_1 + sales_month_2 + sales_month_3 + sales_month_4 + sales_month_5 + 
        sales_month_6 + sales_month_7 + sales_month_8 + sales_month_9 + sales_month_10 + 
        sales_month_11 + sales_month_12) AS total_annual_sales
FROM 
    data
GROUP BY 
    product_name, category order by  total_annual_sales desc; # from this we get to know product_224 from electornics cateogory have most number of sales throught out the year
    
# Q2: 2. Monthly Sales Trends per Product
SELECT 
    product_name,
    category,
    sales_month_1, sales_month_2, sales_month_3, sales_month_4, sales_month_5, 
    sales_month_6, sales_month_7, sales_month_8, sales_month_9, sales_month_10, 
    sales_month_11, sales_month_12
FROM 
    data;
    
 #Q3: Average Monthly Sales per Product   
 
SELECT 
    category,
    AVG(sales_month_1 + sales_month_2 + sales_month_3 + sales_month_4 + sales_month_5 + 
        sales_month_6 + sales_month_7 + sales_month_8 + sales_month_9 + sales_month_10 + 
        sales_month_11 + sales_month_12) / 12 AS average_monthly_sales
FROM 
    data
GROUP BY 
    category; 
    
#4 :  total revene 
SELECT 
    category,
    SUM((sales_month_1 + sales_month_2 + sales_month_3 + sales_month_4 + sales_month_5 + 
         sales_month_6 + sales_month_7 + sales_month_8 + sales_month_9 + sales_month_10 + 
         sales_month_11 + sales_month_12) * price) AS total_revenue
FROM 
    data
GROUP BY 
    category order by total_revenue desc;    # books have generated the most amount of total_revenue
    
# 5 : correlation between reviews_score and sales 
SELECT 
    product_name,
    category,
    review_score,
    SUM(sales_month_1 + sales_month_2 + sales_month_3 + sales_month_4 + sales_month_5 + 
        sales_month_6 + sales_month_7 + sales_month_8 + sales_month_9 + sales_month_10 + 
        sales_month_11 + sales_month_12) AS total_annual_sales
FROM 
    data
GROUP BY 
    product_name, category, review_score order by review_score desc;    
    
 #6. Top Products by Review Score
 SELECT 
    product_name,
    category,
    review_score,
    review_count
FROM 
    data
ORDER BY 
    review_score DESC, review_count DESC
LIMIT 10;
    
 # 8. Seasonal Analysis by Category 
SELECT 
    category,
    SUM(sales_month_1 + sales_month_2 + sales_month_3) AS Q1_sales,
    SUM(sales_month_4 + sales_month_5 + sales_month_6) AS Q2_sales,
    SUM(sales_month_7 + sales_month_8 + sales_month_9) AS Q3_sales,
    SUM(sales_month_10 + sales_month_11 + sales_month_12) AS Q4_sales
FROM 
    data
GROUP BY 
    category  ;  
    
# 9 : total differece in sales in the gape of a year 
  SELECT 
    category, 
    sum(sales_month_12)- sum(sales_month_1) AS diff
FROM data GROUP BY category ORDER BY diff DESC LIMIT 0, 1000;  

select * from data where sales_month_1>sales_month_12; # these are the product which very bad after the  gap of a year 

#10: 
select * from data where review_score >3.5 and review_count >100 order by review_score desc; # best views and most popular product with minimum 100+ review_count 
select * from data ;



CREATE TABLE product_sales_summary (
    product_id INT PRIMARY KEY,
    total_quantity_sold INT DEFAULT 0,
    total_sales DECIMAL(10,2) DEFAULT 0.00
);

DELIMITER //

CREATE TRIGGER after_order_insert
AFTER INSERT ON data
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM product_sales_summary WHERE product_id = NEW.product_id) THEN
        UPDATE product_sales_summary
        SET total_quantity_sold = total_quantity_sold + NEW.quantity,
            total_sales = total_sales + NEW.total_sales
        WHERE product_id = NEW.product_id;
    ELSE
        INSERT INTO product_sales_summary (product_id, total_quantity_sold, total_sales)
        VALUES (NEW.product_id, NEW.quantity, NEW.total_sales);
    END IF;
END; //

DELIMITER ;
select * from data;
    
    
    