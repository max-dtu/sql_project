## Report
[Click here](https://docs.google.com/document/d/e/2PACX-1vQAcdszsHldnEmwamwCEGe5D6igwHYDeaI71CSE4t_sJal92BeXnzk5m3u6TO8oOEYFa4odnTOq1SvK)


## 02327DatabaseScript1_2024.sql must contain:
1. the statements used to create the database, its tables and views (as used in section 3 of the report)
2. the statements used to populate the tables (as used in section 4)
   
## id_02327DatabaseScript2_2024.sql must contain:
1. the delete/update statements used to change the tables (as in section 5), and
2. the queries made (as in section 6), and
3. the statements used to create and apply functions, procedures, triggers, and events (as in section 7)

## Requirements (todos):
MoviBus aims at collecting information on the habits of its passengers. In particular, MoviBus needs to know:
- [ ] The ID of the passengers who took a ride from the first stop of the line taken.
- [ ] The name of the bus stop served my most lines.
- [ ] For each line, the ID of the passenger who took the ride that lasted longer.
- [ ] The ID of the passengers who never took a bus line more than once per day.
- [ ] The name of the bus stops that are never used, that is, they are neither the start nor the end stop for any ride.

MoviBus has defined the following requirements for the database:
- [ ] First, it must be possible to register all bus stops. Each stop is characterized by a name and the GPS coordinates. Each stop is served by one or more bus lines.
- [ ] A bus line is characterized by a name, its final destination, and all the bus stops it visits. The order in which each stop is visited by a line (i.e., first stop, second stop, etc.) must be stored.
- [ ] Whenever a passenger takes a bus, the corresponding ride needs to be stored in the database.
- [ ] A passenger is characterized by their ID card number, email address, first name, last name, address (consisting of street name, civic number, city, ZIP code and country), and telephone numbers.
- [ ] A bus ride is characterized by the date and time when it started, the duration in minutes, the passenger who took the ride, the bus line being taken, the stop where the ride started and the stop where it ended.
