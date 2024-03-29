#Anotações Módulo 6 - SQL Window Functions

## OVER, PARTITION BY e WINDOW

#This time, create a running total of standard_amt_usd (in the orders table) over order time with no date truncation. Your final table should have two columns: one with the amount being added for each new row, and a second with the running total.

    SELECT standard_amt_usd,
        SUM(standard_amt_usd) OVER (ORDER BY occurred_at)
    FROM orders;

#Now, modify your query from the previous quiz to include partitions. Still create a running total of standard_amt_usd (in the orders table) over order time, but this time, date truncate occurred_at by year and partition by that same year-truncated occurred_at variable. Your final table should have three columns: One with the amount being added for each row, one for the truncated date, and a final column with the running total within each year.

    SELECT standard_amt_usd,
        DATE_TRUNC('year', occurred_at),
        SUM(standard_amt_usd) OVER (PARTITION BY DATE_TRUNC('year', occurred_at) ORDER BY occurred_at)
    FROM orders;

    
## ROW_NUMBER e RANK

#Select the id, account_id, and total variable from the orders table, then create a column called total_rank that ranks this total amount of paper ordered (from highest to lowest) for each account using a partition. Your final table should have these four columns.

    SELECT id, account_id, total,
        RANK() OVER (PARTITION BY account_id ORDER BY total DESC) AS total_rank
    FROM orders;

#Remove ORDER BY DATE_TRUNC('month',occurred_at) in each line of the query that contains it in the SQL Explorer below. Evaluate your new query, compare it to the results in the SQL Explorer above, and answer the subsequent quiz questions.

    SELECT id,
        account_id,
        standard_qty,
        DATE_TRUNC('month', occurred_at) AS month,
        DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS dense_rank,
        SUM(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS sum_std_qty,
        COUNT(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS count_std_qty,
        AVG(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS avg_std_qty,
        MIN(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS min_std_qty,
        MAX(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS max_std_qty
    FROM orders;                                                        
  
  
## WINDOW function
             
#Now, create and use an alias to shorten the following query (which is different than the one in Derek previous video) that has multiple window functions. Name the alias account_year_window, which is more descriptive than main_window in the example above.
             
    SELECT id,
        account_id,
        standard_qty,
        DATE_TRUNC('month', occurred_at) AS month,
        DENSE_RANK() OVER account_year_windows AS dense_rank,
        SUM(standard_qty) OVER account_year_windows AS sum_std_qty,
        COUNT(standard_qty) OVER account_year_windows AS count_std_qty,
        AVG(standard_qty) OVER account_year_windows AS avg_std_qty,
        MIN(standard_qty) OVER account_year_windows AS min_std_qty,
        MAX(standard_qty) OVER account_year_windows AS max_std_qty
    FROM orders
    WINDOW account_year_windows AS (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at));
                          

## LED e LAG

#Imagine you are an analyst at Parch & Posey and you want to determine how the current order''s total revenue ("total" meaning from sales of all types of paper) compares to the next order''s total revenue.

    SELECT month,
        total_usd,
        LEAD(total_usd) OVER w AS lead,
        LEAD(total_usd) OVER w - total_usd AS lead_difference
    FROM (
    SELECT DATE_TRUNC('month', occurred_at) AS month,
        SUM(total_amt_usd) AS total_usd
    FROM orders 
    GROUP BY 1
    ) sub
    WINDOW w AS (ORDER BY month);
 

## NTILE

#You can use partitions with percentiles to determine the percentile of a specific subset of all rows. Imagine you are an analyst at Parch & Posey and you want to determine the largest orders (in terms of quantity) a specific customer has made to encourage them to order more similarly sized large orders. You only want to consider the NTILE for that customer''s account_id.

#In the SQL Explorer below, write three queries (separately) that reflect each of the following:

#Use the NTILE functionality to divide the accounts into 4 levels in terms of the amount of standard_qty for their orders. Your resulting table should have the account_id, the occurred_at time for each order, the total amount of standard_qty paper purchased, and one of four levels in a standard_quartile column.

    SELECT account_id,
        occurred_at,
        standard_qty,
        NTILE(4) OVER (PARTITION BY account_id ORDER BY standard_qty DESC) quartil
    FROM orders;

#Use the NTILE functionality to divide the accounts into two levels in terms of the amount of gloss_qty for their orders. Your resulting table should have the account_id, the occurred_at time for each order, the total amount of gloss_qty paper purchased, and one of two levels in a gloss_half column.

    SELECT account_id,
        occurred_at,
        gloss_qty,
        NTILE(2) OVER (PARTITION BY account_id ORDER BY gloss_qty DESC) gloss_half
    FROM orders;

#Use the NTILE functionality to divide the orders for each account into 100 levels in terms of the amount of total_amt_usd for their orders. Your resulting table should have the account_id, the occurred_at time for each order, the total amount of total_amt_usd paper purchased, and one of 100 levels in a total_percentile column.

    SELECT account_id,
        occurred_at,
        total_amt_usd,
        NTILE(100) OVER (PARTITION BY account_id ORDER BY total_amt_usd DESC) total_percentile
    FROM orders;

