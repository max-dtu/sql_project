-- It must contain:
  -- (1) the delete/update statements used to change the tables (as in section 5)
  INSERT INTO Stops (stop_id, stop_name, GPS)
VALUES (107, 'DTU Lyngby Campus', '40.730610,-73.935242');

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
SET GPS = '40.712776,-74.0060'  -- New GPS coordinates for City Hall
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
      --  A procedure that, given a line and a stop, adds the stop to that line (after the last stop) if not already served by that line.
      --  A trigger that prevents inserting a ride starting and ending at the same stop, or at a stop not served by that line.
      --  Remember also to show illustrative usage examples of how they work.
    --  Example: see section 7 (page 17)
