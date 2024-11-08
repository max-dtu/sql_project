-- It must contain:
  -- (1) the delete/update statements used to change the tables (as in section 5)

  -- (2) the queries made (as in section 6)
    -- Answer the following questions by writing appropriate SQL table queries:
      -- Show the ID of the passengers who took a ride from the first stop of the line taken.
      -- Show the name of the bus stop served my most lines.
      -- For each line, show the ID of the passenger who took the ride that lasted longer.
      -- Show the ID of the passengers who never took a bus line more than once per day.
      -- Show the name of the bus stops that are never used, that is, they are neither the start nor the end stop for any ride.
    
  -- (3) the statements used to create and apply functions, procedures, triggers, and events (as in section 7)
      -- Implement and explain what they do:
      --  A function that, given two stops, returns how many lines serve both stops.
      --  A procedure that, given a line and a stop, adds the stop to that line (after the last stop) if not already served by that line.
      --  A trigger that prevents inserting a ride starting and ending at the same stop, or at a stop not served by that line.
      --  Remember also to show illustrative usage examples of how they work.
    --  Example: see section 7 (page 17)
