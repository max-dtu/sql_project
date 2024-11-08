
-- It must contain
-- (1) the statements used to create the database, its tables and views (as used in section 3 of the report)
-- (2) the statements used to populate the tables (as used in section 4)

CREATE TABLE BusStops (
    stop_id INT PRIMARY KEY,
    stop_name VARCHAR(100) NOT NULL,
    GPS VARCHAR(50) NOT NULL,
    line_id INT NOT NULL,
    FOREIGN KEY (line_id) REFERENCES BusLines(line_id)
);

CREATE TABLE BusLines (
    line_id INT PRIMARY KEY,
    line_name VARCHAR(100) NOT NULL,
    final_destination INT NOT NULL,
    FOREIGN KEY (final_destination) REFERENCES BusStops(stop_id)
);

CREATE TABLE LineStops (
    line_id INT NOT NULL,
    stop_id INT NOT NULL,
    stop_order INT NOT NULL,
    PRIMARY KEY (line_id, stop_id),
    FOREIGN KEY (line_id) REFERENCES BusLines(line_id),
    FOREIGN KEY (stop_id) REFERENCES BusStops(stop_id)
);

CREATE TABLE Passengers (
    card_id INT PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    zip VARCHAR(20) NOT NULL,
    city VARCHAR(50) NOT NULL,
    street_name VARCHAR(100) NOT NULL,
    civic_number VARCHAR(10) NOT NULL,
    number VARCHAR(15) UNIQUE NOT NULL
);


CREATE TABLE PassengerPhone (
    number VARCHAR(15) NOT NULL,
    card_id INT NOT NULL,
    PRIMARY KEY (number),
    FOREIGN KEY (card_id) REFERENCES Passengers(card_id)
);


CREATE TABLE Rides (
    ride_id INT PRIMARY KEY,
    start_time DATETIME NOT NULL,
    duration INT NOT NULL,
    on_stop_id INT NOT NULL,
    off_stop_id INT NOT NULL,
    line_id INT NOT NULL,
    passenger_id INT NOT NULL,
    FOREIGN KEY (on_stop_id) REFERENCES BusStops(stop_id),
    FOREIGN KEY (off_stop_id) REFERENCES BusStops(stop_id),
    FOREIGN KEY (line_id) REFERENCES BusLines(line_id),
    FOREIGN KEY (passenger_id) REFERENCES Passengers(card_id)
);


INSERT INTO BusStops (stop_id, stop_name, GPS, line_id) VALUES
(1, 'Central Station', '55.6761,12.5683', 1),
(2, 'Main Square', '55.6759,12.5690', 1),
(3, 'University', '55.6800,12.5710', 2),
(4, 'City Hall', '55.6771,12.5700', 2),
(5, 'Airport', '55.7000,12.5705', 3),
(6, 'Business District', '55.6782,12.5721', 1),
(7, 'Old Town', '55.6790,12.5735', 2),
(8, 'Park', '55.6741,12.5688', 3),
(9, 'Museum', '55.6722,12.5666', 1),
(10, 'Harbor', '55.6700,12.5655', 3),
(11, 'Library', '55.6710,12.5640', 2),
(12, 'University Hospital', '55.6765,12.5720', 1),
(13, 'Shopping Mall', '55.6770,12.5741', 3),
(14, 'Stadium', '55.6799,12.5751', 2),
(15, 'Convention Center', '55.6751,12.5695', 1),
(16, 'Zoo', '55.6715,12.5680', 2),
(17, 'Botanical Garden', '55.6732,12.5675', 3),
(18, 'Opera House', '55.6773,12.5728', 2),
(19, 'Mountain Park', '55.6785,12.5744', 1),
(20, 'Lakeside', '55.6769,12.5752', 3);


