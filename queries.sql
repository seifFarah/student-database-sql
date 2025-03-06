/* Question One 
Name: Seifeldin Farah
AUID: 959650988
NetID: sfar671
*/

-- question two
SELECT EmployeeId as "Employee Id", LastName as "Last Name", FirstName as "First Name", Title, "ReportsTo" as "Reports To", BirthDate as "Birth Date", HireDate as "Hire Date", Address, City, State, Country, PostalCode as "Postal Code", Phone, Fax, Email
from Employee
ORDER by "First Name" asc;

-- question three
update Employee
set Address = "42 Johnson Drive NW, Bentley, AB, Canada", PostalCode = "T5Y 5N2"
where (LastName like "Callahan") AND (FirstName like "Laura");

-- question four
CREATE TABLE EmploymentHistory (
  EmployeeID INTEGER NOT NULL,
  EntryDate date NOT NULL,
  EmploymentDuration NUMERIC,
  PayRate INTEGER,
  PRIMARY KEY (EmployeeID, EntryDate),
  FOREIGN KEY (EmployeeID) REFERENCES Employee (EmployeeID)
);
	
-- question five
insert into EmploymentHistory(EmployeeId, EntryDate, EmploymentDuration)
SELECT EmployeeId, CURRENT_TIMESTAMP, strftime('%Y', 'now') - strftime('%Y', HireDate)
from Employee

-- question six
select CAST(substr(InvoiceDate, 1,4) AS INT) as "Year", "$" || sum(Total) as "Sales Value"
from Invoice
GROUP by "Year" 
ORDER BY "YEAR" ASC;

-- question seven
SELECT EmployeeId as "Employee ID", Case when CURRENT_DATE - HireDate >= 14 then "$75000" when(CURRENT_DATE - HireDate > 10 and CURRENT_DATE - HireDate < 14) then "$55000" else "$30000" end as "Payrate"
from Employee;

-- question eight
SELECT c.FirstName || " " || c.LastName AS "Full Names", c.Country as "Countries"
FROM Customer c
inner join Employee e on c.SupportRepId = e.EmployeeId
WHERE e.HireDate - e.BirthDate < 35;

-- question nine 
SELECT c.country, COUNT(*) AS "Count of audio", SUM(t.UnitPrice) AS "Sum unit price"
FROM invoiceLine il
inner JOIN Track t ON t.TrackId = il.TrackId
inner JOIN MediaType m ON m.MediaTypeId = t.MediaTypeId
inner join invoice i on il.InvoiceId = i.InvoiceId
inner join Customer c on c.CustomerId = i.CustomerId
WHERE (NOT (m.MediaTypeId = 3)) and (c.Country like "%Germany%");

-- question ten
SELECT C.LastName || " " || C.FirstName AS "Customer", "$" || sum(I.Total) as "Sales Value", "%" || ((SUM(I.Total)/ (SELECT SUM(Total) FROM Invoice))* 100) as "% of Sales"
from Customer C 
left join Invoice I on C.CustomerId = I.CustomerId
WHERE C.Company is null
Group by "Customer"
order by "Sales Value" desc
limit 5;



-- question eleven
select a.name AS "Artist Names", b.Title as "Album Titles", Count(t.name) AS "No. of Tracks"
from Artist a
inner join Album b on a.ArtistId = b.ArtistId
left JOIN track t on t.AlbumId = b.AlbumId
group by b.Title
HAVING Count(b.AlbumID) BETWEEN 5 AND 10;
 
-- question twelve 
SELECT t.TrackId as "Track ID", t.name AS "Track Name", g.name as "Genre Name"
FROM Track t
left JOIN genre g ON g.GenreId = t.GenreId
WHERE t.MediaTypeId = 3
  AND t.Milliseconds > (SELECT AVG(Milliseconds) 
  FROM track
  where track.MediaTypeId = 3 );


-- question thirteen
SELECT p.name as "Playlist Name", count(ar.name) as "No. of Tracks"
from PlaylistTrack pt
inner join Playlist p on pt.PlaylistId = p.PlaylistId
inner join track t on t.TrackId = pt.TrackId
inner join album a on t.AlbumId = a.AlbumId
inner join artist ar on a.ArtistId = ar.ArtistId
where ar.name like "AC/DC"
GROUP by p.name
order by "No. of tracks" ASC
LIMIT 1;

-- question fourteen
SELECT m.firstName || ' ' || m.lastName AS "Manager",
       reportsTo.firstName || ' ' || reportsTo.lastName AS "Reports to"
FROM employee m
INNER JOIN (
    SELECT ReportsTo, COUNT(*) AS countmanaging
    FROM employee
    GROUP BY ReportsTo
) AS subquery ON m.employeeID = subquery.ReportsTo
INNER JOIN employee reportsTo ON m.ReportsTo = reportsTo.employeeID
GROUP BY m.firstName, m.lastName
HAVING MAX(countmanaging) = (
    SELECT MAX(countmanaging)
    FROM (
        SELECT COUNT(*) AS countmanaging
        FROM employee
        GROUP BY ReportsTo
    ) AS subquery
);


-- question fifteen
select DISTINCT pt.PlaylistId as "Playlist Id" as "Playlist Id", p.name as "Name"
from PlaylistTrack pt
LEFT join Playlist p on p.PlaylistId = pt.PlaylistId
LEFT join Track t on t.TrackId = pt.TrackId
where(t.composer like "%Cidade Negra%") AND (t.composer like "%Ed Motta%");

-- question sixteen
select p.name, sum(t.Bytes) as "Total Space", "$" || sum(t.UnitPrice) as "Total Price"
from PlaylistTrack pt
left join Playlist p on pt.PlaylistId = p.PlaylistId
left join track t on t.TrackId = pt.TrackId
where p.name like "Grunge";
