-- database created 
create database zepto 

-- create table
create table zepto_data(
	sku_id int auto_increment primary key,
	category varchar(100),
	name varchar(100) not null,
	mrp numeric(8,2),
	discount_percent numeric(5,2),
	available_quantity int,
	discounted_selling_price numeric(8,2),
	weightinGMS int,
	outofstock boolean default false,
	quantity int
);
select * from zepto_data;
-- values inserted via import 

-- finding different product category
select distinct category
from zepto_data
order by category;

-- product in stock or out of stock
select outofstock, count(sku_id)
from zepto_data
group by outofstock;

-- product names present multiple times
select name,count(sku_id) as "number of sku"
from zepto_data
group by name
having count(sku_id)>1
order by count(sku_id) desc;

-- data cleaning--
-- product with price=0 
select * from zepto_data
where mrp=0 or discountedSellingPrice=0;

delete from zepto_data
where mrp=0;

-- Convert paise to rupees
update zepto_data
set mrp=mrp/100.0,
discountedSellingPrice=discountedSellingPrice/100.0;
select * from zepto_data;

-- Questions-- 
-- Q. Find the top 10 best value product based on the discounted percentage.
select distinct name, mrp, discountPercent
from zepto_data
order by discountPercent desc
limit 10;

-- Q. What are the products with High mrp but out of stock.
select distinct name, mrp, outOfStock
from zepto_data
where outOfStock="True" and mrp>300
order by mrp desc;

-- Q. Calculate estimated revnue for each category.
select category, sum(discountedSellingPrice * availableQuantity) as Total_revenue
from zepto_data
group by category
order by Total_revenue;

-- Q. Find all the product where mrp>500 and discount<10%.
select distinct name, mrp, discountPercent
from zepto_data
where mrp>500 and discountPercent<10
order by mrp desc;

-- Q. Identify the top 5 categories offering the highest average discount perentage.
select category, round(avg(discountPercent),2) as avg_discount
from zepto_data
group by category
order by avg_discount desc
limit 5;

-- Q. Find the price per gram for products above 100g and sort by best value.
select distinct name, discountedSellingPrice, weightinGms,
Round(discountedSellingPrice/weightinGms, 2) as Price_per_gram
from zepto_data
where weightinGms >= 100
order by Price_per_gram;

-- Q. Group the products into categories like low,medium,bulk.
select distinct name, weightingms, 
case when weightingms < 1000 then "Low"
	when weightingms > 1000 and weightingms  < 5000 then "Medium"
    else "Bulk"
end as weight_category
from zepto_data;

-- Q. What is the total inventory weight by category.
select category,sum(weightingms*availablequantity) as Total_weight
from zepto_data
group by category
order by Total_weight;