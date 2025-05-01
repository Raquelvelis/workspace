-- Sample Data for Dog Park Database

-- 1. Owner Table

USE DOG_PARK_DB;
GO

INSERT INTO Owner (FirstName, LastName, Email, PhoneNumber, Address, City, State, ZipCode, RegistrationDate,
                   IsActive, EmergencyContact, EmergencyPhone)
VALUES ('John', 'Smith', 'john.smith@email.com', '555-123-4567', '123 Main St', 'Shakopee', 'MN', '62701',
        '2023-01-15', 1, 'Jane Smith', '555-123-4568'),
       ('Emma', 'Johnson', 'emma.j@email.com', '555-234-5678', '456 Oak Ave', 'Shakopee', 'MN', '62702',
        '2023-02-10', 1, 'Mike Johnson', '555-234-5679'),
       ( 'Michael', 'Williams', 'mike.w@email.com', '555-345-6789', '789 Pine Rd', 'Minneapolis', 'MN', '62703',
        '2023-02-25', 1, 'Sarah Williams', '555-345-6780'),
       ( 'Sophia', 'Brown', 'sophia.b@email.com', '555-456-7890', '101 Elm Blvd', 'St Paul', 'MN', '62704',
        '2023-03-05', 1, 'Robert Brown', '555-456-7891'),
       ( 'James', 'Jones', 'james.j@email.com', '555-567-8901', '202 Maple Dr', 'Eden Prairie', 'MN', '62704',
        '2023-03-20', 0, 'Linda Jones', '555-567-8902');


-- 2. Dog Table

INSERT INTO Dog (OwnerID, Name, Breed, Size, DateOfBirth, Gender, Color, Temperament, SpecialNotes, QRCodeID,
                 IsActive)
VALUES ( 2, 'Max', 'Labrador Retriever', 'Large', '2020-06-12', 'Male', 'Yellow', 'Friendly, Energetic',
        'Loves water and playing fetch', 'QR-D0001', 1),
       (2, 'Bella', 'Beagle', 'Medium', '2021-03-25', 'Female', 'Tricolor', 'Playful, Curious',
        'Can be vocal when excited', 'QR-D0002', 1),
       ( 3, 'Charlie', 'Golden Retriever', 'Large', '2019-08-10', 'Male', 'Golden', 'Gentle, Sociable',
        'Good with all dogs and children', 'QR-D0003', 1),
       ( 4, 'Luna', 'German Shepherd', 'Large', '2021-01-15', 'Female', 'Black and Tan', 'Alert, Protective',
        'Can be shy with new dogs at first', 'QR-D0004', 1),
       ( 4, 'Cooper', 'Jack Russell Terrier', 'Small', '2020-11-30', 'Male', 'White and Brown', 'Energetic, Bold',
        'High energy, needs plenty of exercise', 'QR-D0005', 1),
       ( 5, 'Daisy', 'Poodle', 'Medium', '2022-02-14', 'Female', 'White', 'Intelligent, Reserved',
        'Prefers calmer environments', 'QR-D0006', 1),
       ( 6, 'Rocky', 'Boxer', 'Large', '2019-05-20', 'Male', 'Brindle', 'Playful, Protective',
        'Plays rough sometimes but friendly', 'QR-D0007', 0);


-- 3. Membership Table

INSERT INTO Membership ( OwnerID, MembershipType, StartDate, EndDate, IsActive, Price, AutoRenew,
                        LastRenewalNotice)
VALUES (2, 'Annual', '2023-01-15', '2024-01-15', 1, 299.99, 1, '2023-12-15'),
       (3, 'Monthly', '2023-04-10', '2023-05-10', 1, 29.99, 1, NULL),
       (4, 'Annual', '2023-02-25', '2024-02-25', 1, 299.99, 0, NULL),
       (5, 'Daily', '2023-04-15', '2023-04-15', 0, 10.99, 0, NULL),
       (5, 'Monthly', '2023-04-20', '2023-05-20', 1, 29.99, 1, NULL),
       (6, 'Monthly', '2023-03-20', '2023-04-20', 0, 29.99, 0, '2023-04-13');


