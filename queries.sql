/*
Hello! Hope this code works for you. Made by Seifeldin Farah.
*/

/* Retrieve employee details ordered by first name */
SELECT EmployeeId as "Employee Id", LastName as "Last Name", FirstName as "First Name", Title, "ReportsTo" as "Reports To", BirthDate as "Birth Date", HireDate as "Hire Date", Address, City, State, Country, PostalCode as "Postal Code", Phone, Fax, Email
FROM Employee
ORDER BY "First Name" ASC;

/* Update address and postal code for a specific employee */
UPDATE Employee
SET Address = "42 Johnson Drive NW, Bentley, AB, Canada", PostalCode = "T5Y 5N2"
WHERE LastName = "Callahan" AND FirstName = "Laura";

/* Create a table to track employment history */
CREATE TABLE EmploymentHistory (
  EmployeeID INTEGER NOT NULL,
  EntryDate DATE NOT NULL,
  EmploymentDuration NUMERIC,
  PayRate INTEGER,
  PRIMARY KEY (EmployeeID, EntryDate),
  FOREIGN KEY (EmployeeID) REFERENCES Employee (EmployeeID)
);

/* Insert employment duration based on hire date */
INSERT INTO EmploymentHistory(EmployeeId, EntryDate, EmploymentDuration)
SELECT EmployeeId, CURRENT_TIMESTAMP, strftime('%Y', 'now') - strftime('%Y', HireDate)
FROM Employee;

/* Calculate total sales per year */
SELECT CAST(substr(InvoiceDate, 1,4) AS INT) AS "Year", "$" || SUM(Total) AS "Sales Value"
FROM Invoice
GROUP BY "Year" 
ORDER BY "Year" ASC;

/* Determine pay rates based on years of employment */
SELECT EmployeeId AS "Employee ID", 
       CASE 
           WHEN CURRENT_DATE - HireDate >= 14 THEN "$75000" 
           WHEN CURRENT_DATE - HireDate > 10 AND CURRENT_DATE - HireDate < 14 THEN "$55000" 
           ELSE "$30000" 
       END AS "Payrate"
FROM Employee;

/* Retrieve customers whose support rep was hired before the age of 35 */
SELECT c.FirstName || " " || c.LastName AS "Full Names", c.Country AS "Countries"
FROM Customer c
INNER JOIN Employee e ON c.SupportRepId = e.EmployeeId
WHERE e.HireDate - e.BirthDate < 35;

/* Count audio purchases and total unit prices for customers from Germany, excluding MediaTypeId = 3 */
SELECT c.Country, COUNT(*) AS "Count of audio", SUM(t.UnitPrice) AS "Sum unit price"
FROM InvoiceLine il
INNER JOIN Track t ON t.TrackId = il.TrackId
INNER JOIN MediaType m ON m.MediaTypeId = t.MediaTypeId
INNER JOIN Invoice i ON il.InvoiceId = i.InvoiceId
INNER JOIN Customer c ON c.CustomerId = i.CustomerId
WHERE NOT (m.MediaTypeId = 3) AND c.Country LIKE "%Germany%";

/* Find top 5 customers contributing the highest percentage of total sales */
SELECT C.LastName || " " || C.FirstName AS "Customer", 
       "$" || SUM(I.Total) AS "Sales Value", 
       "%" || ((SUM(I.Total) / (SELECT SUM(Total) FROM Invoice)) * 100) AS "% of Sales"
FROM Customer C 
LEFT JOIN Invoice I ON C.CustomerId = I.CustomerId
WHERE C.Company IS NULL
GROUP BY "Customer"
ORDER BY "Sales Value" DESC
LIMIT 5;

/* Retrieve albums with track count between 5 and 10 */
SELECT a.Name AS "Artist Names", b.Title AS "Album Titles", COUNT(t.Name) AS "No. of Tracks"
FROM Artist a
INNER JOIN Album b ON a.ArtistId = b.ArtistId
LEFT JOIN Track t ON t.AlbumId = b.AlbumId
GROUP BY b.Title
HAVING COUNT(b.AlbumID) BETWEEN 5 AND 10;

/* Find tracks from MediaTypeId = 3 that exceed the average duration for that media type */
SELECT t.TrackId AS "Track ID", t.Name AS "Track Name", g.Name AS "Genre Name"
FROM Track t
LEFT JOIN Genre g ON g.GenreId = t.GenreId
WHERE t.MediaTypeId = 3
  AND t.Milliseconds > (SELECT AVG(Milliseconds) 
                        FROM Track
                        WHERE MediaTypeId = 3);

/* Identify the playlist with the fewest AC/DC tracks */
SELECT p.Name AS "Playlist Name", COUNT(ar.Name) AS "No. of Tracks"
FROM PlaylistTrack pt
INNER JOIN Playlist p ON pt.PlaylistId = p.PlaylistId
INNER JOIN Track t ON t.TrackId = pt.TrackId
INNER JOIN Album a ON t.AlbumId = a.AlbumId
INNER JOIN Artist ar ON a.ArtistId = ar.ArtistId
WHERE ar.Name LIKE "AC/DC"
GROUP BY p.Name
ORDER BY "No. of Tracks" ASC
LIMIT 1;

/* Determine the manager overseeing the highest number of employees */
SELECT m.FirstName || ' ' || m.LastName AS "Manager",
       reportsTo.FirstName || ' ' || reportsTo.LastName AS "Reports to"
FROM Employee m
INNER JOIN (
    SELECT ReportsTo, COUNT(*) AS countmanaging
    FROM Employee
    GROUP BY ReportsTo
) AS subquery ON m.EmployeeID = subquery.ReportsTo
INNER JOIN Employee reportsTo ON m.ReportsTo = reportsTo.EmployeeID
GROUP BY m.FirstName, m.LastName
HAVING MAX(countmanaging) = (
    SELECT MAX(countmanaging)
    FROM (
        SELECT COUNT(*) AS countmanaging
        FROM Employee
        GROUP BY ReportsTo
    ) AS subquery
);

/* Find playlists containing both "Cidade Negra" and "Ed Motta" as composers */
SELECT DISTINCT pt.PlaylistId AS "Playlist Id", p.Name AS "Name"
FROM PlaylistTrack pt
LEFT JOIN Playlist p ON p.PlaylistId = pt.PlaylistId
LEFT JOIN Track t ON t.TrackId = pt.TrackId
WHERE (t.Composer LIKE "%Cidade Negra%") AND (t.Composer LIKE "%Ed Motta%");

/* Calculate total space and price for the "Grunge" playlist */
SELECT p.Name, SUM(t.Bytes) AS "Total Space", "$" || SUM(t.UnitPrice) AS "Total Price"
FROM PlaylistTrack pt
LEFT JOIN Playlist p ON pt.PlaylistId = p.PlaylistId
LEFT JOIN Track t ON t.TrackId = pt.TrackId
WHERE p.Name LIKE "Grunge";

