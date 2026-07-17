use customer_behavior
select * from customer limit 20

-- Q1. what is the  total revenue genrated by male vs female customers?

select Gender,sum(purchase_Amount) as revenue 
from customer
group by gender;


-- Q2. Which Customers Used a Discount but still Spent More Than the Average Purchase amount?

select Customer_id,purchase_amount 
from customer
where discount_applied = 'yes' and purchase_amount >= (select avg(Purchase_Amount) from customer)


-- Q3. Which are the Top 5 Products with the Highest Average Review Rating?

select item_purchased,round(avg(review_rating),2) as Highest_Average_Review_Rating
from customer
group by item_purchased
order by avg(review_rating) desc limit 5
 

-- Q4. Compare the Average Purchase Amounts between standard and Express Shipping.

select shipping_type,round(avg(purchase_amount),2) 
from customer 
where shipping_type in ('Standard','Express')
group by shipping_type


-- Q5. Do Subscribed customers spend more? Compare average spend and total revenue between Subscribers and Non-Subscribers ?

select subscription_status,
count(customer_id) as total_customers,
round(avg(purchase_amount),2) as average_spend,
round(sum(purchase_amount),2)as total_revenue
from customer
group by subscription_status


-- Q6. Which 5 products have the highest percentage of purchases with discount applied?

select item_purchased,
round(100 * sum(case when discount_applied ='yes' then 1 else 0 end)/count(*),2) as discount_rate
from customer
group by item_purchased
order by discount_rate desc
limit 5 


-- Q7. Segment customers into New, Returning,and Loyal Based on their Total number of
-- previous purchases, and show the count of ecah segment.

with customer_type as(
select customer_id,previous_purchases,
case when previous_purchases = 1 then "New"
	when previous_purchases between 2 and 10 then "Returning"
    else "Loyal"
    end as customer_segment
    from customer )
select customer_segment,count(*) as 'num of customers'
from customer_type
group by customer_segment


-- Q8. What are the top 3  most purchased products within each category?

with item_count as(
select category,item_purchased,
count(customer_id) as total_orders
from customer
group by category,item_purchased),
ranked_items as(select *,
row_number() over (partition by category order by total_orders desc) as item_rank
from item_count)
select item_rank,category,item_purchased,total_orders
from ranked_items
where item_rank <= 3


-- Q9. Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe?

select subscription_status,
count(customer_id) as repeat_buyers
from customer
where previous_purchases > 5 
group by subscription_status


-- Q10. What is the revenue contribution of each age group?

select age_group,sum(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue desc