INSERT INTO BusLines (line_id, line_name, final_destination) VALUES
(1, 'Line 1', 2),
(2, 'Line 2', 4),
(3, 'Airport Express', 5),
(4, 'City Loop', 10),
(5, 'Park Connector', 16),
(6, 'Museum Line', 9),
(7, 'Harbor Line', 10),
(8, 'University Shuttle', 11),
(9, 'Shopping Express', 13),
(10, 'Stadium Route', 14),
(11, 'Convention Connector', 15),
(12, 'Zoo Route', 16),
(13, 'Botanical Express', 17),
(14, 'Opera Express', 18),
(15, 'Mountain Route', 19),
(16, 'Lakeside Line', 20),
(17, 'Night Shuttle', 3),
(18, 'Morning Connector', 12),
(19, 'Business Shuttle', 6),
(20, 'Old Town Loop', 7);

INSERT INTO LineStops (line_id, stop_id, stop_order) VALUES
(1, 1, 1), (1, 2, 2), (1, 6, 3), (1, 9, 4), -- Line 1 starts at Central Station (1), ends at Museum (9)
(2, 3, 1), (2, 4, 2), (2, 7, 3), (2, 11, 4),
(3, 1, 1), (3, 5, 2), (3, 8, 3), (3, 10, 4),
(4, 1, 1), (4, 10, 2), (4, 15, 3), (4, 9, 4),
(5, 8, 1), (5, 16, 2), (5, 12, 3), (5, 18, 4),
(6, 2, 1), (6, 9, 2), (6, 6, 3), (6, 17, 4),
(7, 10, 1), (7, 3, 2), (7, 7, 3), (7, 19, 4),
(8, 4, 1), (8, 11, 2), (8, 14, 3), (8, 13, 4),
(9, 5, 1), (9, 13, 2), (9, 2, 3), (9, 15, 4),
(10, 3, 1), (10, 14, 2), (10, 7, 3), (10, 8, 4);




INSERT INTO Passengers (card_id, email, first_name, last_name, country, zip, city, street_name, civic_number, number) VALUES
(1001, 'john.doe1@example.com', 'John', 'Doe', 'Denmark', '1000', 'Copenhagen', 'Main St', '10A', '12345678'),
(1002, 'jane.smith@example.com', 'Jane', 'Smith', 'Denmark', '2000', 'Copenhagen', 'Second St', '20B', '87654321'),
(1003, 'alice.jones@example.com', 'Alice', 'Jones', 'Sweden', '3000', 'Malmö', 'Third St', '30C', '56789012'),
(1004, 'sam.brown@example.com', 'Sam', 'Brown', 'Denmark', '1500', 'Odense', 'Fourth St', '40D', '12341234'),
(1005, 'emily.white@example.com', 'Emily', 'White', 'Norway', '5000', 'Oslo', 'Fifth St', '50E', '43214321'),
(1006, 'michael.black@example.com', 'Michael', 'Black', 'Denmark', '2500', 'Aarhus', 'Sixth St', '60F', '87657865'),
(1007, 'sara.green@example.com', 'Sara', 'Green', 'Sweden', '3100', 'Lund', 'Seventh St', '70G', '65876587'),
(1008, 'lily.blue@example.com', 'Lily', 'Blue', 'Denmark', '1300', 'Aalborg', 'Eighth St', '80H', '87658765'),
(1009, 'harry.pink@example.com', 'Harry', 'Pink', 'Finland', '6000', 'Helsinki', 'Ninth St', '90I', '65786578'),
(1010, 'ella.orange@example.com', 'Ella', 'Orange', 'Denmark', '1400', 'Odense', 'Tenth St', '100J', '78901234'),
(1011, 'nathan.purple@example.com', 'Nathan', 'Purple', 'Denmark', '2100', 'Frederiksberg', 'Eleventh St', '110K', '34567890'),
(1012, 'grace.gray@example.com', 'Grace', 'Gray', 'Denmark', '1500', 'Helsingor', 'Twelfth St', '120L', '23456789'),
(1013, 'daniel.brown@example.com', 'Daniel', 'Brown', 'Sweden', '2200', 'Lund', 'Thirteenth St', '130M', '45678901'),
(1014, 'sophie.white@example.com', 'Sophie', 'White', 'Norway', '1600', 'Oslo', 'Fourteenth St', '140N', '12349876'),
(1015, 'chris.black@example.com', 'Chris', 'Black', 'Finland', '2400', 'Turku', 'Fifteenth St', '150O', '78903210'),
(1016, 'laura.green@example.com', 'Laura', 'Green', 'Denmark', '1700', 'Odense', 'Sixteenth St', '160P', '56789123'),
(1017, 'oliver.blue@example.com', 'Oliver', 'Blue', 'Denmark', '1800', 'Copenhagen', 'Seventeenth St', '170Q', '12347654'),
(1018, 'lucas.pink@example.com', 'Lucas', 'Pink', 'Denmark', '1900', 'Copenhagen', 'Eighteenth St', '180R', '34568790'),
(1019, 'mia.orange@example.com', 'Mia', 'Orange', 'Sweden', '2900', 'Malmo', 'Nineteenth St', '190S', '23456780'),
(1020, 'jack.purple@example.com', 'Jack', 'Purple', 'Denmark', '2000', 'Roskilde', 'Twentieth St', '200T', '87654321');


