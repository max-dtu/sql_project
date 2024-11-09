-- It must contain:
-- (1) the statements used to create the database, its tables and views (as used in section 3 of the report)
-- (2) the statements used to populate the tables (as used in section 4)

DROP DATABASE IF EXISTS MoviBus;
CREATE DATABASE MoviBus;
USE MoviBus;

CREATE TABLE Line (
    line_id INT PRIMARY KEY,
    line_name VARCHAR(255),
    final_destination INT
	-- FOREIGN KEY (final_destination) REFERENCES Stops(stop_id)
);

CREATE TABLE Stops (
    stop_id INT PRIMARY KEY,
    stop_name VARCHAR(255),
    GPS VARCHAR(255),
    line_id INT,
    FOREIGN KEY (line_id) REFERENCES Line(line_id)
);

CREATE TABLE Line_Stops (
    line_id INT,
    stop_id INT,
    stop_order INT,
    PRIMARY KEY (line_id, stop_id),
    FOREIGN KEY (line_id) REFERENCES Line(line_id),
    FOREIGN KEY (stop_id) REFERENCES Stops(stop_id)
);

CREATE TABLE Addresses (
    address_id INT PRIMARY KEY,
    country VARCHAR(255),
    city VARCHAR(255),
    zip INT,
    street_name VARCHAR(255),
    civic_number VARCHAR(10)
);

CREATE TABLE Passengers (
    card_id INT PRIMARY KEY,
    email VARCHAR(255),
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    address_id INT,
    FOREIGN KEY (address_id) REFERENCES Addresses(address_id)
);

CREATE TABLE Rides (
    card_id INT,
    ride_id INT,
    start_date DATE,
    start_time TIME,
    duration INT,
    on_stop_id INT,
    off_stop_id INT,
    line_id INT,
    PRIMARY KEY (card_id, ride_id),
    FOREIGN KEY (card_id) REFERENCES Passengers(card_id),
    FOREIGN KEY (line_id) REFERENCES Line(line_id),
    FOREIGN KEY (on_stop_id) REFERENCES Stops(stop_id),
    FOREIGN KEY (off_stop_id) REFERENCES Stops(stop_id)
);


CREATE TABLE Stops_Passengers (
    stop_id INT,
    card_id INT,
    PRIMARY KEY (stop_id, card_id),
    FOREIGN KEY (stop_id) REFERENCES Stops(stop_id),
    FOREIGN KEY (card_id) REFERENCES Passengers(card_id)
);

CREATE TABLE PhoneNumbers (
    number VARCHAR(20) PRIMARY KEY,
    card_id INT,
    FOREIGN KEY (card_id) REFERENCES Passengers(card_id)
);

 
 INSERT INTO Line (line_id, line_name, final_destination) VALUES
(1, 'Downtown Express', 101),
(2, 'City Circle', 102),
(3, 'North Route', 103),
(4, 'South Shuttle', 104);

INSERT INTO Stops (stop_id, stop_name, GPS, line_id) VALUES
(101, 'Central Station', '40.748817,-73.985428', 1),
(102, 'City Hall', '40.712776,-74.005974', 2),
(103, 'Museum of Art', '40.779437,-73.963244', 3),
(104, 'University Campus', '40.730610,-73.935242', 4),
(105, 'Park Avenue', '40.754932,-73.984016', 2);

INSERT INTO Addresses (address_id, country, city, zip, street_name, civic_number) VALUES
(111, 'USA', 'New York', 10001, '5th Ave', '10A'),
(112, 'USA', 'New York', 10002, 'Broadway', '20B'),
(113, 'USA', 'New York', 10003, 'Wall St', '30C');

INSERT INTO Passengers (card_id, email, first_name, last_name, address_id) VALUES
(1001, 'john.doe@ex.com', 'John', 'Doe', 111),
(1002, 'jane.smith@ex.com', 'Jane', 'Smith', 111),
(1003, 'sam.wilson@ex.com', 'Sam', 'Wilson', 112),
(1004, 'emily.jones@ex.com', 'Emily', 'Jones', 113);

INSERT INTO Rides (card_id, ride_id, start_date, start_time, duration, on_stop_id, off_stop_id, line_id) VALUES
(1001, 50001, '2023-10-01', '08:00:00', 30, 101, 102, 1), -- Single passenger on a ride
(1002, 50001, '2023-10-01', '08:00:00', 30, 101, 102, 1), -- Multiple passengers on the same ride
(1003, 50002, '2023-10-02', '09:30:00', 20, 102, 103, 2),
(1003, 50003, '2023-10-02', '11:15:00', 20, 103, 102, 3), -- A passenger taking multiple rides
(1004, 50004, '2023-10-03', '12:45:00', 25, 104, 105, 4); -- Another ride on a different line

INSERT INTO Line_Stops (line_id, stop_id, stop_order) VALUES
(1, 101, 1),
(1, 102, 2),
(1, 103, 3), -- Stops in order for Downtown Express line
(2, 103, 1),
(2, 102, 2),
(2, 105, 3), -- Stops in order for City Circle line
(3, 101, 1),
(3, 104, 2), -- Stops in order for North Route line
(4, 105, 1),
(4, 104, 2); -- Stops in order for South Shuttle line

INSERT INTO Stops_Passengers (stop_id, card_id) VALUES
(101, 1001), -- Passenger at Central Station
(101, 1002), -- Another passenger at Central Station
(102, 1001), -- Same passenger using multiple stops
(103, 1003), -- New passenger at Museum of Art
(104, 1004); -- New passenger at University Campus


INSERT INTO PhoneNumbers (number, card_id) VALUES
('1234567890', 1001), -- John Doe's phone number
('0987654321', 1001), -- John Doe has multiple numbers
('1122334455', 1002), -- Jane Smith's phone number
('2233445566', 1003); -- Sam Wilson's phone number

ALTER TABLE Line
 ADD CONSTRAINT fk_final_destination FOREIGN KEY (final_destination) REFERENCES Stops(stop_id);
 
