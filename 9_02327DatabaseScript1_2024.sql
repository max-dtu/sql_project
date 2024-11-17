-- It must contain:
-- (1) the statements used to create the database, its tables and views (as used in section 3 of the report)
-- (2) the statements used to populate the tables (as used in section 4)

DROP DATABASE IF EXISTS MoviBus;
CREATE DATABASE MoviBus;
USE MoviBus;

CREATE TABLE Line (
    line_id INT PRIMARY KEY,
    line_name VARCHAR(255),
    final_destination INT NOT NULL
	-- FOREIGN KEY (final_destination) REFERENCES Stops(stop_id)
);

CREATE TABLE Stops (
    stop_id INT PRIMARY KEY,
    stop_name VARCHAR(255),
    GPS VARCHAR(255)
);



CREATE TABLE Buses (
    plate_number VARCHAR(20) PRIMARY KEY, 
    model VARCHAR(50) NOT NULL,          
    capacity INT NOT NULL,               
    manufacture_year YEAR NOT NULL       
);
CREATE TABLE Addresses (
    address_id INT PRIMARY KEY,
    country VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    zip INT NOT NULL,
    street_name VARCHAR(255) NOT NULL,
    civic_number VARCHAR(10) NOT NULL
);

CREATE TABLE Passengers (
    card_id INT PRIMARY KEY,
    email VARCHAR(255),
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    address_id INT,
    FOREIGN KEY (address_id) REFERENCES Addresses(address_id)
);

CREATE TABLE Rides_Passengers (
    start_date DATE NOT NULL,           
    start_time TIME NOT NULL,            
    bus_id VARCHAR(20) NOT NULL,         
    card_id INT NOT NULL,                
    PRIMARY KEY (start_date, start_time, bus_id, card_id), 
    FOREIGN KEY (bus_id) REFERENCES Buses(plate_number),  
	FOREIGN KEY (card_id) REFERENCES Passengers(card_id) 
);



CREATE TABLE Stops_Line (
    line_id INT,
    stop_id INT,
    stop_order INT NOT NULL,
    PRIMARY KEY (line_id, stop_id),
    FOREIGN KEY (line_id) REFERENCES Line(line_id),
    FOREIGN KEY (stop_id) REFERENCES Stops(stop_id)
);



CREATE TABLE Rides (
    start_date DATE NOT NULL,          
    start_time TIME NOT NULL,         
    bus_id VARCHAR(20) NOT NULL,       
    duration INT NOT NULL,             
    on_stop_id INT NOT NULL,         
    off_stop_id INT NOT NULL,        
    line_id INT NOT NULL,             
    PRIMARY KEY (start_date, start_time, bus_id), -- Composite primary key
    FOREIGN KEY (bus_id) REFERENCES Buses(plate_number), 
    FOREIGN KEY (on_stop_id) REFERENCES Stops(stop_id),  
    FOREIGN KEY (off_stop_id) REFERENCES Stops(stop_id), 
    FOREIGN KEY (line_id) REFERENCES Line(line_id)       
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
    card_id INT NOT NULL,
    FOREIGN KEY (card_id) REFERENCES Passengers(card_id)
);

 INSERT INTO Line (line_id, line_name, final_destination) VALUES
    (1, 'Kajkage express', 103),
    (2, 'Ydre måneby rute', 101),
    (3, 'Troldmandskvarteret Syd', 104),
    (4, 'Troldmandskvarteret Nord', 101),
    (5, 'GummiKarsten Circus', 105);


INSERT INTO Stops (stop_id, stop_name, GPS) VALUES
    (101, 'Bermuda Triangle', '25.0000,-71.0000'),
    (102, 'Krateret', '24.9640,-71.0205'),
    (103, 'Grotten', '25.0306,-70.9632'),
    (104, 'Lunar Campus', '24.9818,-70.9352'),
    (105, 'Rådhuset', '25.0061,-70.9840'),
    (106, 'The Best Stop', '25.0061,-70.9840'),
    (107, 'stop1', '25.0061,-70.9850'),
    (108, 'stop2', '25.0061,-70.9870'),
	(109, 'stop3', '25.0061,-70.8588'),
	(110, 'stop4', '25.0061,-70.9444');
    


INSERT INTO Buses (plate_number, model, capacity, manufacture_year) VALUES
    ('AB1234', 'Volvo 7900', 50, 2018),
    ('CD5678', 'Mercedes Citaro', 40, 2019),
    ('EF9012', 'MAN Lion’s City', 45, 2020),
    ('GH3456', 'Scania Citywide', 55, 2017),
    ('IJ7890', 'BYD K9', 42, 2021);


INSERT INTO Addresses (address_id, country, city, zip, street_name, civic_number) VALUES
    (111, 'Bermuda', 'Måneby', 10001, 'Grottevej', '10A'),
    (112, 'Bermuda', 'Måneby', 10002, 'Troldestræde', '20B'),
    (113, 'Bermuda', 'Måneby', 10003, 'Krater Allé', '30C');


INSERT INTO Passengers (card_id, email, first_name, last_name, address_id) VALUES
    (1001, 'martin@bitfrost.com', 'Martin', 'Bitfrost', 111),
    (1002, 'martinogmette@posteo.dk', 'Martin', 'Grønbech', 111),
    (1003, 'gottago@fastmail.com', 'Sonic', 'Thehedgehog', 112),
    (1004, 'xxx_Shadow_xxx@xxx.com', 'Shadow', 'Shadowsen', 113),
    (1005, 'gothboy96@gmail.com', 'Gothboy', 'Ninentysix', 113);
	


INSERT INTO Rides (start_date, start_time, bus_id, duration, on_stop_id, off_stop_id, line_id) VALUES

    ('2023-10-01', '08:00:00', 'AB1234', 30, 101, 104, 1), 
    ('2023-10-01', '08:30:00', 'CD5678', 40, 101, 104, 1), 
    
    ('2023-10-02', '09:00:00', 'EF9012', 20, 103, 106, 3), 
    ('2023-10-02', '09:30:00', 'GH3456', 15, 101, 106, 4);


INSERT INTO Rides_Passengers (start_date, start_time, bus_id, card_id) VALUES

 ('2023-10-01', '08:00:00', 'AB1234', 1001), 
    ('2023-10-01', '08:30:00', 'CD5678', 1004), 
    
    ('2023-10-02', '09:00:00', 'EF9012', 1002), 
    ('2023-10-02', '09:30:00', 'GH3456', 1005);

	


INSERT INTO Stops_Line (line_id, stop_id, stop_order) VALUES
    (1, 101, 1),
    (1, 102, 2),
    (1, 103, 3),
    (1, 106, 4);


INSERT INTO Stops_Passengers (stop_id, card_id) VALUES
    (101, 1001),
    (103, 1003);


INSERT INTO PhoneNumbers (number, card_id) VALUES
    ('1234567890', 1001),
    ('0987654321', 1001),
    ('1122334455', 1002),
    ('2233445566', 1003);
 ALTER TABLE Line
  ADD CONSTRAINT fk_final_destination FOREIGN KEY (final_destination) REFERENCES Stops(stop_id);
 
