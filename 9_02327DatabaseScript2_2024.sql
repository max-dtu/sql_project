-- It must contain:
  -- (1) the delete/update statements used to change the tables (as in section 5)
  INSERT INTO Stops (stop_id, stop_name, GPS)
VALUES (107, 'DTU Lyngby Campus', '40.730610,-73.935242');

UPDATE Stops
SET GPS = '40.712776,-74.0060'  -- New GPS coordinates for City Hall
WHERE stop_id = 102;

DELETE FROM Stops WHERE stop_id = 107;

  -- (2) the queries made (as in section 6)
    -- Answer the following questions by writing appropriate SQL table queries:
      -- Show the ID of the passengers who took a ride from the first stop of the line taken.
      select * from Line_Stops;
      select * from Rides, Line_Stops where Line_Stops.stop_order = 1;
      select distinct card_id from Rides, Line_Stops where Line_Stops.stop_order = 1;
      -- Show the name of the bus stop served my most lines.
       select * from Stops;
      select * from Line_Stops;
      select stop_id, count(Line_Stops.stop_id) from Line_Stops group by Line_Stops.stop_id LIMIT 1;
      
      -- For each line, show the ID of the passenger who took the ride that lasted longer.
      select * from Rides;
      select card_id, MAX(duration) from Rides group by line_id;

      -- Show the ID of the passengers who never took a bus line more than once per day.
      select *, COUNT(card_id) from Rides group by start_date;
      SELECT distinct card_id FROM Rides GROUP BY card_id, line_id, start_date HAVING COUNT(ride_id) = 1;

      -- Show the name of the bus stops that are never used, that is, they are neither the start nor the end stop for any ride.
    select stop_id from Stops where stop_id not in (SELECT distinct on_stop_id FROM Rides UNION SELECT DISTINCT off_stop_id FROM Rides);
    
    
  -- (3) the statements used to create and apply functions, procedures, triggers, and events (as in section 7)
      -- Implement and explain what they do:
      --  A function that, given two stops, returns how many lines serve both stops.
      --  A procedure that, given a line and a stop, adds the stop to that line (after the last stop) if not already served by that line.
      --  A trigger that prevents inserting a ride starting and ending at the same stop, or at a stop not served by that line.
      --  Remember also to show illustrative usage examples of how they work.
    --  Example: see section 7 (page 17)
