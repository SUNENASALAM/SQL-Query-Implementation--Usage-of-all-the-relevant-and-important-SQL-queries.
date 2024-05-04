-- **************************************************Codebase: Advanced Databases Assignment**************************************************************************************

---**********************************************TITLE: Database Design & SQL for Data Analaysis***********************************************************************************

-- Task 2:  The firststage of your task is to create a database and import the four tables from the csv file. 
-- You should also add the necessary primary and foreign key constraints to the tables and provide a database diagram in your report 
-- which shows the three tables and their relationships. 
-- You should create the database with the name FoodserviceDB and the tables with the following names:
-- a. Restaurant
-- b. Consumers
-- c. Ratings
-- d. Restaurant_Cuisines

-- Let's create the database FoodserviceDB
CREATE DATABASE FoodserviceDB;

-- We have uploaded all the tables given in the assignment section into the SQL Management Studio. Now, let's create the Database Diagram as a first step in the Task

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Part 2:
-- Question 1) Write a query that lists all restaurants with a Medium range price with open area,serving Mexican food.

SELECT *
FROM restaurants AS r
JOIN Restaurant_Cuisines AS rc ON r.Restaurant_id = rc.Restaurant_id
WHERE r.Price = 'Medium'
AND r.Area = 'Open'
AND rc.Cuisine = 'Mexican';

-- This query lists all the restauranta names, serving cuisine as Mexican, where price range is Medium and have Open area set up as well!

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Question 2) Write a query that returns the total number of restaurants who have the overall ratingas 1 and 
-- are serving Mexican food. Compare the results with the total number ofrestaurants who have the overall rating as 1 
-- serving Italian food (please give explanations on their comparison)

-- First let's query to give the results for the total number of restaurants who have the overall ratings as 1 serving Cusine as "Mexican"

SELECT COUNT(*) AS Total_Mexican_Restaurants_With_Rating_1
FROM restaurants AS r
JOIN Ratings AS ra ON r.Restaurant_id = ra.Restaurant_id
JOIN Restaurant_Cuisines AS rc ON r.Restaurant_id = rc.Restaurant_id
WHERE ra.Overall_Rating = '1'
AND rc.Cuisine = 'Mexican'; -- got results as 87 number of restaurants have overall rating 1 serving Mexian cuisine


-- NOw, let's query to get the total number of restaurants who have the overall rating as 1 serving cuisine as "Italian"
SELECT COUNT(*) AS Total_Italian_Restaurants_With_Rating_1
FROM restaurants AS r
JOIN Ratings AS ra ON r.Restaurant_id = ra.Restaurant_id
JOIN Restaurant_Cuisines AS rc ON r.Restaurant_id = rc.Restaurant_id
WHERE ra.Overall_Rating = '1'
AND rc.Cuisine = 'Italian'; -- got results as 11 number of restaurants have overall rating 1 serving Italian cuisine

-- From the results, we got to know the the Total_Mexican_Restaurants_With_Rating_1 is greater than the Total_Italian_Restaurants_With_Rating_1
-- Hence,  there are more restaurants with an overall rating of 1 serving Mexican food compared to those serving Italian food.

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Question 3) Calculate the average age of consumers who have given a 0 rating to the 'Service_rating'column. (NB: round off the value if it is a decimal)

SELECT ROUND(AVG(c.Age), 0) AS Average_Age_With_Zero_Service_Rating
FROM consumers AS c
JOIN Ratings AS r ON c.Consumer_ID = r.Consumer_ID
WHERE r.Service_Rating = '0'; -- Hence, got the result as 20.

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Question 4) Write a query that returns the restaurants ranked by the youngest consumer. 
-- You should include the restaurant name and food rating that is given by that customer to the restaurant in your result. 
-- Sort the results based on food rating from high to low.

