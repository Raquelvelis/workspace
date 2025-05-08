-- Create the database

CREATE DATABASE DOG_PARK_DB;
GO

USE DOG_PARK_DB;
GO

-- Create tables
CREATE TABLE Owner (
                       OwnerID INT PRIMARY KEY IDENTITY(1,1),
                       FirstName NVARCHAR(50) NOT NULL,
                       LastName NVARCHAR(50) NOT NULL,
                       Email NVARCHAR(100) NOT NULL UNIQUE,
                       PhoneNumber NVARCHAR(20) NOT NULL,
                       Address NVARCHAR(100),
                       City NVARCHAR(50),
                       State NVARCHAR(2),
                       ZipCode NVARCHAR(10),
                       RegistrationDate DATE NOT NULL DEFAULT GETDATE(),
                       IsActive BIT NOT NULL DEFAULT 1,
                       EmergencyContact NVARCHAR(100),
                       EmergencyPhone NVARCHAR(20),
                       CONSTRAINT UQ_Owner_Email UNIQUE (Email)
);

CREATE TABLE Membership (
                            MembershipID INT PRIMARY KEY IDENTITY(1,1),
                            OwnerID INT NOT NULL,
                            MembershipType NVARCHAR(20) NOT NULL CHECK (MembershipType IN ('Daily', 'Monthly', 'Annual')),
                            StartDate DATE NOT NULL,
                            EndDate DATE NOT NULL,
                            IsActive BIT NOT NULL DEFAULT 1,
                            Price DECIMAL(10,2) NOT NULL,
                            AutoRenew BIT NOT NULL DEFAULT 0,
                            LastRenewalNotice DATE,
                            CONSTRAINT FK_Membership_Owner FOREIGN KEY (OwnerID) REFERENCES Owner(OwnerID)
);

CREATE TABLE Payment (
                         PaymentID INT PRIMARY KEY IDENTITY(1,1),
                         OwnerID INT NOT NULL,
                         MembershipID INT NOT NULL,
                         PaymentDate DATE NOT NULL DEFAULT GETDATE(),
                         Amount DECIMAL(10,2) NOT NULL,
                         PaymentMethod NVARCHAR(20) NOT NULL,
                         TransactionReference NVARCHAR(50),
                         IsSuccessful BIT NOT NULL DEFAULT 1,
                         CONSTRAINT FK_Payment_Owner FOREIGN KEY (OwnerID) REFERENCES Owner(OwnerID),
                         CONSTRAINT FK_Payment_Membership FOREIGN KEY (MembershipID) REFERENCES Membership(MembershipID)
);

CREATE TABLE Dog (
                     DogID INT PRIMARY KEY IDENTITY(1,1),
                     OwnerID INT NOT NULL,
                     Name NVARCHAR(50) NOT NULL,
                     Breed NVARCHAR(50) NOT NULL,
                     Size NVARCHAR(10) NOT NULL CHECK (Size IN ('Small', 'Medium', 'Large')),
                     DateOfBirth DATE,
                     Gender NVARCHAR(10) CHECK (Gender IN ('Male', 'Female')),
                     Color NVARCHAR(50),
                     Temperament NVARCHAR(MAX),
                     SpecialNotes NVARCHAR(MAX),
                     Photo VARBINARY(MAX),
                     QRCodeID NVARCHAR(20) UNIQUE,
                     IsActive BIT NOT NULL DEFAULT 1,
                     CONSTRAINT FK_Dog_Owner FOREIGN KEY (OwnerID) REFERENCES Owner(OwnerID)
);

CREATE TABLE VaccinationRecord (
                                   VaccinationID INT PRIMARY KEY IDENTITY(1,1),
                                   DogID INT NOT NULL,
                                   VaccinationType NVARCHAR(50) NOT NULL,
                                   AdministrationDate DATE NOT NULL,
                                   ExpirationDate DATE NOT NULL,
                                   VetName NVARCHAR(100),
                                   VetContact NVARCHAR(100),
                                   DocumentProof VARBINARY(MAX),
                                   IsVerified BIT NOT NULL DEFAULT 0,
                                   CONSTRAINT FK_VaccinationRecord_Dog FOREIGN KEY (DogID) REFERENCES Dog(DogID)
);

