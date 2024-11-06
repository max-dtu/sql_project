# Relation Schemas
## busstop
Busstop(stop_id, name, GPS, line_id)
Foreign keys in Busstop: line_id references Busslines
### discusion
## passengers
Passengers(card_id, email, first_name, last_name, country, zip, city, street_name, civic_number, number, ride_id)
Foreign keys in Passengers: number, ride_id
## busslines
Busslines(line_id, name, )
