-- It must contain:
  -- (1) the delete/update statements used to change the tables (as in section 5)
  INSERT INTO Stops (stop_id, stop_name, GPS)
VALUES (107, 'DTU Lyngby Campus', '55.7849149,12.5219711');

INSERT INTO Stops (stop_id, stop_name, GPS) VALUES
(108, 'Rest stop 1', '35.2616383,-47.23901445'),
(109, 'Rest stop 2', '45.5232766,-23.4780289'),
(110, 'Klampenborgvej', '55.774613630806115, 12.524482144716382');

select * from Stops;


UPDATE Stops
SET GPS = '55.7849149,12.5219711'  -- New GPS coordinates for Krateret
WHERE stop_id = 102;

select * from Stops WHERE stop_id = 102;
-- reslut after executing the above UPDATE command:
-- '102', 'Krateret', '55.7849149,12.5219711'


DELETE FROM Stops WHERE stop_id = 107;

  -- (2) the queries made (as in section 6)
    -- Answer the following questions by writing appropriate SQL table queries:
      -- Show the ID of the passengers who took a ride from the first stop of the line taken.
select * from Rides, Stops_Line where Stops_Line.stop_order = 1; -- testing
SELECT Rides_Passengers.card_id, Rides.*, Stops_Line.*
FROM Rides JOIN Stops_Line ON Rides.on_stop_id = Stops_Line.stop_id
JOIN Rides_Passengers ON Rides.start_date = Rides_Passengers.start_date 
                      AND Rides.start_time = Rides_Passengers.start_time 
                      AND Rides.bus_id = Rides_Passengers.bus_id
WHERE Stops_Line.stop_order = 1;
-- or
SELECT distinct Rides_Passengers.card_id FROM Rides, Stops_Line, Rides_Passengers WHERE Rides.on_stop_id = Stops_Line.stop_id and Stops_Line.stop_order = 1;
 -- This will do a cartesian join and then, it will only keep the rows with Rides.on_stop_id = Stops_Line.stop_id and on_stop_id order = 1, A passenger could take 2 lines, both from the start of the line. The second join maps each row from the first join to a card_id.

      -- Show the name of the bus stop served my most lines.
      select stop_id, count(Stops_Line.stop_id) as stop_count from Stops_Line group by Stops_Line.stop_id ORDER BY stop_count DESC; -- Here we just count the stop_ids and order them and the top row will be the name of the bus stop served by most lines.

      -- For each line, show the ID of the passenger who took the ride that lasted longer.
            SELECT * FROM Rides JOIN Rides_Passengers USING (start_date, start_time, bus_id) ORDER BY duration desc;

      -- Show the ID of the passengers who never took a bus line more than once per day.
      SELECT card_id FROM Rides_Passengers group by start_date, card_id having count(*) = 1;

     -- We put the rows with same start_date and card_id togther, then we start counting the rows in each group, we can see all the passengers having one count except passenger 1001
     
	

      -- Show the name of the bus stops that are never used, that is, they are neither the start nor the end stop for any ride.
       select stop_id from Stops where stop_id not in (SELECT distinct on_stop_id FROM Rides UNION SELECT DISTINCT off_stop_id FROM Rides); -- The subquery gets us a list of on_stops_id + off_stop_id, if a stop is not in tha list, then it's a stop that is not being used.
  
    
  -- (3) the statements used to create and apply functions, procedures, triggers, and events (as in section 7)
      -- Implement and explain what they do:
      --  A function that, given two stops, returns how many lines serve both stops.
    DROP FUNCTION IF EXISTS get_lines;
      -- drops the function if it already exists
	DELIMITER //
    -- changes delimeter so you can write a function.
    CREATE FUNCTION get_lines(first_stop INT, second_stop INT) RETURNS INT
    -- declares that get_lines() takes two ints and returns one int
    BEGIN
		DECLARE line_counter INT;
        -- declares the line counter
		SELECT COUNT(*) INTO line_counter
		FROM ( SELECT line_id
		FROM Stops_Line 
		WHERE stop_id in (first_stop,second_stop)
		GROUP BY line_id
		HAVING COUNT(DISTINCT stop_id)=2)
		AS lines_with_both;
        RETURN line_counter;
    END; //
    DELIMITER ;
	SELECT get_lines(104,101);
    -- output:
    -- get_lines(104,101)
    -- 2
    SELECT get_lines(102,103);
    -- output:
    -- get_lines(102,103)
    -- 3
    SELECT get_lines(101,105);
    -- output:
    -- get_lines(101,105)
    -- 0
    

      --  A procedure that, given a line and a stop, adds the stop to that line (after the last stop) if not already served by that line
