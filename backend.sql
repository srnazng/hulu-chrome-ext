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
CREATE TABLE IF NOT EXISTS `Airline` (
	`id` int unsigned NOT NULL,
	PRIMARY KEY (`id`)
);
CREATE TABLE IF NOT EXISTS `Owns_aircraft` (
  `aircraft_number` int unsigned NOT NULL,
  `id` int unsigned NOT NULL,
  `total_seats` int unsigned DEFAULT 0,
  PRIMARY KEY (`aircraft_number`),
  FOREIGN KEY (`id`) REFERENCES `Airline` (`id`) 
);
CREATE TABLE IF NOT EXISTS `Airport` (
	`id` int unsigned NOT NULL,
    PRIMARY KEY (`id`)
);
CREATE TABLE IF NOT EXISTS `Operates_at` (
	`airline_id` int unsigned NOT NULL,
    `airport_id` int unsigned NOT NULL,
    PRIMARY KEY (`airline_id`, `airport_id`),
    FOREIGN KEY (`airline_id`) REFERENCES `Airline` (`id`),
    FOREIGN KEY (`airport_id`) REFERENCES `Airport` (`id`)
);
CREATE TABLE IF NOT EXISTS `Flight` (
	`airline_id` int unsigned NOT NULL,
    `flight_number` int unsigned NOT NULL,
    `aircraft_number` int unsigned NOT NULL,
    `depart_airport_id` int unsigned NOT NULL,
    `destination_airport_id` int unsigned NOT NULL,
    `departure_time` time NOT NULL,
    `arrival_time` time NOT NULL,
    `duration` int unsigned NOT NULL,
    `business_fare` float,
    `economy_fare` float,
    `first_class_fare` float,
    `seats_available` float DEFAULT 0,
    PRIMARY KEY (`airline_id`, `flight_number`),
    FOREIGN KEY (`airline_id`) REFERENCES `Airline` (`id`),
    FOREIGN KEY (`aircraft_number`) REFERENCES `Owns_aircraft` (`aircraft_number`),
    FOREIGN KEY (`depart_airport_id`) REFERENCES `Airport` (`id`),
    FOREIGN KEY (`destination_airport_id`) REFERENCES `Airport` (`id`)
);
CREATE TABLE IF NOT EXISTS `Operation_days` (
	`airline_id` int unsigned NOT NULL,
    `flight_number` int unsigned NOT NULL,
	`day` varchar(20),
    PRIMARY KEY (`airline_id`, `flight_number`, `day`),
    FOREIGN KEY (`airline_id`, `flight_number`) REFERENCES `Flight` (`airline_id`, `flight_number`)
);
CREATE TABLE IF NOT EXISTS `Domestic` (
	`airline_id` int unsigned NOT NULL,
    `flight_number` int unsigned NOT NULL,
    PRIMARY KEY (`airline_id`, `flight_number`),
    FOREIGN KEY (`airline_id`, `flight_number`) REFERENCES `Flight` (`airline_id`, `flight_number`)
);
CREATE TABLE IF NOT EXISTS `International` (
	`airline_id` int unsigned NOT NULL,
    `flight_number` int unsigned NOT NULL,
    PRIMARY KEY (`airline_id`, `flight_number`),
    FOREIGN KEY (`airline_id`, `flight_number`) REFERENCES `Flight` (`airline_id`, `flight_number`)
);
CREATE TABLE IF NOT EXISTS `Waiting_list` (
	`airline_id` int unsigned NOT NULL,
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
	`airline_id` int unsigned NOT NULL,
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

INSERT INTO ACCOUNT(`account_num`, `first_name`, `last_name`, `username`, `password`) VALUES (1, 'AdminFirst', 'AdminLast', 'Admin', 'Admin');
INSERT INTO Admin(`account_num`) VALUES (1);

INSERT INTO ACCOUNT(`account_num`, `first_name`, `last_name`, `username`, `password`) VALUES (2, 'CustomerRepFirst', 'CustomerRepLast', 'CustomerRep', 'CustomerRep');
INSERT INTO Customer_rep(`account_num`) VALUES (2);