# Anotações Módulo 3 - Agregação

## INTRODUÇÃO

## SUM

# Find the total amount of poster_qty paper ordered in the orders table.

# Find the total amount of standard_qty paper ordered in the orders table.

# Find the total dollar amount of sales using the total_amt_usd in the orders table.

    SELECT SUM(poster_qty) AS poster,
          SUM(standard_qty) AS standard,
          SUM(total_amt_usd) AS total_usd
    FROM orders;

# Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table. This should give a dollar amount for each order in the table.

    SELECT id, standard_qty + gloss_amt_usd AS standard_and_gloss
    FROM orders;

# Find the standard_amt_usd per unit of standard_qty paper. Your solution should use both an aggregation and a mathematical operator.

    SELECT SUM(standard_amt_usd) as standard_amt, SUM(standard_qty) as standard_qty, SUM(standard_amt_usd) / SUM(standard_qty) valor_standard_unitario
    FROM orders;

## MIN, MAX e AVG

# When was the earliest order ever placed? You only need to return the date.

    SELECT MIN(occurred_at)
    FROM orders;

# Try performing the same query as in question 1 without using an aggregation function.

    SELECT occurred_at AS oldest_order
    FROM orders
    ORDER BY occurred_at
    LIMIT 1;

# When did the most recent (latest) web_event occur?

    SELECT MAX(occurred_at) AS latest_order
    FROM web_events;

# Try to perform the result of the previous query without using an aggregation function.

    SELECT occurred_at AS latest_order
    FROM web_events
    ORDER BY occurred_at DESC
    LIMIT 1;

# Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order. Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.

    SELECT AVG(standard_qty) avg_standard_qty,
           AVG(gloss_qty) avg_gloss_qty,
           AVG(poster_qty) avg_poster_qty,
           AVG(standard_amt_usd) avg_standard_ticket,
           AVG(gloss_amt_usd) avg_gloss_ticket,
           AVG(poster_amt_usd) avg_poster_ticket
    FROM orders;

# Via the video, you might be interested in how to calculate the MEDIAN. Though this is more advanced than what we have covered so far try finding - what is the MEDIAN total_usd spent on all orders?

    SELECT AVG(total_amt_usd)
    FROM orders
    WHERE id = 6912/2 OR id = (6912/2 + 1);

## GROUP BY

# Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.

    SELECT o.occurred_at AS date,
          a.name AS nome_conta
    FROM accounts AS a
    JOIN orders AS o
    ON a.id = o.account_id
    ORDER BY date
    LIMIT 1;

# Find the total sales in usd for each account. You should include two columns - the total sales for each company''s orders in usd and the company name.

    SELECT a.name,
          SUM(o.total_amt_usd) vendas_totais
    FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY a.name;

# Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? Your query should return only three values - the date, channel, and account name.

    SELECT w.occurred_at date,
          w.channel channel,
          a.name account_name
    FROM web_events w
    JOIN accounts a
    ON a.id = w.account_id
    ORDER BY date DESC
    LIMIT 1;

# Find the total number of times each type of channel from the web_events was used. Your final table should have two columns - the channel and the number of times the channel was used.

    SELECT w.channel channel, 
        COUNT(*) qtd_vezes_utilizado	   
    FROM web_events w
    GROUP BY channel;

# Who was the primary contact associated with the earliest web_event?

    SELECT w.occurred_at date,
        a.primary_poc contato
    FROM web_events w
    JOIN accounts a
    ON a.id = w.account_id
    ORDER BY date
    LIMIT 1;

# What was the smallest order placed by each account in terms of total usd. Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.

    SELECT MIN(o.total_amt_usd) AS menor_ordem,
        a.name
    FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY a.name
    ORDER BY menor_ordem;

# Find the number of sales reps in each region. Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps.

    SELECT r.name, COUNT(sr.id) AS qtd_sls_reps
    FROM region r
    JOIN sales_reps sr
    ON r.id = sr.region_id
    GROUP BY r.name;

    
## GROUP BY pt II

# For each account, determine the average amount of each type of paper they purchased across their orders. Your result should have four columns - one for the account name and one for the average quantity purchased for each of the paper types for each account.

    SELECT a.name account,
        AVG(o.standard_qty) standard_avg,
        AVG(o.gloss_qty) gloss_avg,
        AVG(o.poster_qty) porter_avg
    FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY account
    ORDER BY account;

# For each account, determine the average amount spent per order on each paper type. Your result should have four columns - one for the account name and one for the average amount spent on each paper type.

    SELECT a.name account,
        AVG(o.standard_qty) standard_avg,
        AVG(o.gloss_qty) gloss_avg,
        AVG(o.poster_qty) porter_avg
    FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY account, o.id
    ORDER BY account;

