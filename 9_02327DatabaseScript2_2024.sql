-- It must contain:
  -- (1) the delete/update statements used to change the tables (as in section 5)
  INSERT INTO Stops (stop_id, stop_name, GPS)
VALUES (107, 'DTU Lyngby Campus', '55.7849149,12.5219711');

INSERT INTO Stops (stop_id, stop_name, GPS) VALUES
(108, 'Rest stop 1', '35.2616383,-47.23901445'),
(109, 'Rest stop 2', '45.5232766,-23.4780289'),
(110, 'Klampenborgvej', '55.774613630806115, 12.524482144716382');

select * from Stops;
-- reslut after adding the above row:
	-- stop_id stop_name 	GPS
	-- '101', 'Central Station', '40.748817,-73.985428'
	-- '102', 'City Hall', '40.712776,-74.005974'
	-- '103', 'Museum of Art', '40.779437,-73.963244'
	-- '104', 'University Campus', '40.730610,-73.935242'
	-- '105', 'Park Avenue', '40.754932,-73.984016'
	-- '106', 'DStop', '40.754932,-73.984019'
	-- '107', 'DTU Lyngby Campus', '40.730610,-73.935242'

UPDATE Stops
SET GPS = '55.7849149,12.5219711'  -- New GPS coordinates for City Hall
WHERE stop_id = 102;

select * from Stops;
-- reslut after executing the above UPDATE command:
	-- stop_id stop_name 	GPS
	-- '102', 'City Hall', '40.712776,-74.0060'


DELETE FROM Stops WHERE stop_id = 107;

select * from Stops;
-- reslut after executing the above DELETE command:
	-- stop_id stop_name 	GPS
	-- '101', 'Central Station', '40.748817,-73.985428'
	-- '102', 'City Hall', '40.712776,-74.005974'
	-- '103', 'Museum of Art', '40.779437,-73.963244'
	-- '104', 'University Campus', '40.730610,-73.935242'
	-- '105', 'Park Avenue', '40.754932,-73.984016'
	-- '106', 'DStop', '40.754932,-73.984019'

  -- (2) the queries made (as in section 6)
    -- Answer the following questions by writing appropriate SQL table queries:
      -- Show the ID of the passengers who took a ride from the first stop of the line taken.
      select * from Stops_Line;
      select * from Rides, Stops_Line where Stops_Line.stop_order = 1;
      select distinct card_id from Rides, Stops_Line where Stops_Line.stop_order = 1;
		-- output:
        -- card_id
        -- 1001
        -- 1002
        -- 1003
        -- 1004
        -- 1005
      -- Show the name of the bus stop served my most lines.
       select * from Stops;
      select * from Stops_Line;
      select stop_id, count(Stops_Line.stop_id) from Stops_Line group by Stops_Line.stop_id LIMIT 1;
      -- output:
      -- stop_id
      -- 101
      
      -- For each line, show the ID of the passenger who took the ride that lasted longer.
      select * from Rides;
      select card_id, MAX(duration), line_id from Rides group by line_id;
      -- output:
      -- card_id MAX(duration) line_id
      -- 1001 40 1
      -- 1004 30 2
      -- 1003 30 3

      -- Show the ID of the passengers who never took a bus line more than once per day.
      select *, COUNT(card_id) from Rides group by start_date;
      SELECT distinct card_id FROM Rides GROUP BY card_id, line_id, start_date HAVING COUNT(ride_id) = 1;
      -- output:
      -- card_id
      -- 1001
      -- 1002
      -- 1003
      -- 1005
     
	

      -- Show the name of the bus stops that are never used, that is, they are neither the start nor the end stop for any ride.
    select stop_id from Stops where stop_id not in (SELECT distinct on_stop_id FROM Rides UNION SELECT DISTINCT off_stop_id FROM Rides);
    -- output:
    -- stop_id
    -- 105
    -- 106
    
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
    -- 3

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
	CALL add_stop(1,104);
	SELECT * FROM Stops_line;
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
    INSERT INTO Rides (card_id, ride_id,start_date,start_time,duration,on_stop_id,off_stop_id,line_id)
    VALUES(1001,5008,'2024-11-13','10:00:00',20,101,101,2);
    -- output
    -- Error Code: 1525. The end stop is equal to start stop
    INSERT INTO Rides (card_id, ride_id,start_date,start_time,duration,on_stop_id,off_stop_id,line_id)
    VALUES(1001,5008,'2024-11-13','10:00:00',20,104,101,2);
    -- output
    -- Error Code: 1525. The on stop is not on the line
	INSERT INTO Rides (card_id, ride_id,start_date,start_time,duration,on_stop_id,off_stop_id,line_id)
    VALUES(1001,5008,'2024-11-13','10:00:00',20,101,104,2);
    -- Error Code: 1525. The end stop is not on the line
    INSERT INTO Rides (card_id, ride_id,start_date,start_time,duration,on_stop_id,off_stop_id,line_id)
    VALUES(1001,5008,'2024-11-13','10:00:00',20,101,102,2);
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
