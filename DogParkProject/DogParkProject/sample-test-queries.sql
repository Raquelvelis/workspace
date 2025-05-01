
-- ===============================================
-- Sample and Test Queries 
-- ===============================================

-- 1. OWNER QUERIES
-- ===============================================

-- Find all active owners with their contact information
SELECT OwnerID, FirstName, LastName, Email, PhoneNumber
FROM Owner
WHERE IsActive = 1
ORDER BY LastName, FirstName;

-- Find owners who have registered in the last 30 days
SELECT OwnerID, FirstName, LastName, Email, RegistrationDate
FROM Owner
WHERE RegistrationDate >= DATEADD(day, -30, GETDATE())
ORDER BY RegistrationDate DESC;

-- Count owners by city
SELECT City, COUNT(*) AS OwnerCount
FROM Owner
WHERE IsActive = 1 AND City IS NOT NULL
GROUP BY City
ORDER BY OwnerCount DESC;

-- Find owners with multiple dogs
SELECT o.OwnerID, o.FirstName, o.LastName, COUNT(d.DogID) AS DogCount
FROM Owner o
         JOIN Dog d ON o.OwnerID = d.OwnerID
WHERE o.IsActive = 1 AND d.IsActive = 1
GROUP BY o.OwnerID, o.FirstName, o.LastName
HAVING COUNT(d.DogID) > 1
ORDER BY DogCount DESC;

-- ===============================================
-- 2. DOG QUERIES
-- ===============================================

-- Find all active dogs with their owner information
SELECT d.DogID, d.Name, d.Breed, d.Size, o.FirstName + ' ' + o.LastName AS OwnerName
FROM Dog d
         JOIN Owner o ON d.OwnerID = o.OwnerID
WHERE d.IsActive = 1
ORDER BY d.Name;

-- Find dogs with expired vaccinations
SELECT d.DogID, d.Name, d.Breed, o.FirstName + ' ' + o.LastName AS OwnerName,
       v.VaccinationType, v.ExpirationDate
FROM Dog d
         JOIN Owner o ON d.OwnerID = o.OwnerID
         JOIN VaccinationRecord v ON d.DogID = v.DogID
WHERE d.IsActive = 1 AND v.ExpirationDate < GETDATE()
ORDER BY v.ExpirationDate;

-- Locate dogs based on breed and size
SELECT Breed, Size, COUNT(*) AS DogCount
FROM Dog
WHERE IsActive = 1
GROUP BY Breed, Size
ORDER BY DogCount DESC;

-- Find dogs with special notes
SELECT d.DogID, d.Name, d.Breed, o.FirstName + ' ' + o.LastName AS OwnerName, d.SpecialNotes
FROM Dog d
         JOIN Owner o ON d.OwnerID = o.OwnerID
WHERE d.IsActive = 1 AND d.SpecialNotes IS NOT NULL AND LEN(d.SpecialNotes) > 0;

-- ===============================================
-- 3. MEMBERSHIP QUERIES
-- ===============================================

-- Find all active memberships
SELECT m.MembershipID, o.FirstName + ' ' + o.LastName AS OwnerName,
       m.MembershipType, m.StartDate, m.EndDate, m.Price
FROM Membership m
         JOIN Owner o ON m.OwnerID = o.OwnerID
WHERE m.IsActive = 1
ORDER BY m.EndDate;

-- Find memberships expiring in the next 14 days
SELECT m.MembershipID, o.FirstName + ' ' + o.LastName AS OwnerName, o.Email,
       m.MembershipType, m.EndDate, m.AutoRenew
FROM Membership m
         JOIN Owner o ON m.OwnerID = o.OwnerID
WHERE m.IsActive = 1 AND m.EndDate BETWEEN GETDATE() AND DATEADD(day, 14, GETDATE())
ORDER BY m.EndDate;

-- Calculate revenue by membership type
SELECT MembershipType, COUNT(*) AS MembershipCount, SUM(Price) AS TotalRevenue
FROM Membership
WHERE IsActive = 1
GROUP BY MembershipType
ORDER BY TotalRevenue DESC;

-- Calculate renewal rate for memberships
SELECT MembershipType,
       COUNT(*) AS TotalMemberships,
       SUM(CASE WHEN AutoRenew = 1 THEN 1 ELSE 0 END) AS AutoRenewCount,
       CAST(SUM(CASE WHEN AutoRenew = 1 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100 AS AutoRenewPercentage
FROM Membership
WHERE IsActive = 1
GROUP BY MembershipType;

-- ===============================================
-- 4. PAYMENT QUERIES
-- ===============================================

-- Find all payments by date range
SELECT p.PaymentID, o.FirstName + ' ' + o.LastName AS OwnerName,
       p.PaymentDate, p.Amount, p.PaymentMethod, p.IsSuccessful
FROM Payment p
         JOIN Owner o ON p.OwnerID = o.OwnerID
WHERE p.PaymentDate BETWEEN '2023-04-01' AND '2023-04-30'
ORDER BY p.PaymentDate DESC;

-- Find failed payments
SELECT p.PaymentID, o.FirstName + ' ' + o.LastName AS OwnerName, o.Email,
       p.PaymentDate, p.Amount, p.PaymentMethod, p.TransactionReference
FROM Payment p
         JOIN Owner o ON p.OwnerID = o.OwnerID
WHERE p.IsSuccessful = 0
ORDER BY p.PaymentDate DESC;

-- Calculate revenue by payment method
SELECT PaymentMethod, COUNT(*) AS PaymentCount, SUM(Amount) AS TotalRevenue
FROM Payment
WHERE IsSuccessful = 1
GROUP BY PaymentMethod
ORDER BY TotalRevenue DESC;

-- Calculate revenue by month
SELECT
    YEAR(PaymentDate) AS Year,
    MONTH(PaymentDate) AS Month,
    COUNT(*) AS PaymentCount,
    SUM(Amount) AS TotalRevenue
FROM Payment
WHERE IsSuccessful = 1
GROUP BY YEAR(PaymentDate), MONTH(PaymentDate)
ORDER BY Year DESC, Month DESC;