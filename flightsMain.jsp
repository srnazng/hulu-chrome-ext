<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.time.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Travel Reservation System</title>
	</head>
	<body>
	<%!
	
	public class Flight{
		String d;
		String a;
		String n;
		String dep;
		String des;
		String dept;
		String arrt;
		int bf;
		int ef;
		int ff;
		boolean ret;
		
		public Flight(String day, String airline, String number, String departure, String destination, String deptime, String arrtime,
				int bfare, int efare, int ffare, boolean isReturn){
			d = day;
			a = airline;
			n = number;
			dep = departure;
			des = destination;
			dept = deptime;
			arrt = arrtime;
			bf = bfare;
			ef = efare;
			ff = ffare;
			ret = isReturn;
			
		}
		
	}
	
	public class compareFirstPrice implements Comparator<ArrayList<Flight>> {
	    @Override
	    public int compare(ArrayList<Flight> path1, ArrayList<Flight> path2) {
	        int tot1 = 0;
	        int tot2 = 0;
	        for (Flight f : path1) tot1 += f.ff;
	        
	        for (Flight f : path2) tot2 += f.ff;
	        
	        if (tot1 < tot2) return -1;
	        else if (tot1 > tot2) return 1;
	        return 0;
	    }
	}
	
	public class compareBusinessPrice implements Comparator<ArrayList<Flight>> {
	    @Override
	    public int compare(ArrayList<Flight> path1, ArrayList<Flight> path2) {
	        int tot1 = 0;
	        int tot2 = 0;
	        for (Flight f : path1) tot1 += f.bf;
	        
	        for (Flight f : path2) tot2 += f.bf;
	        
	        if (tot1 < tot2) return -1;
	        else if (tot1 > tot2) return 1;
	        return 0;
	    }
	}
	
	public class compareEconomyPrice implements Comparator<ArrayList<Flight>> {
	    @Override
	    public int compare(ArrayList<Flight> path1, ArrayList<Flight> path2) {
	        int tot1 = 0;
	        int tot2 = 0;
	        for (Flight f : path1) tot1 += f.ef;
	        
	        for (Flight f : path2) tot2 += f.ef;
	        
	        if (tot1 < tot2) return -1;
	        else if (tot1 > tot2) return 1;
	        return 0;
	    }
	}
	
	public class compareDepartureTime implements Comparator<ArrayList<Flight>> {
	    @Override
	    public int compare(ArrayList<Flight> path1, ArrayList<Flight> path2) {
	        int leave1 = getSeconds(path1.get(0).dept);
	        int leave2 = getSeconds(path2.get(0).dept);
	        
	        if (leave1 < leave2) return -1;
	        else if (leave1 > leave2) return 1;
	        return 0;
	    }
	}
	
	public class compareArrivalTime implements Comparator<ArrayList<Flight>> {
	    @Override
	    public int compare(ArrayList<Flight> path1, ArrayList<Flight> path2) {
	        int leave1 = getSeconds(path1.get(path1.size() - 1).dept);
	        int leave2 = getSeconds(path2.get(path2.size() - 1).dept);
	        
	        if (leave1 < leave2) return -1;
	        else if (leave1 > leave2) return 1;
	        return 0;
	    }
	}
	
	public class compareDurationOne implements Comparator<ArrayList<Flight>> {
	    @Override
	    public int compare(ArrayList<Flight> path1, ArrayList<Flight> path2) {
	        int leave1 = getSeconds(path1.get(path1.size() - 1).arrt) - getSeconds(path1.get(0).dept);
	        int leave2 = getSeconds(path2.get(path2.size() - 1).arrt) - getSeconds(path2.get(0).dept);
	        
	        if (leave1 < leave2) return -1;
	        else if (leave1 > leave2) return 1;
	        return 0;
	    }
	}
	
	 public int getTurn(ArrayList<Flight> path1){
	 	for (int i = 0; i < path1.size(); i++){
	 		if (path1.get(i).ret) return i;
	 	}
	 	return 0;
	   }
	
	public class compareDurationRound implements Comparator<ArrayList<Flight>> {
	    @Override
	 
	    public int compare(ArrayList<Flight> path1, ArrayList<Flight> path2) {
	    	int turn1 = getTurn(path1);
	    	
	    	int leave1 = getSeconds(path1.get(turn1 - 1).arrt) - getSeconds(path1.get(0).dept)
	    			+ getSeconds(path1.get(path1.size() - 1).arrt) - getSeconds(path1.get(turn1).dept);
	    	
	    	int turn2 = getTurn(path2);
	    	int leave2 = getSeconds(path2.get(turn2 - 1).arrt) - getSeconds(path2.get(0).dept)
	    			+ getSeconds(path2.get(path2.size() - 1).arrt) - getSeconds(path2.get(turn2).dept);
	        
	        if (leave1 < leave2) return -1;
	        else if (leave1 > leave2) return 1;
	        return 0;
	    }
	}
	
	//Utility functions
	public String getDay(String date){
		LocalDate localDate = LocalDate.parse(date);
	    DayOfWeek dayOfWeek = DayOfWeek.from(localDate);
	    return dayOfWeek.name();
	}
	
	public int getSeconds(String inTime){
		LocalTime time = LocalTime.parse(inTime);
		return 3600 * time.getHour() + 60 * time.getMinute() + time.getSecond();
	}
	
	public LocalDate getDate(String weekDay, String date){
		String upperWeekDay = weekDay.toUpperCase();
		LocalDate localDate = LocalDate.parse(date);
	    DayOfWeek day = DayOfWeek.from(localDate);
	    
		
		String[] days = {"MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"};
		
		int flight = 0, user = 0;
		
		for (int i = 0; i < 7; i++){
			if (upperWeekDay.equals(days[i])) flight = i;
			if (day.name().equals(days[i])) user = i;
		}
		
		
		LocalDate returnDate;
		//After flight date after user date
		if (((flight + 7) - user) % 7 <= 3){
			returnDate = localDate.plusDays(((flight + 7) - user) % 7);
		}
		else returnDate = localDate.minusDays(((user + 7) - flight) % 7);
		
		return returnDate;
	}
	
	//Helper to get all paths from departure to destination
	public void helper(HashMap<String, ArrayList<Flight>> adj , ArrayList<ArrayList<Flight>> paths, 
			ArrayList<Flight> path, String current, String departure, String destination, int num){
		
		
		if (current.equals(destination)){
			paths.add((ArrayList<Flight>) path.clone());
			return;
		}
		if (num == 3) return;
		
		if (adj.get(current) == null){
			//System.out.println("null adj");
			return;
		}
		for (Flight f : adj.get(current)){
			if (!f.des.equals(departure)){
				path.add(f);
				helper(adj, paths, path, f.des, departure, destination, num + 1);
				path.remove(path.size() - 1);
			}
		}
		
		
	}
	
	//Get all flight paths with <= 2 stops starting from departure, ending at destination
			
	public ArrayList<ArrayList<Flight>> getPaths(String departure, String destination, boolean isReturn, Connection con){
		try{
			Statement stmt = con.createStatement();
			
			//Create Adjacency list
			HashMap<String, ArrayList<Flight>> adj = new HashMap<String, ArrayList<Flight>>();
			String query = "Select * from airport";
			ResultSet airports = stmt.executeQuery(query);
			
			while(airports.next()){
				String airport = airports.getString("id");
				query = "Select * from operation_days join flight using(flight_number, airline_id)"
						 + " where depart_airport_id = \"" + airport + "\"";
				
				Statement stmt2 = con.createStatement();
				ResultSet flights = stmt2.executeQuery(query);
				ArrayList<Flight> edges = new ArrayList<Flight>();
				while(flights.next()){
					String day = flights.getString("day");
					String airline = flights.getString("airline_id");
					String number = flights.getString("flight_number");
					String dest = flights.getString("destination_airport_id");
					String deptime = flights.getString("departure_time");
					String arrtime = flights.getString("arrival_time");
					int bfare = Integer.parseInt(flights.getString("business_fare"));
					int ffare = Integer.parseInt(flights.getString("first_class_fare"));
					int efare = Integer.parseInt(flights.getString("economy_fare"));
					
					Flight f = new Flight(day, airline, number, airport, dest, deptime, arrtime, bfare, ffare, efare, isReturn);
					
					edges.add(f);
				}
				
				adj.put(airport, edges);
			}
			
			//Test adjacency List
			/* for (Map.Entry<String, ArrayList<Flight>> set : adj.entrySet()) {
			    System.out.println(set.getKey() + " = ");
			    for (Flight f : set.getValue()){
			    	System.out.println(f.a + " " + f.n + " " + f.dep + " " + f.des);
			    }
			} */
			
			//Get all paths with helper
			ArrayList<ArrayList<Flight>> paths = new ArrayList<ArrayList<Flight>>();
			ArrayList<Flight> path = new ArrayList<Flight> ();
			
			helper(adj, paths, path, departure.toUpperCase(), departure.toUpperCase(), destination.toUpperCase(), 0);
			
			//Test paths
			/* for (ArrayList<Flight> p : paths) {
				System.out.println("possible path:");
			    for (Flight f : p){
			    	System.out.println(f.d + " " + f.a + " " + f.n + " " + f.dep + " " + f.des);
			    }
			} */
			
			
			return paths;
		}
		
		catch (Exception e){
			System.out.println(e);
			ArrayList<ArrayList<Flight>> paths = new ArrayList<ArrayList<Flight>>();
			return paths;
			
		}
		
	}
	
	//Filter one way paths with user filters
	public ArrayList<ArrayList<Flight>> filterOneWay(ArrayList<ArrayList<Flight>> paths, String date, String flexibleDate, String classType,
			String maxPrice, String maxStops, String airline, String earliestTakeoff, String latestTakeoff, String earliestArrival, 
			String latestArrival, Connection con){
		
		try{
			//prepare filters
			
			String day = getDay(date);
			boolean flexible = (flexibleDate != null);
			
			ArrayList<ArrayList<Flight>> Filtered = new ArrayList<ArrayList<Flight>> ();
			
			for (ArrayList<Flight> path : paths){
				boolean ok = true;
			
				ArrayList<Integer> departures = new ArrayList<Integer>();
				ArrayList<Integer> arrivals = new ArrayList<Integer>();
				ArrayList<String> airlines = new ArrayList<String>();
				ArrayList<String> days = new ArrayList<String>();
				int totPrice = 0;
				
				for (Flight f : path){
					
					departures.add(getSeconds(f.dept));
					arrivals.add(getSeconds(f.arrt));
					airlines.add(f.a);
					days.add(f.d);
					
					if (classType.equals("firstClass")) totPrice += f.ff;
					else if (classType.equals("business")) totPrice += f.bf;
					else totPrice += f.ef;
				}
				
				//day filter, need user day and/or also same day among all
				String theDay;
				if (flexible){
					theDay = days.get(0).toUpperCase();
				}
				else theDay = day;
				
	
				for (String d : days){
					if (!d.toUpperCase().equals(theDay)) ok = false;
				}
				
				//Stops filter
				if (!maxStops.isEmpty()){
					int mStops = Integer.parseInt(maxStops);
					if (path.size() - 1 > mStops) ok = false;
				}
				//price filter
				if (!maxPrice.isEmpty()){
					int mPrice = Integer.parseInt(maxPrice);
					if (totPrice >= mPrice) ok = false;
				}
				
				//airline filter
				if (!airline.isEmpty()){
					airline = airline.toUpperCase();
					for (String a : airlines){
						if (!a.equals(airline)) ok = false;
					}
				}
				
				//Takeoff filter - connecting flights must have compatible times
				for (int i = 0; i < arrivals.size() - 1; i++){
					if (arrivals.get(i) > departures.get(i + 1)) ok = false;
				}
				
				//Early takeoff filter
				if (!earliestTakeoff.isEmpty()){
					int eTakeoff = getSeconds(earliestTakeoff);
					if (departures.get(0) < eTakeoff) ok = false;
				}
				
				//Late takeoff filter
				if (!latestTakeoff.isEmpty()){
					int lTakeoff = getSeconds(latestTakeoff);
					
					if (departures.get(0) > lTakeoff) ok = false;
				}
				
				//Early arrival filter
				if (!earliestArrival.isEmpty()) {
					int eArrival = getSeconds(earliestArrival);
					if (arrivals.get(arrivals.size() - 1) < eArrival) ok = false;
				}
				if (!latestArrival.isEmpty()){
					int lArrival = getSeconds(latestArrival);
					if (arrivals.get(arrivals.size() - 1) > lArrival) ok = false;
				}
				if (ok) Filtered.add(path);
			}
			
			//test filter
			/* for (ArrayList<Flight> p : Filtered) {
					System.out.println("Filtered Path:");
				    for (Flight f : p){
				    	System.out.println(f.d + " " + f.a + " " + f.n + " " + f.dep + " " + f.des);
				    }
			} */
		
			
			return Filtered;
		}
		
		catch(Exception e){
			System.out.println(e);
			ArrayList<ArrayList<Flight>> Filtered = new ArrayList<ArrayList<Flight>>();
			return Filtered;
		}
		
		
	}
	
	//Filter two way paths with user filters
	public ArrayList<ArrayList<Flight>> filterTwoWay(ArrayList<ArrayList<Flight>> toPaths, ArrayList<ArrayList<Flight>> fromPaths, 
			String date, String returnDate, String classType, String maxPrice, String maxStops, Connection con){
		try{
			ArrayList<ArrayList<Flight>> Filtered = new ArrayList<ArrayList<Flight>>();
			
			for (ArrayList<Flight> toPath : toPaths){
				for (ArrayList<Flight> fromPath : fromPaths){
					//Filter by relative date
					LocalDate toDate = getDate(toPath.get(0).d, date);
					LocalDate fromDate = getDate(fromPath.get(0).d, returnDate);

					if (fromDate.isBefore(toDate)){
						//System.out.println("earlier");
						continue;
					}
					if (fromDate.isEqual(toDate)){
						int toArrival = getSeconds(toPath.get(toPath.size()- 1).arrt);
						int fromDeparture = getSeconds(fromPath.get(fromPath.size() - 1).dept);
						if (toArrival > fromDeparture) continue;
					}
					
					//filter by stops
					if (toPath.size() + fromPath.size() - 2 > 2) continue;
					if (!maxStops.isEmpty()){
						if (toPath.size() + fromPath.size() - 2 > Integer.parseInt(maxStops));
					}
					
					//Filter by price
					if (!maxPrice.isEmpty()){
						int totPrice = 0;
						for (Flight f : toPath){
							if (classType.equals("firstClass")) totPrice += f.ff;
							else if (classType.equals("business")) totPrice += f.bf;
							else totPrice += f.ef;
						}
						for (Flight f : fromPath){
							if (classType.equals("firstClass")) totPrice += f.ff;
							else if (classType.equals("business")) totPrice += f.bf;
							else totPrice += f.ef;
						}
						
						if (totPrice > Integer.parseInt(maxPrice)) continue;
					}
					
					ArrayList<Flight> copy = (ArrayList<Flight>) toPath.clone();
					copy.addAll(fromPath);
					Filtered.add(copy);
					
					
				}
			}
			
			//Test double filter
			/* for (ArrayList<Flight> p : Filtered) {
				System.out.println("Double Filtered Path:");
			    for (Flight f : p){
			    	System.out.println(f.d + " " + f.a + " " + f.n + " " + f.dep + " " + f.des + " " + f.ret);
			    }
			} */
			
			return Filtered;
		}
		catch(Exception e){
			System.out.println(e);
			ArrayList<ArrayList<Flight>> filtered = new ArrayList<ArrayList<Flight>>();
			return filtered;
		}
	}
	
	public void sort(ArrayList<ArrayList<Flight>> filtered, String sortType, String lowFirst, String classType, boolean isRound){
		
		if (sortType.equals("price")){
			if (classType.equals("firstClass")){
				Collections.sort(filtered, new compareFirstPrice());
			}
			else if (classType.equals("business")){
				Collections.sort(filtered, new compareBusinessPrice());
			}
			else {
				Collections.sort(filtered, new compareEconomyPrice());
			}
		}
		else if (sortType.equals("takeoff")){
			Collections.sort(filtered, new compareDepartureTime());
		}
		else if (sortType.equals("arrival")){
			Collections.sort(filtered, new compareArrivalTime());
		}
			
		else if (sortType.equals("duration")){
			if (isRound){
				Collections.sort(filtered, new compareDurationRound());
			}
			else Collections.sort(filtered, new compareDurationOne());
		}
		if (lowFirst == null){
			Collections.reverse(filtered);
		}
	}
	
	