CREATE TABLE ParkArea (
                          AreaID INT PRIMARY KEY IDENTITY(1,1),
                          AreaName NVARCHAR(50) NOT NULL,
                          DogSizeCategory NVARCHAR(10) NOT NULL CHECK (DogSizeCategory IN ('Small', 'Medium', 'Large', 'All')),
                          MaxCapacity INT NOT NULL,
                          Description NVARCHAR(MAX),
                          IsActive BIT NOT NULL DEFAULT 1
);

CREATE TABLE Visit (
                       VisitID INT PRIMARY KEY IDENTITY(1,1),
                       DogID INT NOT NULL,
                       MembershipID INT NOT NULL,
                       CheckInTime DATETIME NOT NULL DEFAULT GETDATE(),
                       CheckOutTime DATETIME,
                       IsReservation BIT NOT NULL DEFAULT 0,
                       ReservationTime DATETIME,
                       Notes NVARCHAR(MAX),
                       CONSTRAINT FK_Visit_Dog FOREIGN KEY (DogID) REFERENCES Dog(DogID),
                       CONSTRAINT FK_Visit_Membership FOREIGN KEY (MembershipID) REFERENCES Membership(MembershipID)
);

CREATE TABLE AreaUsage (
                           AreaUsageID INT PRIMARY KEY IDENTITY(1,1),
                           VisitID INT NOT NULL,
                           AreaID INT NOT NULL,
                           EntryTime DATETIME NOT NULL,
                           ExitTime DATETIME,
                           CONSTRAINT FK_AreaUsage_Visit FOREIGN KEY (VisitID) REFERENCES Visit(VisitID),
                           CONSTRAINT FK_AreaUsage_ParkArea FOREIGN KEY (AreaID) REFERENCES ParkArea(AreaID)
);

CREATE TABLE BehaviorIncident (
                                  IncidentID INT PRIMARY KEY IDENTITY(1,1),
                                  DogID INT NOT NULL,
                                  VisitID INT,
                                  IncidentTime DATETIME NOT NULL,
                                  Description NVARCHAR(MAX) NOT NULL,
                                  SeverityLevel NVARCHAR(10) NOT NULL CHECK (SeverityLevel IN ('Low', 'Medium', 'High')),
                                  StaffAction NVARCHAR(MAX),
                                  FollowUpNotes NVARCHAR(MAX),
                                  CONSTRAINT FK_BehaviorIncident_Dog FOREIGN KEY (DogID) REFERENCES Dog(DogID),
                                  CONSTRAINT FK_BehaviorIncident_Visit FOREIGN KEY (VisitID) REFERENCES Visit(VisitID)
);

CREATE TABLE InteractionType (
                                 InteractionTypeID INT PRIMARY KEY IDENTITY(1,1),
                                 TypeName NVARCHAR(50) NOT NULL,
                                 Description NVARCHAR(MAX),
                                 IsPositive BIT NOT NULL DEFAULT 1
);

CREATE TABLE DogInteraction (
                                InteractionID INT PRIMARY KEY IDENTITY(1,1),
                                DogID1 INT NOT NULL,
                                DogID2 INT NOT NULL,
                                VisitID INT NOT NULL,
                                InteractionTypeID INT NOT NULL,
                                Notes NVARCHAR(MAX),
                                CONSTRAINT FK_DogInteraction_Dog1 FOREIGN KEY (DogID1) REFERENCES Dog(DogID),
                                CONSTRAINT FK_DogInteraction_Dog2 FOREIGN KEY (DogID2) REFERENCES Dog(DogID),
                                CONSTRAINT FK_DogInteraction_Visit FOREIGN KEY (VisitID) REFERENCES Visit(VisitID),
                                CONSTRAINT FK_DogInteraction_InteractionType FOREIGN KEY (InteractionTypeID) REFERENCES InteractionType(InteractionTypeID),
                                CONSTRAINT CK_DogInteraction_DifferentDogs CHECK (DogID1 <> DogID2)
);