# Determine the number of times a particular channel was used in the web_events table for each sales rep. Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.

    SELECT sr.name, 
        w.channel, 
        COUNT(*) number_occourrences
    FROM web_events w
    JOIN accounts a
    ON a.id = w.account_id
    JOIN sales_reps as sr
    ON sr.id = a.sales_rep_id
    GROUP BY sr.name, w.channel
    ORDER BY number_occourrences DESC;

# Determine the number of times a particular channel was used in the web_events table for each region. Your final table should have three columns - the region name, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.

    SELECT r.name, 
        w.channel, 
        COUNT(*) number_occourrences
    FROM web_events w
    JOIN accounts a
    ON a.id = w.account_id
    JOIN sales_reps sr
    ON sr.id = a.sales_rep_id
    JOIN region r
    ON r.id = sr.region_id
    GROUP BY r.name, w.channel
    ORDER BY number_occourrences DESC;


## DISTINCT

# Use DISTINCT to test if there are any accounts associated with more than one region.

    Query 1:
    
    SELECT a.name account, COUNT(*)
    FROM accounts a
    JOIN sales_reps s
    ON s.id = a.sales_rep_id
    JOIN region r
    ON r.id = s.region_id
    GROUP BY account;
    
    Query 2:
    
    SELECT DISTINCT accounts.id
    FROM accounts;

# Have any sales reps worked on more than one account?

    Query 1:
    
    SELECT s.name sr, a.name account
    FROM accounts a
    JOIN sales_reps s
    ON s.id = a.sales_rep_id;

    Query 2:
    
    SELECT DISTINCT s.name sr
    FROM sales_reps s;

## HAVING

# How many of the sales reps have more than 5 accounts that they manage?

    SELECT sales_rep_id, COUNT(id)
    FROM accounts
    GROUP BY sales_rep_id
    HAVING COUNT(id) > 5;

# How many accounts have more than 20 orders?

    SELECT account_id, COUNT(id)
    FROM orders
    GROUP BY account_id
    HAVING COUNT(id) > 20;

# Which account has the most orders?

    SELECT account_id, COUNT(id) c
    FROM orders
    GROUP BY account_id
    HAVING COUNT(id) > 20
    ORDER BY c DESC
    LIMIT 1;

# Which accounts spent more than 30,000 usd total across all orders?

    SELECT account_id, SUM(total_amt_USD) soma
    FROM orders
    GROUP BY account_id
    HAVING SUM(total_amt_USD) > 30000
    ORDER BY soma DESC;

# Which accounts spent less than 1,000 usd total across all orders?

    SELECT account_id, SUM(total_amt_USD) soma
    FROM orders
    GROUP BY account_id
    HAVING SUM(total_amt_USD) < 1000
    ORDER BY soma DESC;

# Which account has spent the most with us?

    SELECT account_id, SUM(total_amt_USD) soma
    FROM orders
    GROUP BY account_id
    ORDER BY soma DESC
    LIMIT 1;

# Which account has spent the least with us?

    SELECT account_id, SUM(total_amt_USD) soma
    FROM orders
    GROUP BY account_id
    ORDER BY soma
    LIMIT 1;

# Which accounts used facebook as a channel to contact customers more than 6 times?

    SELECT a.name, COUNT(w.channel) fb_contacts
    FROM web_events w
    JOIN accounts a
    ON a.id = w.account_id
    WHERE w.channel = 'facebook'
    GROUP BY a.name
    HAVING COUNT(w.channel) > 6
    ORDER BY fb_contacts DESC;

# Which account used facebook most as a channel?

    SELECT a.name, COUNT(w.channel) fb_contacts
    FROM web_events w
    JOIN accounts a
    ON a.id = w.account_id
    WHERE w.channel = 'facebook'
    GROUP BY a.name
    HAVING COUNT(w.channel) > 6
    ORDER BY fb_contacts DESC
    LIMIT 1;

## DATE FUNCTIONS

# Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. Do you notice any trends in the yearly sales totals?
    

    SELECT DATE_PART('year', occurred_at) ord_year,  SUM(total_amt_usd) total_spent
    FROM orders
    GROUP BY 1
    ORDER BY 2 DESC;
    
# Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset?

    SELECT mes, ano, MAX(sum) venda_max
    FROM (
        SELECT DATE_PART('month', occurred_at) mes,
        DATE_PART('year', occurred_at) ano,  
        SUM(total_amt_usd)
        FROM orders
        GROUP BY ano, mes
        ORDER BY ano, mes) AS table1
    GROUP BY mes, ano
    ORDER BY venda_max DESC
    LIMIT 1;