%>
	Flights
	
	<%
	try{
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		
		String departure = request.getParameter("departure").toUpperCase();
		String destination = request.getParameter("destination").toUpperCase();
		String roundTrip = request.getParameter("roundTrip");
		String flexibleDate = request.getParameter("flexibleDate");
		String departDate = request.getParameter("departDate");
		String returnDate = request.getParameter("returnDate");
		
		String maxPrice = request.getParameter("maxPrice");
		String maxStops = request.getParameter("maxStops");
		String airline = request.getParameter("airline");
		String earliestTakeoff = request.getParameter("earliestTakeoff");
		String latestTakeoff = request.getParameter("latestTakeoff");
		String earliestArrival = request.getParameter("earliestArrival");
		String latestArrival = request.getParameter("latestArrival");
		
		String sortType = request.getParameter("sortType");
		String lowFirst = request.getParameter("lowFirst");
		
		
		String classType = request.getParameter("classType");
		//out.println(classType);
		

	%>
	

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
					<td>Departure Airport</td><td><input type="text" name="departure" value=<%=departure%>></td>
					<td>Maximum Price</td><td><input type="text" name="maxPrice" value=<%=maxPrice%>></td>
					<td><input type="radio" name="sortType" value="Default" <%if(sortType.equals("Default")){%>checked<%}%>>Default</td>
				</tr>
				<tr>
					<td>Destination Airport</td><td><input type="text" name="destination" value=<%=destination%>></td>
					<td>Maximum Stops</td><td><input type="text" name="maxStops" value=<%=maxStops%>></td>
					<td><input type="radio" name="sortType" value="price" <%if(sortType.equals("price")){%>checked<%}%>/>Price</td>
				</tr>
				<tr>
					<td>Round Trip</td><td><input type="checkbox" name="roundTrip" <%if(roundTrip != null){%>checked<%}%>></td>
					<td>Airline</td><td><input type="text" name="airline" value=<%=airline%>></td>
					<td><input type="radio" name="sortType" value="takeoff" <%if(sortType.equals("takeoff")){%>checked<%}%>/>Takeoff Time</td>
				</tr>
				<tr>
					<td>Flexible Date</td><td><input type="checkbox" name="flexibleDate" <%if(flexibleDate != null){%>checked<%}%>></td>
					<td>Earliest Takeoff</td><td><input type="time" name="earliestTakeoff" value=<%=earliestTakeoff%>></td>
					<td><input type="radio" name="sortType" value="arrival" <%if(sortType.equals("arrival")){%>checked<%}%>/>Arrival Time</td>
				</tr>
				<tr>
					<td>Departure Date</td><td><input type="date" name="departDate" value=<%=departDate%>></td>
					<td>Latest Takeoff</td><td><input type="time" name="latestTakeoff" value=<%=latestTakeoff%>></td>
					<td><input type="radio" name="sortType" value="duration" <%if(sortType.equals("duration")){%>checked<%}%>/>Flight Duration</td>
				</tr>
				<tr>
					<td>Return Date</td><td><input type="date" name="returnDate" value=<%=returnDate%>></td>
					<td>Earliest Arrival</td><td><input type="time" name="earliestArrival" value=<%=earliestArrival%>></td>
					<td>Sort lowest first <input type="checkbox" name="lowFirst" <%if(lowFirst != null){%>checked<%}%>></td>
				</tr>
				<tr>
					<td><input type="radio" name="classType" value="firstClass" <%if(classType.equals("firstClass")){%>checked<%}%>/>First Class</td>
					<td><input type="radio" name="classType" value="business" <%if(classType.equals("business")){%>checked<%}%>/>Business</td>
					<td>Latest Arrival</td><td><input type="time" name="latestArrival" value=<%=latestArrival%>></td>
				</tr>
				<tr>
					<td><input type="radio" name="classType" value="economy" <%if(classType.equals("economy")){%>checked<%}%>/>Economy</td>
					<td></td>
					<td></td>
				</tr>
				
			</table>
			<br>
			<input type="submit" value="Find Flights!">
		</form>
		<%
		if (departure.isEmpty() || destination.isEmpty()){ %>
			<h1>Please Specify both Departure and Destination Airports!</h1> <%
		} 
		else if (departDate.isEmpty() || (roundTrip != null && returnDate.isEmpty())){
			%>
			<h1>Please Specify Dates!</h1> <%
		}
		else{
			
	  
	        //Try-catch price and stop conversions
	        try{
	        	if (!maxPrice.isEmpty()){
	        		double maxp = Double.parseDouble(maxPrice);
	        	}
	        	if (!maxStops.isEmpty()){
	        		double maxs = Integer.parseInt(maxStops);
	        	}
	        	
	        	ArrayList<ArrayList<Flight>> paths = getPaths(departure, destination, false, con);
	        	
	        	ArrayList<ArrayList<Flight>> filtered = filterOneWay(paths, departDate, flexibleDate, classType,
	        			 maxPrice, maxStops, airline, earliestTakeoff, latestTakeoff, earliestArrival, latestArrival, con);
	        	
	        	if (roundTrip != null){
	        		ArrayList<ArrayList<Flight>> pathsBack = getPaths(destination, departure, true, con);
	        		
	        		ArrayList<ArrayList<Flight>> filteredBack = filterOneWay(pathsBack, returnDate, flexibleDate, classType,
		        			 maxPrice, maxStops, airline, earliestTakeoff, latestTakeoff, earliestArrival, latestArrival, con);
	        		
	        		ArrayList<ArrayList<Flight>> doubleFiltered = filterTwoWay(filtered, filteredBack, 
	        				departDate, returnDate, classType, maxPrice, maxStops, con);
	        		
	        		filtered = doubleFiltered;
	        		
	        		//Sort
	        		sort(filtered, sortType, lowFirst, classType, true);
	        		
	        		
	        		
	        		//Display table
	        		%>
		        	<br>
		        	<% 
		        	for (ArrayList<Flight> path : filtered){
		        		int totPrice = 0;
		        		int toDuration = 0, fromDuration = 0, totDuration = 0, atDestination = 0;
		        		String leaveDate = getDate(path.get(0).d, departDate).toString();
		        		String backDate = getDate(path.get(path.size() - 1).d, returnDate).toString();
		        		
		        		String totDeparture = path.get(0).dept;
		        		String totArrival = path.get(path.size() - 1).arrt;
		        		
		        		
		        		for (int i = 0; i < path.size(); i++){
		        			Flight f = path.get(i);
		        			if (classType.equals("firstClass")) totPrice += f.ff;
							else if (classType.equals("business")) totPrice += f.bf;
							else totPrice += f.ef;
		        			
		        			if (f.des.equals(destination)) atDestination = i;
		        		}
		        		
		        		toDuration = getSeconds(path.get(atDestination).arrt) - getSeconds(totDeparture);
		        		int toDurationHours = toDuration / 3600;
		        		int toDurationMinutes = (toDuration % 3600) / 60;
		        		
		        		fromDuration = getSeconds(totArrival) - getSeconds(path.get(atDestination + 1).dept);
		        		int fromDurationHours = fromDuration / 3600;
		        		int fromDurationMinutes = (fromDuration % 3600) / 60;
		        		
		        		totDuration = toDuration + fromDuration;
		        		int totDurationHours = totDuration / 3600;
		        		int totDurationMinutes = (totDuration % 3600) / 60;
		        		
		        		String[] fields = {"", "Date", "Departs From", "Arrives At", "Airline", "Flight ID", "Departure Time", "Arrival Time"};

		        		
		        		
		        		%>
		        		Possible Flight Path:
		        		<table>
		        			<tr>
		        			<td> Total Price: $<%= totPrice %> | </td>
		        			<td> Outgoing: <%= toDurationHours %>H<%= toDurationMinutes %>M | </td>
		        			<td> Return: <%= fromDurationHours%>H<%= fromDurationMinutes %>M | </td>
		        			<td> Total Duration: <%= totDurationHours %>H<%= totDurationMinutes %>M | </td>
		        			
							</tr>
						</table>
						<table>
							
							<% for (int i = 0; i < path.size(); i++){
								Flight f = path.get(i);
								String flightDate;
								if (i <= atDestination){
									flightDate = getDate(f.d, departDate).toString();
								}
								else{
									flightDate = getDate(f.d, returnDate).toString();
								}
								%>
								<tr>
								<td> Flight <%=i + 1%></td>
								<td> | <%= f.d %><td>
								<td> | <%= flightDate %><td>
								<td> | From: <%=f.dep %><td>
								<td> | To: <%=f.des %><td>
								<td> | Airline: <%=f.a %><td>
								<td> | Flight ID: <%=f.n %><td>
								<td> | Departs: <%=f.dept %><td>
								<td> | Arrives: <%=f.arrt %><td>
								</tr>
								
							<%
							}
							%>
		        		
		        		</table>
		        		<br><br>
		        		
		        		<%
	        		}
	        	}
	        	
	        	else{
	        		
	        		//sort
	        		sort(filtered, sortType, lowFirst, classType, false);
	        		
	        		//Display table
	        		%>
		        	<br>
		        	<% 
		        	
		        	for (ArrayList<Flight> path : filtered){
		        		int totPrice = 0;
		        		String leaveDate = getDate(path.get(0).d, departDate).toString();
		        		
		        		String totDeparture = path.get(0).dept;
		        		String totArrival = path.get(path.size() - 1).arrt;
		        		
		        		
		        		for (int i = 0; i < path.size(); i++){
		        			Flight f = path.get(i);
		        			if (classType.equals("firstClass")) totPrice += f.ff;
							else if (classType.equals("business")) totPrice += f.bf;
							else totPrice += f.ef;
		        		}
		        		
		        		int totDuration = getSeconds(totArrival) - getSeconds(totDeparture);
		        		int totDurationHours = totDuration / 3600;
		        		int totDurationMinutes = (totDuration % 3600) / 60;
		        		
		        		String[] fields = {"", "Date", "Departs From", "Arrives At", "Airline", "Flight ID", "Departure Time", "Arrival Time"};
		        		
		        		
		        		%>
		        		Possible Flight Path:
		        		<table>
		        			<tr>
		        			<td> Total Price: $<%= totPrice %> | </td>
		        			<td> Duration: <%= totDurationHours %>H<%= totDurationMinutes %>M | </td>
		        			
							</tr>
						</table>
						<table>
							
							<% for (int i = 0; i < path.size(); i++){
								Flight f = path.get(i);
								String flightDate = getDate(f.d, departDate).toString();;
								%>
								<tr>
								<td> Flight <%=i + 1%></td>
								<td> | <%= f.d %><td>
								<td> | <%= flightDate %><td>
								<td> | From: <%=f.dep %><td>
								<td> | To: <%=f.des %><td>
								<td> | Airline: <%=f.a %><td>
								<td> | Flight ID: <%=f.n %><td>
								<td> | Departs: <%=f.dept %><td>
								<td> | Arrives: <%=f.arrt %><td>
								</tr>
								
							<%
							}
							%>
		        		
		        		</table>
		        		<br><br>
		        		
		        		<%
	        		}
	        	}
		        
		        db.closeConnection(con);
	        
	        	}
	        
	        catch(Exception ex){
	        	out.println("Please enter valid numbers");
	        }
	        
	        
		}
		%>
		<form action="customerDashboard.jsp">
		<input type="submit" value="Home">
	</form>
	<form action="../main.jsp">
		<input type="submit" value="Log out">
	</form>
	<%
	}
	
	catch (Exception ex) {
		out.print(ex);
		out.println("Error");
		%>
		<form action="main.jsp">
			<input type="submit" value="Back">
		</form>
		<%
	}
	%>
</body>
</html>