-- Create indices
CREATE INDEX IX_Dog_OwnerID ON Dog(OwnerID);
CREATE INDEX IX_Membership_OwnerID ON Membership(OwnerID);
CREATE INDEX IX_Visit_DogID ON Visit(DogID);
CREATE INDEX IX_Visit_MembershipID ON Visit(MembershipID);
CREATE INDEX IX_Visit_CheckInTime ON Visit(CheckInTime);
CREATE INDEX IX_VaccinationRecord_DogID ON VaccinationRecord(DogID);
CREATE INDEX IX_VaccinationRecord_ExpirationDate ON VaccinationRecord(ExpirationDate);
CREATE INDEX IX_AreaUsage_VisitID ON AreaUsage(VisitID);
CREATE INDEX IX_AreaUsage_AreaID ON AreaUsage(AreaID);
CREATE INDEX IX_BehaviorIncident_DogID ON BehaviorIncident(DogID);
CREATE INDEX IX_DogInteraction_DogID1 ON DogInteraction(DogID1);
CREATE INDEX IX_DogInteraction_DogID2 ON DogInteraction(DogID2);
CREATE INDEX IX_DogInteraction_VisitID ON DogInteraction(VisitID);

-- Create views
GO
CREATE VIEW vw_ActiveMemberships AS
SELECT m.MembershipID, o.OwnerID, o.FirstName, o.LastName, o.Email, o.PhoneNumber,
       m.MembershipType, m.StartDate, m.EndDate, m.Price, m.AutoRenew
FROM Membership m
         JOIN Owner o ON m.OwnerID = o.OwnerID
WHERE m.IsActive = 1 AND o.IsActive = 1 AND m.EndDate >= GETDATE();
GO

CREATE VIEW vw_ExpiringVaccinations AS
SELECT d.DogID, d.Name, d.Breed, o.OwnerID, o.FirstName, o.LastName, o.Email, o.PhoneNumber,
       v.VaccinationType, v.ExpirationDate
FROM VaccinationRecord v
         JOIN Dog d ON v.DogID = d.DogID
         JOIN Owner o ON d.OwnerID = o.OwnerID
WHERE v.ExpirationDate BETWEEN GETDATE() AND DATEADD(day, 30, GETDATE())
  AND d.IsActive = 1 AND o.IsActive = 1;
GO

CREATE OR ALTER VIEW vw_ParkOccupancy AS
SELECT
    a.AreaID,
    a.AreaName,
    a.MaxCapacity,
    COUNT(DISTINCT au.AreaUsageID) AS CurrentOccupancy,
    a.MaxCapacity - COUNT(DISTINCT au.AreaUsageID) AS AvailableSpots
FROM
    ParkArea a
        LEFT JOIN
    AreaUsage au ON a.AreaID = au.AreaID
        LEFT JOIN
    Visit v ON au.VisitID = v.VisitID
WHERE
    a.IsActive = 1
  AND (
    au.AreaUsageID IS NULL
        OR (
        v.CheckInTime <= GETDATE()
            AND (v.CheckOutTime IS NULL OR v.CheckOutTime > GETDATE())
            AND au.EntryTime <= GETDATE()
            AND (au.ExitTime IS NULL OR au.ExitTime > GETDATE())
        )
    )
GROUP BY
    a.AreaID,
    a.AreaName,
    a.MaxCapacity;
GO

----------------------------------------------------------------------------
-- Store procedures
----------------------------------------------------------------------------