-- 4. Payment Table

INSERT INTO Payment ( OwnerID, MembershipID, PaymentDate, Amount, PaymentMethod, TransactionReference,
                     IsSuccessful)
VALUES ( 2, 2, '2023-01-15', 299.99, 'Credit Card', 'TXN12345', 1),
       ( 3, 3, '2023-04-10', 29.99, 'Credit Card', 'TXN23456', 1),
       ( 4, 4, '2023-02-25', 299.99, 'Bank Transfer', 'TXN34567', 1),
       ( 5, 5, '2023-04-15', 10.99, 'Cash', 'TXN45678', 1),
       ( 5, 6, '2023-04-20', 29.99, 'Credit Card', 'TXN56789', 1),
       ( 3, 3, '2023-05-10', 29.99, 'Credit Card', 'TXN67890', 1),
       ( 6, 7, '2023-03-20', 29.99, 'Credit Card', 'TXN78901', 1);


-- 5. Visit Table

INSERT INTO Visit (DogID, MembershipID, CheckInTime, CheckOutTime, IsReservation, ReservationTime, Notes)
VALUES
    (2, 2, '2023-04-10 10:00:00', '2023-04-10 11:30:00', 0, NULL, 'Regular visit'),
    (3, 2, '2023-04-10 10:00:00', '2023-04-10 11:30:00', 0, NULL, 'Came with Max'),
    (4, 3, '2023-04-12 14:30:00', '2023-04-12 16:00:00', 1, '2023-04-12 14:30:00', 'Reserved day before'),
    (5, 4, '2023-04-14 09:15:00', '2023-04-14 10:45:00', 0, NULL, 'Morning visit'),
    (6, 4, '2023-04-14 09:15:00', '2023-04-14 10:45:00', 0, NULL, 'Came with Luna'),
    (7, 6, '2023-04-21 16:00:00', '2023-04-21 17:30:00', 0, NULL, 'First visit with new membership'),
    (2, 2, '2023-04-22 11:00:00', '2023-04-22 12:45:00', 0, NULL, 'Weekend visit'),
    (3, 2, '2023-04-22 11:00:00', '2023-04-22 12:45:00', 0, NULL, 'Came with Max again');


-- 6. VaccinationRecord Table

INSERT INTO VaccinationRecord (DogID, VaccinationType, AdministrationDate, ExpirationDate, VetName,
                               VetContact, IsVerified)
VALUES (3, 'Rabies', '2022-05-10', '2023-05-10', 'Dr. Wilson', '555-111-2222', 1),
       (3, 'DHPP', '2022-05-10', '2023-05-10', 'Dr. Wilson', '555-111-2222', 1),
       (3, 'Bordetella', '2022-11-15', '2023-05-15', 'Dr. Wilson', '555-111-2222', 1),
       (3, 'Rabies', '2022-06-20', '2023-06-20', 'Dr. Wilson', '555-111-2222', 1),
       (3, 'DHPP', '2022-06-20', '2023-06-20', 'Dr. Wilson', '555-111-2222', 1),
       (4, 'Rabies', '2022-08-05', '2023-08-05', 'Dr. Martinez', '555-222-3333', 1),
       (4, 'DHPP', '2022-08-05', '2023-08-05', 'Dr. Martinez', '555-222-3333', 1),
       (4, 'Bordetella', '2022-08-05', '2023-02-05', 'Dr. Martinez', '555-222-3333', 0),
       (5, 'Rabies', '2022-09-12', '2023-09-12', 'Dr. Johnson', '555-333-4444', 1),
       (6, 'Rabies', '2022-10-23', '2023-10-23', 'Dr. Johnson', '555-333-4444', 1),
       ( 7, 'Rabies', '2023-01-30', '2024-01-30', 'Dr. Garcia', '555-444-5555', 1),
       (7, 'DHPP', '2023-01-30', '2024-01-30', 'Dr. Garcia', '555-444-5555', 1),
       ( 8, 'Rabies', '2022-04-15', '2023-04-15', 'Dr. Clark', '555-555-6666', 0);