SELECT r.Name AS RestaurantName, r.Restaurant_id, MIN(c.Age) AS YoungestCustomerAge, ra.Food_Rating
FROM restaurants AS r
JOIN Ratings AS ra ON r.Restaurant_id = ra.Restaurant_id
JOIN consumers AS c ON ra.Consumer_ID = c.Consumer_ID
GROUP BY r.Name, r.Restaurant_id, ra.Food_Rating
ORDER BY ra.Food_Rating DESC;
 -- This query will return the restaurants ranked by the youngest customer, along with the restaurant name and the food rating given by that customer, sorted by food rating from high to low.

 ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Question 5) Write a stored procedure for the query given as:
-- Update the Service_rating of all restaurants to '2' if they have parking available, 
-- either as 'yes' or 'public

CREATE PROCEDURE Update_Service_Rating_By_Parking_Details
AS
BEGIN
    UPDATE ratings
    SET Service_Rating = '2'
    FROM ratings
    INNER JOIN restaurants ON ratings.Restaurant_ID = restaurants.Restaurant_ID
    WHERE restaurants.Parking IN ('Yes', 'Public');
END; -- This query will create the stored procedure.

-- Let's execute it to show the result
EXEC Update_Service_Rating_By_Parking_Details; -- Hence, all the rows got updated likewise (571 rows affected)

-- Let's view the table ratings to see, whether the query updated the Service_Ratings for the restaurants or not accordingly

SELECT rest.Name, rt.Service_Rating
FROM ratings rt
INNER JOIN restaurants rest ON rt.Restaurant_ID = rest.Restaurant_ID
WHERE rest.Parking IN ('Yes','Public'); -- Yes, the Service_rating have been updated to 2 for all the restaurants whose Parking status is "Yes" and "Public"

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Question 6) You should also write four queries of your own and provide a brief explanation of the results which each query returns. 
-- You should make use of all of the following at least once:
-- Nested queries - EXISTS
-- Nested queries - IN
-- System functions
-- Use of GROUP BY, HAVING and ORDER BY clauses

-- Let's consider each case and do it accordingly: 

-- Query using Nested Query with EXISTS:

-- This query selects the "name", "city", and "state" of restaurants where at least one rating with an overall rating of '2' exists. 
-- The EXISTS clause is used to check for the existence of such ratings for each restaurant.

SELECT Name, City, State
FROM restaurants AS r
WHERE EXISTS (
    SELECT 1
    FROM Ratings AS ra
    WHERE r.Restaurant_id = ra.Restaurant_id
    AND ra.Overall_Rating = '2'
); -- Returns three columns, "Name", "City" and "State" showing the restaurant details where the overall rating given by the customer as 2.Hence usage of the EXISTS confirmed hereby

-- Query using Nested Query with IN:

-- This query selects the "name", "city", and "state" of restaurants where the Service_Rating in the Ratings table is '2'. The IN clause is used to check if the Restaurant_id of the restaurant exists in the subquery result.

SELECT Name, City, State
FROM restaurants
WHERE Restaurant_id IN (
    SELECT Restaurant_id
    FROM Ratings
    WHERE Service_Rating = '2'
); --  Hence got the result

-- Query using System Functions:

SELECT Name, City, State, CONCAT(Latitude, ',', Longitude) AS Location
FROM restaurants;

-- This query selects the "name", "city", and "state" of restaurants along with their concatenated latitude and longitude values as a single column.
-- CONCAT() function is used to concatenate the latitude and longitude values with a comma.

-- Query using GROUP BY, HAVING, and ORDER BY clauses:

SELECT City, COUNT(*) AS NumRestaurants
FROM restaurants
GROUP BY City
HAVING COUNT(*) > 1
ORDER BY NumRestaurants DESC;

-- This query selects the city and the count of restaurants in each city. The results are grouped by city using the GROUP BY clause. 
-- The HAVING clause filters out cities with only one restaurant.
-- Finally, the results are ordered by the number of restaurants in descending order using the ORDER BY clause.
