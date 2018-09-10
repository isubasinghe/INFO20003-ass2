/* How many stations are on each line? For each line print
the name of the line and the number of stations on it
 */
SELECT lineID, COUNT(1) as stationCount FROM station GROUP BY lineID;

/*
For each customer print their username and how many journeys they have made
 */
SELECT username, COUNT(1) as journeyCount FROM journey INNER JOIN customer
  ON customer.customerID = journey.customerID GROUP BY username;

/* Plein is the Dutch word for town square. Print all the station names
and the line names they belong to, for stations that contain the word "plein".
Order results alphabetically by name.
 */
SELECT stationName, lineName FROM station INNER JOIN line
  ON station.lineID = line.lineID
  WHERE stationName LIKE '%plein'
  ORDER BY stationName ASC;

/* Which customer has spent the most time travelling on the Metro?
Print their username and total travel time in hours, minutes and seconds.
 */
 SELECT username, SEC_TO_TIME((endTime-startTime)) AS spentTime FROM journey
 INNER JOIN customer ON customer.customerID = journey.customerID
 ORDER BY spentTime DESC
 LIMIT 1;

 /* Print the usernames of customers who travel on concession (i.e. faretype=0)
    and took a journey in January 2018.
  */
SELECT DISTINCT username FROM journey
  INNER JOIN customer ON journey.customerID = customer.customerID
  WHERE YEAR(startTime) = 2018
  AND faretype = 0;

/* Print all the train stations on the Northern Line (including Centraal)
 in order from Centraal to Rodenrijs.
 */
SELECT stationName FROM station
  INNER JOIN line
  ON station.lineID = line.lineID
  WHERE lineName = 'Northern'
  OR lineName = 'Centraal'
  ORDER BY stationName ASC;

/*
Print the journeyID, start station name, start line name, end station name
and end line name for all journeys that took longer than 12 minutes
 */
SELECT journeyID, startStationName, startLineName, endStationName, endLineName FROM (

  (SELECT journeyID, startTime, stationName AS startStationName, lineName as startLineName
    FROM journey
    INNER JOIN station s
      ON journey.startStationID = s.stationID
    INNER JOIN line l
      ON l.lineID = s.lineID)
    AS R_1

  NATURAL JOIN

  (SELECT journeyID, endTime, stationName as endStationName, lineName as endLineName
    FROM journey
    INNER JOIN station s
      ON journey.endStationID = s.stationID
    INNER JOIN line l
      ON s.lineID = l.lineID)
    AS R_2

) WHERE TIMESTAMPDIFF(SECOND, startTime, endTime) > 12*60;

/*
To travel in 1 zone costs €3, 2 zones €5, 3 zones €8.
For customers who do not travel on concession, calculate the total amount paid
by each customer for their travel. Print their username and total costs in Euros.
 */
/* TODO */

/*
Print the usernames of customers who have travelled on all lines
 */
SELECT * FROM (
  SELECT username, COUNT(1) as lineCount FROM (
    SELECT username, l.lineID FROM customer
    INNER JOIN journey j on customer.customerID = j.customerID
    INNER JOIN station s on j.endStationID = s.stationID
    INNER JOIN line l on s.lineID = l.lineID

    UNION

    SELECT username, l.lineID  FROM customer
    INNER JOIN journey j on customer.customerID = j.customerID
    INNER JOIN station s on j.startStationID = s.stationID
    INNER JOIN line l on s.lineID = l.lineID
  ) AS T_1
  GROUP BY username
) AS T_2 WHERE lineCount = (SELECT COUNT(*) FROM line);

/*
For each journey, show its journey ID and how many stations it passed
through (count the end station but not the start station). Order results by the
number of stations the journey passed through, from most to least.
 */
/* TODO */