DROP PROCEDURE IF EXISTS add_stop;
DELIMITER //
CREATE PROCEDURE add_stop(new_line_id INT, new_stop_id INT)
    BEGIN
		DECLARE max_stop_order INT;
        SELECT MAX(stop_order)
        INTO max_stop_order
        FROM Stops_Line
        WHERE line_id=new_line_id;
        
		IF NOT EXISTS (
			SELECT 1
			FROM Stops_Line
			WHERE line_id=new_line_id AND stop_id=new_stop_id
            )THEN
            INSERT INTO Stops_Line(line_id,stop_id,stop_order)
			VALUES (new_line_id, new_stop_id, max_stop_order+1);
	END IF;
    END//
	DELIMITER ;
    CALL add_stop(1,103);
	SELECT * FROM Stops_line;
    -- output:
    -- Original Stop_line
	CALL add_stop(1,104);
	SELECT * FROM Stops_Line;
    -- output:
    -- Stop_lines with
    -- line_id 1
    -- stop_id 104
    -- stop_order 4
    
      --  A trigger that prevents inserting a ride starting and ending at the same stop, or at a stop not served by that line.
    DELIMITER //
	CREATE TRIGGER ride_trigger
      BEFORE INSERT ON Rides
      FOR EACH ROW
      BEGIN
      -- the part of the trigger that prevents getting off on the stop you got on
      IF NEW.on_stop_id=NEW.off_stop_id
      THEN SIGNAL SQLSTATE 'HY000'
			SET MYSQL_ERRNO = 1525,
			MESSAGE_TEXT = 'The end stop is equal to start stop';
      END IF;
      -- The trigger that prevents getting on a stop that is not on the line
      IF NEW.on_stop_id NOT IN 
      (SELECT stop_id FROM Stops_Line
      WHERE line_id=NEW.line_id)
      THEN SIGNAL SQLSTATE 'HY000'
			SET MYSQL_ERRNO = 1525,
			MESSAGE_TEXT = 'The on stop is not on the line';
      END IF;
      -- The trigger preventing getting off on a stop that is not on the line
      IF NEW.off_stop_id NOT IN 
      (SELECT stop_id FROM Stops_Line
      WHERE line_id=NEW.line_id)
      THEN SIGNAL SQLSTATE 'HY000'
			SET MYSQL_ERRNO = 1525,
			MESSAGE_TEXT = 'The end stop is not on the line';
      END IF;
      END//
	DELIMITER ;
    INSERT INTO Rides (start_date,start_time,duration,on_stop_id,off_stop_id,line_id)
    VALUES('2024-11-13','10:00:00',20,101,101,2);
    -- output
    -- Error Code: 1525. The end stop is equal to start stop
    INSERT INTO Rides (start_date,start_time,duration,on_stop_id,off_stop_id,line_id)
    VALUES('2024-11-13','10:00:00',20,104,101,2);
    -- output
    -- Error Code: 1525. The on stop is not on the line
	INSERT INTO Rides (start_date,start_time,duration,on_stop_id,off_stop_id,line_id)
    VALUES('2024-11-13','10:00:00',20,101,104,2);
    -- Error Code: 1525. The end stop is not on the line
    INSERT INTO Rides (start_date,start_time,duration,on_stop_id,off_stop_id,line_id)
    VALUES('2024-11-13','10:00:00',20,101,102,2);
    SELECT * FROM Rides;
    -- output
    -- Same Rides as before but with:
    -- card_id: 1001
    -- ride_id: 5008
    -- start_date: '2024-11-13'
    -- start_time: '10:00:00'
    -- duration: 20
    -- on_stop_id: 101
    -- off_stop_id: 102
    -- line_id: 2
    
	--  Remember also to show illustrative usage examples of how they work.
    --  Example: see section 7 (page 17)
    --  Example: see section 7 (page 17)


-- -- Queries ver 2 -- --

-- view for the displaying the card id of those who got on the first stop. 
DROP VIEW IF EXISTS full_ride_passenger;
create view full_ride_passenger as select distinct card_id from Rides_Passengers, Stops_Line, Rides where Stops_Line.stop_order = 1 AND Rides.on_stop_id = Stops_Line.stop_id;
select * from full_ride_passenger;

-- view for the name of the bus stop served by most lines 
create view popular_stop as select stop_id, count(Stops_Line.stop_id) from Stops_Line group by Stops_Line.stop_id LIMIT 1;
select * from popular_stop;

-- view for each line, the ID of the passenge who took the ride that lasted longer. ie. the max durations for the different lines
 create view longest_ride as select card_id, MAX(duration), line_id from Rides_Passengers, Rides group by line_id; -- it is a shame of SQL that this does not work as expected.
 select * from longest_ride;
create view ordering_by_longest_ride as SELECT * FROM Rides JOIN Rides_Passengers USING (start_date, start_time, bus_id) ORDER BY duration desc;
select * from ordering_by_longest_ride;
 
-- view for the Id of the passengers who never took a bus line more than once per day
DROP VIEW IF EXISTS one_ride_passenger;
create view one_ride_passenger as SELECT card_id FROM Rides_Passengers group by start_date, card_id having count(*) = 1;
select * from one_ride_passenger;

-- view for name of busstop never used (ie. never start nor end stop for any ride)
create view lonely_stop as select stop_id from Stops where stop_id not in (SELECT distinct on_stop_id FROM Rides UNION SELECT DISTINCT off_stop_id FROM Rides);
select * from lonely_stop;


-- !!Views!! Ver.2  --

-- bus lines going through the central point
create view central_bermuda as select line_id from Stops_line where stop_id = "101";
select * from central_bermuda;
-- rides that are under 30 minutes "short ride"
create view short_ride as select * from Rides where duration < 30;
select * from short_ride;
-- rides that are equal + longer than 30 minutes "long rides"
create view long_ride as select * from Rides where duration >= 30;
select * from long_ride;
-- all start and end stops of lines 
DROP VIEW IF EXISTS edge_stops;
create view edge_stops as select stop_id from Stops_Line where stop_order = 1 or stop_order = (select max(stop_order) from Stops_Line group by line_id);
select * from edge_stops;
