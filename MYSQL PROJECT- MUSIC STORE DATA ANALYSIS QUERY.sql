#Question Set 1 - Easy 
# 1. Who is the senior most employee based on job title?
SELECT * 
FROM employee
ORDER BY title DESC
LIMIT 1;

# 2. Which countries have the most Invoices?
SELECT billing_country, COUNT(*) AS invoice_count
FROM invoice
GROUP BY billing_country
ORDER BY invoice_count DESC;

# 3. What are top 3 values of total invoice? 
SELECT total
FROM invoice
ORDER BY total DESC
LIMIT 3;

# 4. Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city that 
has the highest sum of invoice totals. Return both the city name & sum of all invoice 
totals 
SELECT billing_city, SUM(total) AS total_sales
FROM invoice
GROUP BY billing_city
ORDER BY total_sales DESC
LIMIT 1;

# 5. Who is the best customer? The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money 
SELECT customer_id, SUM(total) AS total_spent
FROM invoice
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 1;

# Question Set 2 – Moderate 
# 1. Write query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A 
SELECT DISTINCT c.email, c.first_name, c.last_name, g.name AS genre
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
ORDER BY c.email ASC;

# 2. Let's invite the artists who have written the most rock music in our dataset. Write a query that returns the Artist name and total track count of the top 10 rock bands
SELECT a.name AS artist_name, COUNT(*) AS track_count
FROM track t
JOIN genre g ON t.genre_id = g.genre_id
JOIN album2 al ON t.album_id = al.album_id
JOIN artist a ON al.artist_id = a.artist_id
WHERE g.name = 'Rock'
GROUP BY a.artist_id, a.name
ORDER BY track_count DESC
LIMIT 10;

# 3. Return all the track names that have a song length longer than the average song length. Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first 
SELECT name, milliseconds
FROM track
WHERE milliseconds > (
    SELECT AVG(milliseconds) FROM track
)
ORDER BY milliseconds DESC;

# Question Set 3 – Advance 
# 1. Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent 
SELECT 
    c.first_name,
    c.last_name,
    a.name AS artist_name,
    SUM(il.unit_price * il.quantity) AS total_spent
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN album2 al ON t.album_id = al.album_id  -- assuming your table is named album2
JOIN artist a ON al.artist_id = a.artist_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name,
    a.artist_id, a.name
ORDER BY total_spent DESC;

# 2. We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres 
SELECT country, genre_name, max_genre_purchase
FROM (
    SELECT c.country, g.name AS genre_name, COUNT(*) AS genre_count,
           RANK() OVER (PARTITION BY c.country ORDER BY COUNT(*) DESC) AS rank_genre,
           COUNT(*) AS max_genre_purchase
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    JOIN invoice_line il ON i.invoice_id = il.invoice_id
    JOIN track t ON il.track_id = t.track_id
    JOIN genre g ON t.genre_id = g.genre_id
    GROUP BY c.country, g.name
) ranked
WHERE rank_genre = 1;

# 3. Write a query that determines the customer that has spent the most on music for eachcountry. Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount 
SELECT 
    country, 
    first_name, 
    last_name, 
    total_spent
FROM (
    SELECT 
        c.country,
        c.first_name,
        c.last_name,
        SUM(i.total) AS total_spent,
        RANK() OVER (PARTITION BY c.country ORDER BY SUM(i.total) DESC) AS rank_by_spent
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    GROUP BY c.customer_id, c.country, c.first_name, c.last_name
) AS ranked_customers
WHERE rank_by_spent = 1;










 