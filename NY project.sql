CREATE DATABASE ny_pro



-----TOTAL TRIPS:

SELECT COUNT(DISTINCT tripid) FROM trip_details;   -----2161




------TOTAL DRIVERS:

 SELECT COUNT(DISTINCT driverid) Total_drivers FROM trips;  ----30
 
 
 
 
 -----TOTAL EARNINGS:
 
 SELECT SUM(fare) fare FROM trips;  -----751343
 
 
 
 

-------TOTAL COMPLETED TRIPS:

SELECT COUNT(DISTINCT tripid) trips FROM trips;  ------983





-------TOTAL SEARCHES:

SELECT SUM(searches) searches FROM trip_details;  -----2161





--------TOTAL SEARCHES WHICH GOT ESTIMATE:


SELECT SUM(searches_got_estimate) searches FROM trip_details;  -----1758




-----TOTAL SEARCHES WHICH GOT DRIVERS:


SELECT SUM(searches_got_quotes) searches FROM trip_details;  ------1277




------TOTAL DRIVERS CANCELLED:


SELECT COUNT(*) - SUM(driver_not_cancelled) searches FROM trip_details;  ------1021




-------TOTAL OTP ENTERED:


SELECT SUM(otp_entered) searches FROM trip_details;   ------983




-------TOTAL END RIDE:

SELECT SUM(end_ride) searches FROM trip_details;    ---------983




----------AVERAGE DISTANCE PER TRIP:

SELECT AVG(DISTANCE) FROM trips;     -------14.39




---------AVERAGE FARE PER TRIP:

SELECT AVG(fare) FROM trips;    --------764.34




--------DISTANCE TRAVELLED:

SELECT SUM(DISTANCE) FROM trips;   ------14148



--------WHICH IS THE MOST USED PAYMENT METHOD:

SELECT a.method FROM payment a JOIN
(SELECT  faremethod, COUNT(DISTINCT tripid) cnt FROM trips
GROUP BY faremethod
ORDER BY COUNT(DISTINCT tripid)  DESC) b
ON a.id = b.faremethod                                ------------------------CASH



---------THE HIGHEST PAYMENT WAS MADE THROUGH WHICH INSTRUMENT:

SELECT a.method FROM payment a JOIN
(SELECT * FROM trips 
ORDER BY fare DESC) b
ON a.id=b.faremethod
LIMIT 1                                            ------------------------------UPI




--------WHICH TWO LOCATIONS HAD THE MOST TRIPS:


 
SELECT loc_from, loc_to, COUNT(DISTINCT tripid)
FROM trips
GROUP BY loc_from, loc_to
ORDER BY COUNT(DISTINCT tripid) DESC;     ----------- Doddaballapur - Shanti Nagar  &     Gandhi Nagar - Yelahanka




--------TOP 5 EARNING DRIVERS:

SELECT driverid, SUM(fare) FROM trips
GROUP BY driverid
ORDER BY SUM(fare) DESC
LIMIT 5;                                  --------- driver id  12>8>21>24>30



-------WHICH DURATION HAD MORE TRIPS:

SELECT duration, COUNT(tripid) FROM trips   
GROUP BY duration 
ORDER BY COUNT(tripid) DESC
LIMIT 1;                                    ------------ 1



--------WHICH DRIVER, CUSTOMER PAIR HAD MORE ORDERS:

SELECT driverid, custid, COUNT(tripid) FROM trips   
GROUP BY   driverid, custid
ORDER BY COUNT(tripid) DESC
LIMIT 2;                                    ------- 17 & 96      28 & 15




--------SEARCH TO ESTIMATE RATE:


SELECT SUM(searches_got_estimate)*100/SUM(searches) FROM trip_details      ----------81.35%



--------ESTIMATE TO SEARCH FOR QUOTES RATE:

SELECT SUM(searches_for_quotes)*100/SUM(searches_got_estimate) FROM trip_details       -------82.76%




--------QUOTES ACCEPTANCE RATE:

SELECT SUM(searches_got_quotes)*100/SUM(searches_for_quotes) FROM trip_details           ------87.76%




--------QUOTE TO BOOKING RATE:

SELECT SUM(customer_not_cancelled)*100/SUM(searches_got_quotes) FROM trip_details          -------87.70%





--------BOOKING CANCELLATION RATE:


SELECT SUM(otp_entered)*100/SUM(searches_got_quotes) FROM trip_details                 ---------76.97%





------CONVERSION RATE:


SELECT SUM(otp_entered)*100/SUM(searches) FROM trip_details                     ----------45.48%




-------WHICH AREA GOT HIGHEST FARES,CANCELLATIONS BY BOTH.


SELECT * FROM (SELECT *,RANK() OVER(ORDER BY fare DESC) rnk
FROM
(SELECT loc_from, SUM(fare) fare FROM trips
GROUP BY loc_from)b)c
WHERE rnk=1                                          -------LOCATION 6



SELECT * FROM (SELECT *,RANK() OVER(ORDER BY can DESC) rnk
FROM
(SELECT loc_from, COUNT(*) - SUM(driver_not_cancelled) can
FROM trip_details
GROUP BY loc_from)b)c
WHERE rnk=1                                        ----------LOCATION 1 (by drivers)


SELECT * FROM (SELECT *,RANK() OVER(ORDER BY can DESC) rnk
FROM
(SELECT loc_from, COUNT(*) - SUM(customer_not_cancelled) can
FROM trip_details
GROUP BY loc_from)b)c
WHERE rnk=1                                       -----------LOCATION 4 (by customer)



------------WHICH DURATION GOT HIGHEST TRIPS AND FARES:


SELECT * FROM (SELECT *,RANK() OVER(ORDER BY fare DESC) rnk
FROM
(SELECT duration, SUM(fare) fare, COUNT(DISTINCT tripid) trips FROM trips
GROUP BY duration)b)c
WHERE rnk=1;                                  -------------DURATION 1 (0 - 1)
