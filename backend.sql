CREATE DATABASE IF NOT EXISTS Travel_Reservation_System;
USE Travel_Reservation_System;

CREATE TABLE IF NOT EXISTS `Account` (
	`account_num` int unsigned NOT NULL,
	`first_name` varchar(50) DEFAULT '',
	`last_name` varchar(50) DEFAULT '',
	`username` varchar(20) UNIQUE NOT NULL,
	`password` varchar(20) NOT NULL,
	PRIMARY KEY (`account_num`)
);
CREATE TABLE IF NOT EXISTS `Admin` (
   `account_num` int unsigned NOT NULL,
   PRIMARY KEY (`account_num`),
   FOREIGN KEY (`account_num`) REFERENCES `Account`(`account_num`) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS `Customer_rep` (
   `account_num` int unsigned NOT NULL,
   PRIMARY KEY (`account_num`),
   FOREIGN KEY (`account_num`) REFERENCES `Account`(`account_num`) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS `Customer` (
   `account_num` int unsigned NOT NULL,
   PRIMARY KEY (`account_num`),
   FOREIGN KEY (`account_num`) REFERENCES `Account`(`account_num`)
);

INSERT INTO ACCOUNT(`account_num`, `first_name`, `last_name`, `username`, `password`) VALUES (1, 'AdminFirst', 'AdminLast', 'Admin', 'Admin');
INSERT INTO Admin(`account_num`) VALUES (1);
INSERT INTO ACCOUNT(`account_num`, `first_name`, `last_name`, `username`, `password`) VALUES (2, 'CustomerRepFirst', 'CustomerRepLast', 'CustomerRep', 'CustomerRep');
INSERT INTO Customer_rep(`account_num`) VALUES (2);
INSERT INTO ACCOUNT(`account_num`, `first_name`, `last_name`, `username`, `password`) VALUES (3, 'CustomerFirst', 'CustomerLast', 'c', 'c');
INSERT INTO Customer(`account_num`) VALUES (3);

CREATE TABLE IF NOT EXISTS `Airline` (
	`id` char(2) NOT NULL,
	PRIMARY KEY (`id`)
);

insert into Airline (`id`) values ('AA');
insert into Airline (`id`) values ('UA');

CREATE TABLE IF NOT EXISTS `Owns_aircraft` (
  `aircraft_number` int unsigned NOT NULL,
  `id` char(2) NOT NULL,
  `total_seats` int unsigned DEFAULT 0,
  PRIMARY KEY (`aircraft_number`),
  FOREIGN KEY (`id`) REFERENCES `Airline` (`id`) 
);

insert into Owns_aircraft (aircraft_number, id, total_seats) values (1, 'AA', 100);
insert into Owns_aircraft (aircraft_number, id, total_seats) values (2, 'AA', 200);
insert into Owns_aircraft (aircraft_number, id, total_seats) values (3, 'AA', 150);
insert into Owns_aircraft (aircraft_number, id, total_seats) values (4, 'UA', 6);
insert into Owns_aircraft (aircraft_number, id, total_seats) values (5, 'UA', 200);
insert into Owns_aircraft (aircraft_number, id, total_seats) values (6, 'UA', 150);

CREATE TABLE IF NOT EXISTS `Airport` (
	`id` char(3) NOT NULL,
    PRIMARY KEY (`id`)
);

insert into Airport (id) values ('EWR');
insert into Airport (id) values ('JFK');
insert into Airport (id) values ('LGA');

CREATE TABLE IF NOT EXISTS `Operates_at` (
	`airline_id` char(2) NOT NULL,
    `airport_id` char(3) NOT NULL,
    PRIMARY KEY (`airline_id`, `airport_id`),
    FOREIGN KEY (`airline_id`) REFERENCES `Airline` (`id`),
    FOREIGN KEY (`airport_id`) REFERENCES `Airport` (`id`)
);

insert into Operates_at (airline_id, airport_id) values ('AA', 'EWR');
insert into Operates_at (airline_id, airport_id) values ('AA', 'JFK');
insert into Operates_at (airline_id, airport_id) values ('UA', 'EWR');
insert into Operates_at (airline_id, airport_id) values ('UA', 'JFK');
insert into Operates_at (airline_id, airport_id) values ('UA', 'LGA');

CREATE TABLE IF NOT EXISTS `Flight` (
	`airline_id` char(2) NOT NULL,
    `flight_number` int unsigned NOT NULL,
    `aircraft_number` int unsigned NOT NULL,
    `depart_airport_id` char(3) NOT NULL,
    `destination_airport_id` char(3) NOT NULL,
    `departure_time` time NOT NULL,
    `arrival_time` time NOT NULL,
    `duration` int unsigned NOT NULL,
    `business_fare` float,
    `economy_fare` float,
    `first_class_fare` float,
    `business_seats_available` int unsigned DEFAULT 0,
    `economy_seats_available` int unsigned DEFAULT 0,
    `first_class_seats_available` int unsigned DEFAULT 0,
    PRIMARY KEY (`airline_id`, `flight_number`),
    FOREIGN KEY (`airline_id`) REFERENCES `Airline` (`id`),
    FOREIGN KEY (`aircraft_number`) REFERENCES `Owns_aircraft` (`aircraft_number`),
    FOREIGN KEY (`depart_airport_id`) REFERENCES `Airport` (`id`),
    FOREIGN KEY (`destination_airport_id`) REFERENCES `Airport` (`id`)
);

insert into Flight (airline_id, flight_number, aircraft_number, 
depart_airport_id, destination_airport_id, 
departure_time, arrival_time, duration, 
business_fare, economy_fare, first_class_fare, 
business_seats_available, economy_seats_available, first_class_seats_available) 
values ('AA', 1, 1, 
'JFK', 'EWR', 
'10:00:00', '12:00:00', 2,
100.00, 200.00, 300.00, 
2, 2, 2);

CREATE TABLE IF NOT EXISTS `Operation_days` (
	`airline_id` char(2) NOT NULL,
    `flight_number` int unsigned NOT NULL,
	`day` varchar(20),
    PRIMARY KEY (`airline_id`, `flight_number`, `day`),
    FOREIGN KEY (`airline_id`, `flight_number`) REFERENCES `Flight` (`airline_id`, `flight_number`)
);
CREATE TABLE IF NOT EXISTS `Domestic` (
	`airline_id` char(2) NOT NULL,
    `flight_number` int unsigned NOT NULL,
    PRIMARY KEY (`airline_id`, `flight_number`),
    FOREIGN KEY (`airline_id`, `flight_number`) REFERENCES `Flight` (`airline_id`, `flight_number`)
);
CREATE TABLE IF NOT EXISTS `International` (
	`airline_id` char(2) NOT NULL,
    `flight_number` int unsigned NOT NULL,
    PRIMARY KEY (`airline_id`, `flight_number`),
    FOREIGN KEY (`airline_id`, `flight_number`) REFERENCES `Flight` (`airline_id`, `flight_number`)
);
CREATE TABLE IF NOT EXISTS `Waiting_list` (
	`airline_id` char(2) NOT NULL,
    `flight_number` int unsigned NOT NULL,
    `account_num` int unsigned NOT NULL,
    PRIMARY KEY (`airline_id`, `flight_number`, `account_num`),
    FOREIGN KEY (`airline_id`, `flight_number`) REFERENCES `Flight` (`airline_id`, `flight_number`),
    FOREIGN KEY (`account_num`) REFERENCES `Customer` (`account_num`)
);
CREATE TABLE IF NOT EXISTS `Reserve_ticket` (
	`ticket_number` int unsigned NOT NULL,
    `account_num` int unsigned NOT NULL,
    `class` varchar(20),
    `purchase_time` datetime,
    `total_fare` float,
    `booking_fee` float,
    PRIMARY KEY (`ticket_number`),
	FOREIGN KEY (`account_num`) REFERENCES `Customer` (`account_num`)
);
CREATE TABLE IF NOT EXISTS `Portfolio` (
	`ticket_number` int unsigned NOT NULL,
    `account_num` int unsigned,
    PRIMARY KEY (`ticket_number`),
    FOREIGN KEY (`ticket_number`) REFERENCES `Reserve_ticket` (`ticket_number`),
    FOREIGN KEY (`account_num`) REFERENCES `Customer` (`account_num`)
);
CREATE TABLE IF NOT EXISTS `Includes` (
	`airline_id` char(2) NOT NULL,
    `flight_number` int unsigned NOT NULL,
    `ticket_number` int unsigned NOT NULL,
    `departure_time` datetime,
    `seat_number` int unsigned,
    FOREIGN KEY (`airline_id`, `flight_number`) REFERENCES `Flight` (`airline_id`, `flight_number`),
    FOREIGN KEY (`ticket_number`) REFERENCES `Reserve_ticket` (`ticket_number`)
);
CREATE TABLE IF NOT EXISTS `One_way` (
	`ticket_number` int unsigned NOT NULL,
    PRIMARY KEY (`ticket_number`),
	FOREIGN KEY (`ticket_number`) REFERENCES `Reserve_ticket` (`ticket_number`)
);
CREATE TABLE IF NOT EXISTS `Round_trip` (
	`ticket_number` int unsigned NOT NULL,
    PRIMARY KEY (`ticket_number`),
	FOREIGN KEY (`ticket_number`) REFERENCES `Reserve_ticket` (`ticket_number`)
);

CREATE TABLE IF NOT EXISTS `Question` (
	`question_text` varchar(255),
    PRIMARY KEY (`question_text`)
);

CREATE TABLE IF NOT EXISTS `Answer` (
	`question_text` varchar(255) NOT NULL,
    `answer_text` varchar(255) NOT NULL,
    PRIMARY KEY (`question_text`, `answer_text`),
    FOREIGN KEY (`question_text`) REFERENCES `Question`(`question_text`)
);

insert into Question(question_text) values ("How do I book a flight?");
insert into Answer(question_text, answer_text) values ("How do I book a flight?", "Go to the Flights tab");
insert into Question(question_text) values ("How much is a ticket?");
insert into Answer(question_text, answer_text) values ("How much is a ticket?", "Depends on the flight but ranges from $100-$1000");
insert into Question(question_text) values ('Is there a plane to my location?');