-- Create the historical data table
CREATE TABLE VisitHistory (
    HistoryID INT PRIMARY KEY IDENTITY(1,1),
-- Owner Info
    OwnerID INT NOT NULL,
    OwnerFirstName NVARCHAR(50) NOT NULL,
    OwnerLastName NVARCHAR(50) NOT NULL,
    OwnerEmail NVARCHAR(100) NOT NULL,
    OwnerCity NVARCHAR(50),
    OwnerState NVARCHAR(2),
-- Dog Info
    DogID INT NOT NULL,
    DogName NVARCHAR(50) NOT NULL,
    DogBreed NVARCHAR(50) NOT NULL,
    DogSize NVARCHAR(10) NOT NULL,
-- Visit data
    VisitID INT NOT NULL,    -- No foreign key constraint to allow deletion
    VisitDate DATE NOT NULL,
    CheckInTime TIME NOT NULL,
    CheckOutTime TIME,
    VisitDurationMinutes INT,
    MembershipType NVARCHAR(20) NOT NULL,
-- Metadata
    ArchivedDate DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- Create  index for performance
CREATE INDEX IX_VisitHistory_VisitID ON VisitHistory(VisitID);
GO


--  Create the archive stored procedure
CREATE OR ALTER PROCEDURE sp_ArchiveVisitHistory1
@DaysOld INT = 30  
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CutoffDate DATE = DATEADD(DAY, -@DaysOld, GETDATE());
    DECLARE @ArchivedCount INT = 0;

    -- Archive completed visits that are older than the cutoff date and not yet archived
    INSERT INTO VisitHistory (
        OwnerID, OwnerFirstName, OwnerLastName, OwnerEmail, OwnerCity, OwnerState,
        DogID, DogName, DogBreed, DogSize,
        VisitID, VisitDate, CheckInTime, CheckOutTime, VisitDurationMinutes, MembershipType
    )
    SELECT
        -- Owner demographics
        o.OwnerID, o.FirstName, o.LastName, o.Email, o.City, o.State,

        -- Dog demographics
        d.DogID, d.Name, d.Breed, d.Size,

        -- Visit data
        v.VisitID,
        CAST(v.CheckInTime AS DATE) AS VisitDate,
        CAST(v.CheckInTime AS TIME) AS CheckInTime,
        CAST(v.CheckOutTime AS TIME) AS CheckOutTime,
        DATEDIFF(MINUTE, v.CheckInTime, v.CheckOutTime) AS VisitDurationMinutes,
        m.MembershipType
    FROM
        Visit v
            JOIN Dog d ON v.DogID = d.DogID
            JOIN Owner o ON d.OwnerID = o.OwnerID
            JOIN Membership m ON v.MembershipID = m.MembershipID
    WHERE
        v.CheckOutTime IS NOT NULL  -- Only completed visits
      AND CAST(v.CheckInTime AS DATE) < @CutoffDate  -- Older than cutoff
      AND NOT EXISTS (  -- Not already archived
        SELECT 1 FROM VisitHistory vh WHERE vh.VisitID = v.VisitID
    );

    SET @ArchivedCount = @@ROWCOUNT;
    PRINT 'Archived ' + CAST(@ArchivedCount AS NVARCHAR) + ' visit records to VisitHistory table.';

    RETURN @ArchivedCount;
END;
GO


-- Create the delete stored procedure
CREATE OR ALTER PROCEDURE sp_DeleteArchivedVisits1
@DaysOld INT = 30  -- Only delete visits older than this many days
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CutoffDate DATE = DATEADD(DAY, -@DaysOld, GETDATE());

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Delete related records first to maintain referential integrity

        -- AreaUsage records
        DELETE au
        FROM AreaUsage au
                 INNER JOIN Visit v ON au.VisitID = v.VisitID
                 INNER JOIN VisitHistory vh ON v.VisitID = vh.VisitID
        WHERE CAST(v.CheckInTime AS DATE) < @CutoffDate;

        PRINT 'Deleted ' + CAST(@@ROWCOUNT AS NVARCHAR) + ' AreaUsage records.';

        -- BehaviorIncident records
        DELETE bi
        FROM BehaviorIncident bi
                 INNER JOIN Visit v ON bi.VisitID = v.VisitID
                 INNER JOIN VisitHistory vh ON v.VisitID = vh.VisitID
        WHERE CAST(v.CheckInTime AS DATE) < @CutoffDate;

        PRINT 'Deleted ' + CAST(@@ROWCOUNT AS NVARCHAR) + ' BehaviorIncident records.';

        -- DogInteraction records
        DELETE di
        FROM DogInteraction di
                 INNER JOIN Visit v ON di.VisitID = v.VisitID
                 INNER JOIN VisitHistory vh ON v.VisitID = vh.VisitID
        WHERE CAST(v.CheckInTime AS DATE) < @CutoffDate;

        PRINT 'Deleted ' + CAST(@@ROWCOUNT AS NVARCHAR) + ' DogInteraction records.';

        -- Finally delete the Visit records
        DELETE v
        FROM Visit v
                 INNER JOIN VisitHistory vh ON v.VisitID = vh.VisitID
        WHERE CAST(v.CheckInTime AS DATE) < @CutoffDate;

        PRINT 'Deleted ' + CAST(@@ROWCOUNT AS NVARCHAR) + ' Visit records.';

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        PRINT 'Error: ' + ERROR_MESSAGE();
        THROW;
    END CATCH
END;
GO


-- How to use both procedures:
-- Step 1: First archive old visits
-- EXEC sp_ArchiveVisitHistory1 @DaysOld = 30;

-- Step 2: Delete the archived records
-- EXEC sp_DeleteArchivedVisits1 @DaysOld = 30;