INSERT INTO PassengerPhone (number, card_id) VALUES
('12345678', 1001), 
('87654321', 1002), 
('56789012', 1003), 
('12341234', 1004), 
('43214321', 1005), 
('87657865', 1006),
('65876587', 1007), 
('87658765', 1008), 
('65786578', 1009),
('78901234', 1010), 
('34567890', 1011), 
('23456789', 1012),
('45678901', 1013), 
('12349876', 1014), 
('78903210', 1015),
('56789123', 1016), 
('12347654', 1017), 
('34568790', 1018),
('23456780', 1019), 
('87654321', 1020);


INSERT INTO Rides (ride_id, start_time, duration, on_stop_id, off_stop_id, line_id, passenger_id) VALUES
(1, '2024-11-01 08:30:00', 15, 1, 2, 1, 1001), -- John Doe (1001) took Line 1 from Central Station (1) to Main Square (2) at 2024-11-01 08:30:00 and it took him 15 minutes 
(2, '2024-11-01 09:00:00', 30, 3, 4, 2, 1002), 
(3, '2024-11-01 10:00:00', 45, 1, 5, 3, 1003), 
(4, '2024-11-02 08:00:00', 15, 1, 2, 1, 1001),
(5, '2024-11-02 09:15:00', 25, 6, 7, 1, 1004), 
(6, '2024-11-03 10:20:00', 20, 2, 3, 2, 1005), 
(7, '2024-11-03 08:00:00', 30, 10, 8, 3, 1006), 
(8, '2024-11-04 12:30:00', 35, 9, 12, 1, 1007),
(9, '2024-11-04 11:15:00', 15, 11, 16, 5, 1008), 
(10, '2024-11-05 09:45:00', 25, 14, 13, 6, 1009),
(11, '2024-11-05 11:10:00', 30, 1, 4, 2, 1010), 
(12, '2024-11-06 10:00:00', 40, 10, 7, 7, 1011),
(13, '2024-11-06 08:15:00', 15, 8, 6, 1, 1012), 
(14, '2024-11-07 11:25:00', 45, 3, 5, 4, 1013),
(15, '2024-11-07 09:05:00', 20, 6, 8, 1, 1014), 
(16, '2024-11-08 10:30:00', 30, 7, 10, 2, 1015),
(17, '2024-11-08 07:45:00', 15, 15, 14, 3, 1016), 
(18, '2024-11-09 12:30:00', 25, 4, 11, 2, 1017),
(19, '2024-11-09 08:00:00', 35, 5, 9, 3, 1018), 
(20, '2024-11-10 09:45:00', 40, 1, 3, 1, 1019);