-- 7. BehaviorIncident Table

INSERT INTO BehaviorIncident (DogID, VisitID, IncidentTime, Description, SeverityLevel, StaffAction, FollowUpNotes)
VALUES
    (5, 5, '2023-04-14 10:00:00', 'Excessive barking when approached by larger dogs', 'Low', 'Verbal redirection, temporary separation', 'Owner advised to work on socialization with larger breeds'),
    (7, NULL, '2023-03-25 15:30:00', 'Growled and snapped at another dog over a toy', 'Medium', 'Separated dogs, removed toy from play area', 'Will monitor closely on future visits, recommended training'),
    ( 3, 8, '2023-04-22 12:15:00', 'Jumped on an elderly visitor', 'Low', 'Leashed temporarily, redirected to different play area', 'Owner working on jump training');


-- 8. InteractionType Table

INSERT INTO InteractionType (TypeName, Description, IsPositive)
VALUES ( 'Play', 'Dogs engaged in mutual play behavior', 1),
       ( 'Avoidance', 'One dog actively avoiding interaction with another', 0),
       ( 'Conflict', 'Growling, snapping, or other conflict behaviors', 0),
       ( 'Neutral', 'Dogs acknowledge each other but minimal interaction', 1),
       ( 'Friendly', 'Positive greeting and social behavior', 1);


-- 9. DogInteraction Table

INSERT INTO DogInteraction ( DogID1, DogID2, VisitID, InteractionTypeID, Notes)
VALUES
    ( 3, 4, 3, 3, 'Played fetch together, good compatibility'),
    ( 3, 4, 8, 3, 'Bella avoided Luna throughout visit'),
    ( 5, 6, 5, 3, 'Brief growling when Cooper approached Daisy s water bowl'),
    (3, 3, 4, 5, 'Familiar with each other, positive greeting'),
    ( 3, 4, 3, 4, 'Brief sniffing, then separated naturally');


-- 10. ParkArea Table
  
INSERT INTO ParkArea ( AreaName, DogSizeCategory, MaxCapacity, Description, IsActive)
VALUES 
( 'Small Dog Area', 'Small', 15, 'For dogs under 25 pounds', 1),
( 'Large Dog Area', 'Large', 20, 'For dogs over 25 pounds', 1),
( 'Agility Zone', 'All', 10, 'Area with agility equipment for all sizes', 1),
( 'Splash Pad', 'All', 12, 'Water play area available in summer months', 0),
( 'Quiet Corner', 'All', 5, 'Calmer area for shy or senior dogs',1);


-- 11. AreaUsage Table

INSERT INTO AreaUsage (VisitID, AreaID, EntryTime, ExitTime)
VALUES
    ( 1, 2, '2023-04-10 10:15:00', '2023-04-10 11:20:00'),
    ( 2, 2, '2023-04-10 10:15:00', '2023-04-10 11:20:00'),
    ( 3, 3, '2023-04-12 14:45:00', '2023-04-12 15:30:00'),
    ( 3, 2, '2023-04-12 15:30:00', '2023-04-12 15:55:00'),
    ( 4, 2, '2023-04-14 09:20:00', '2023-04-14 10:30:00'),
    ( 5, 1, '2023-04-14 09:20:00', '2023-04-14 10:30:00'),
    ( 6, 5, '2023-04-21 16:10:00', '2023-04-21 17:20:00'),
    ( 7, 2, '2023-04-22 11:10:00', '2023-04-22 12:30:00'),
    ( 8, 2, '2023-04-22 11:10:00', '2023-04-22 12:30:00');
