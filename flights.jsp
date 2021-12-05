<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Travel Reservation System</title>
	</head>
	
	<body>
	Flights
	<br>
	<form method="post" action="flightsMain.jsp">
			<table>
				<tr>
				   <th>Flight Info</th>
				   <th></th>
				   <th>Filter By</th>
				   <th></th>
				   <th>Sort By</th>
				 </tr>
				<tr>    
					<td>Departure Airport</td><td><input type="text" name="departure"></td>
					<td>Maximum Price</td><td><input type="text" name="maxPrice"></td>
					<td><input type="radio" name="sortType" value="Default"/ checked>Default</td>
				</tr>
				<tr>
					<td>Destination Airport</td><td><input type="text" name="destination"></td>
					<td>Maximum Stops</td><td><input type="text" name="maxStops"></td>
					<td><input type="radio" name="sortType" value="price"/>Price</td>
				</tr>
				<tr>
					<td>Round Trip</td><td><input type="checkbox" name="roundTrip"></td>
					<td>Airline</td><td><input type="text" name="airline"></td>
					<td><input type="radio" name="sortType" value="takeoff"/>Takeoff Time</td>
				</tr>
				<tr>
					<td>Flexible Date </td><td><input type="checkbox" name="flexibleDate"></td>
					<td>Earliest Takeoff (HH:SS)</td><td><input type="time" name="earliestTakeoff"></td>
					<td><input type="radio" name="sortType" value="arrival"/>Arrival Time</td>
				</tr>
				<tr>
					<td>Departure Date (YYYY-MM-DD)</td><td><input type="date" name="departDate"></td>
					<td>Latest Takeoff (HH:SS)</td><td><input type="time" name="latestTakeoff"></td>
					<td><input type="radio" name="sortType" value="duration"/>Flight Duration</td>
				</tr>
				<tr>
					<td>Return Date (YYYY-MM-DD)</td><td><input type="date" name="returnDate"></td>
					<td>Earliest Arrival (HH:SS)</td><td><input type="time" name="earliestArrival"></td>
					<td>Sort lowest first <input type="checkbox" name="lowFirst"></td>
				</tr>
				<tr>
					<td><input type="radio" name="classType" value="firstClass" checked/>First Class</td>
					<td><input type="radio" name="classType" value="business"/>Business</td>
					<td>Latest Arrival (HH:SS)</td><td><input type="time" name="latestArrival"></td>
				</tr>
				<tr>
					<td><input type="radio" name="classType" value="economy"/>Economy</td>
				</tr>
				
			</table>
			<br>
			<input type="submit" value="Find Flights!">
		</form>
	
	<form action="customerDashboard.jsp">
		<input type="submit" value="Home">
	</form>
	<form action="../main.jsp">
		<input type="submit" value="Log out">
	</form>
</body>
</html>