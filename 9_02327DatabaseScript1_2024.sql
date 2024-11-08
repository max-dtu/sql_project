-- It must contain:
-- (1) the statements used to create the database, its tables and views (as used in section 3 of the report)
-- (2) the statements used to populate the tables (as used in section 4)


DROP DATABASE IF EXISTS MoviBus;
CREATE DATABASE MoviBus;
USE MoviBus;

CREATE TABLE BusLines (
    line_id INT PRIMARY KEY,
    line_name VARCHAR(100) NOT NULL,
    final_destination INT NOT NULL
	 -- FOREIGN KEY (final_destination) REFERENCES BusStops(final_destination)
);

CREATE TABLE BusStops (
    stop_id INT PRIMARY KEY,
    stop_name VARCHAR(100) NOT NULL,
    GPS VARCHAR(50) NOT NULL,
    line_id INT NOT NULL,
    FOREIGN KEY (line_id) REFERENCES BusLines(line_id)
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
    civic_number VARCHAR(10) NOT NULL
);


CREATE TABLE PassengerPhone (
    number VARCHAR(15) NOT NULL,
    card_id INT NOT NULL,
    PRIMARY KEY (number),
    FOREIGN KEY (card_id) REFERENCES Passengers(card_id)
);

CREATE TABLE Rides (
    ride_id INT PRIMARY KEY,
    start_date DATE NOT NULL,
    start_time TIME NOT NULL,
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

INSERT INTO BusLines (line_id, line_name, final_destination) VALUES 
    (1, 'Downtown Express', 101),
    (2, 'City Circle', 102),
    (3, 'North Route', 103);


INSERT INTO BusStops (stop_id, stop_name, GPS, line_id) VALUES 
    (101, 'Central Station', '40.748817,-73.985428', 1),
    (102, 'City Hall', '40.712776,-74.005974', 2),
    (103, 'Museum of Art', '40.779437,-73.963244', 3),
    (104, 'University Campus', '40.730610,-73.935242', 1),
    (105, 'Park Avenue', '40.754932,-73.984016', 2);


INSERT INTO LineStops (line_id, stop_id, stop_order) VALUES 
    (1, 101, 1),
    (1, 104, 2),
    (2, 102, 1),
    (2, 105, 2),
    (3, 103, 1);


INSERT INTO Passengers (card_id, email, first_name, last_name, country, zip, city, street_name, civic_number) VALUES 
    (1001, 'john.doe@example.com', 'John', 'Doe', 'USA', '10001', 'New York', '5th Avenue', '21'),
    (1002, 'jane.smith@example.com', 'Jane', 'Smith', 'USA', '10002', 'New York', 'Broadway', '100'),
    (1003, 'sam.wilson@example.com', 'Sam', 'Wilson', 'USA', '10003', 'New York', 'Madison Ave', '200');


INSERT INTO PassengerPhone (number, card_id) VALUES 
    ('1234567890', 1001),
    ('0987654321', 1002),
    ('1122334455', 1003);


INSERT INTO Rides (ride_id, start_date, start_time, duration, on_stop_id, off_stop_id, line_id, passenger_id) VALUES 
    (5001, '2023-10-01', '08:00:00', 30, 101, 104, 1, 1001),
    (5002, '2023-10-02', '09:30:00', 20, 102, 105, 2, 1002),
    (5003, '2023-10-03', '10:15:00', 45, 103, 101, 3, 1003);


 ALTER TABLE BusLines
 ADD CONSTRAINT fk_final_destination FOREIGN KEY (final_destination) REFERENCES BusStops(stop_id);