# Which year did Parch & Posey have the greatest sales in terms of total number of orders? Are all years evenly represented by the dataset?

 	SELECT DATE_PART('year', occurred_at) ano,  
  		COUNT(*)
	FROM orders
	GROUP BY ano
	ORDER BY count DESC
    LIMIT 1;
   
    
# Which month did Parch & Posey have the greatest sales in terms of total number of orders? Are all months evenly represented by the dataset?

	SELECT DATE_PART('month', occurred_at) mes,
  		DATE_PART('year', occurred_at) ano,  
  		COUNT(*)
	FROM orders
	GROUP BY ano, mes
	ORDER BY count DESC
    LIMIT 1;

# In which month of which year did Walmart spend the most on gloss paper in terms of dollars?

    SELECT DATE_PART('month', o.occurred_at) mes,
        DATE_PART('year', o.occurred_at) ano,  
        SUM(o.gloss_amt_usd) gloss
    FROM orders o
    JOIN accounts a
    ON a.id = o.account_id
    WHERE name = 'Walmart'
    GROUP BY ano, mes
    ORDER BY gloss DESC;


## CASE

# Write a query to display for each order, the account ID, total amount of the order, and the level of the order - ‘Large’ or ’Small’ - depending on if the order is 3000 or more, or smaller than 3000.

    SELECT account_id,
        total_amt_usd,
        CASE WHEN total_amt_usd >=3000 THEN 'Large'
                ELSE 'Small'
                END
    FROM orders;

# Write a query to display the number of orders in each of three categories, based on the total number of items in each order. The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.

    SELECT (CASE WHEN total >= 2000 THEN 'At Least 2000'
                WHEN total >= 1000 THEN 'Between 1000 and 2000'
                ELSE 'Less than 1000'
                END) AS criterio,
                COUNT(1) qtd
    FROM orders
    GROUP BY 1;

# We would like to understand 3 different levels of customers based on the amount associated with their purchases. The top level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. The second level is between 200,000 and 100,000 usd. The lowest level is anyone under 100,000 usd. Provide a table that includes the level associated with each account. You should provide the account name, the total sales of all orders for the customer, and the level. Order with the top spending customers listed first.

    SELECT a.name account_name,
        SUM(o.total_amt_usd) lifetime_value,
        CASE WHEN SUM(o.total_amt_usd) >= 200000 THEN 'top level'
                WHEN SUM(o.total_amt_usd) >= 100000 THEN 'second level'
                ELSE 'lowest level' END 
        AS level
    FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY 1
    ORDER BY 2 DESC;

# We would now like to perform a similar calculation to the first, but we want to obtain the total amount spent by customers only in 2016 and 2017. Keep the same levels as in the previous question. Order with the top spending customers listed first.

    SELECT a.name account_name,
        SUM(o.total_amt_usd) lifetime_value,
        CASE WHEN SUM(o.total_amt_usd) >= 200000 THEN 'top level'
                WHEN SUM(o.total_amt_usd) >= 100000 THEN 'second level'
                ELSE 'lowest level' END 
        AS level
    FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
    WHERE DATE_PART('year', o.occurred_at) BETWEEN 2016 AND 2017
    GROUP BY 1
    ORDER BY 2 DESC;

# We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders. Create a table with the sales rep name, the total number of orders, and a column with top or not depending on if they have more than 200 orders. Place the top sales people first in your final table.

    SELECT s.name, 
        COUNT(*),
        (CASE WHEN COUNT(*) > 200 THEN 'top'
                ELSE 'not' END) AS classif
    FROM sales_reps s
    JOIN accounts a
    ON s.id = a.sales_rep_id
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY 1
    ORDER BY 2 DESC;

# The previous did not account for the middle, nor the dollar amount associated with the sales. Management decides they want to see these characteristics represented as well. We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders or more than 750000 in total sales. The middle group has any rep with more than 150 orders or 500000 in sales. Create a table with the sales rep name, the total number of orders, total sales across all orders, and a column with top, middle, or low depending on this criteria. Place the top sales people based on dollar amount of sales first in your final table. You might see a few upset sales people by this criteria!

    SELECT s.name sales_rep_name, 
        COUNT(*) qty_orders,
        SUM(o.total_amt_usd) total_sales,
        (CASE WHEN COUNT(*) > 200 AND SUM(o.total_amt_usd)>75000 THEN 'top'
              WHEN COUNT(*) > 150 OR SUM(o.total_amt_usd)>50000 THEN 'middle'
              ELSE 'low' END) AS classif
    FROM sales_reps s
    JOIN accounts a
    ON s.id = a.sales_rep_id
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY 1
    ORDER BY 3 DESC;
