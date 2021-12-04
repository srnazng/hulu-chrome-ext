<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Insert title here</title>
	</head>
	<body>
		<% try {
	
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
			Statement stmt1 = con.createStatement();
			Statement stmt2 = con.createStatement();
			Statement stmt3 = con.createStatement();
			
			
			//cant use preparedstatement because only column values can be placeholded, not table name (injection)
			String str = "SELECT * FROM account order by account_num";
			String adminQuery = "SELECT * FROM admin";
			String custrepQuery = "SELECT * FROM customer_rep";
			String custQuery = "SELECT * FROM customer";
			
			
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);
			ResultSet adminres = stmt1.executeQuery(adminQuery);
			Set<String> admins = new HashSet<String>();
			while (adminres.next()) {
				admins.add(adminres.getString(1));
			}
			ResultSet custrepres = stmt1.executeQuery(custrepQuery);
			Set<String> custreps = new HashSet<String>();
			while (custrepres.next()) {
				custreps.add(custrepres.getString(1));
			}
			ResultSet custres = stmt1.executeQuery(custQuery);
			Set<String> custs = new HashSet<String>();
			while (custres.next()) {
				custs.add(custres.getString(1));
			}
			Set<String> usernames = new HashSet<String>();
			result.first();
			while (result.next()) {
				usernames.add(result.getString("username"));
			}
			//put account fields so don't have to write them out
			String[] fields = new String[]{"username", "password", "account_num", "first_name", "last_name"};
			int count = 1;
			result.first();
			if (request.getParameter("addCust") != null || request.getParameter("addCustRep") != null) {
				String accountnum = request.getParameter("account_num");
				String username = request.getParameter("username");
				System.out.println(accountnum);
				if (custreps.contains(accountnum) || custs.contains(accountnum)) {
					out.print("Insert failed: Account number was not unique");
				}
				else if (usernames.contains(username)) {
					out.print("Insert failed: Username was not unique");
				}
				else if (request.getParameter("password").equals("") || 
						request.getParameter("first_name").equals("") ||
						request.getParameter("last_name").equals("")) {
					out.print("Insert failed: Not all fields were populated");
				}
				else {
					result.last();
					result.moveToInsertRow();
					try {
						result.updateString("username", username);
						result.updateString("password", request.getParameter("password"));
						result.updateInt("account_num", Integer.parseInt(accountnum));
						result.updateString("first_name", request.getParameter("first_name"));
						result.updateString("last_name", request.getParameter("last_name"));
						result.insertRow();
						if (request.getParameter("addCust") != null) {
							String insert = "Insert into customer VALUES (" + accountnum + ")";
							Statement insertstmt = con.createStatement();
							insertstmt.executeUpdate(insert);
							custs.add(request.getParameter("account_num"));
						}
						else {
							String insert = "Insert into customer_rep VALUES (" + accountnum + ")";
							Statement insertstmt = con.createStatement();
							insertstmt.executeUpdate(insert);
							custreps.add(request.getParameter("account_num"));
						}
					}
					catch (Exception e) {
						out.print("Insert failed: check that fields are populated and username and account_num are unique");
					}
				}
				
				
			}
			if (request.getParameter("delete") != null) {
				result.first();
				while (result.next()) {
					if (result.getString("account_num").equals(request.getParameter("delete"))) {
						//update respective account type table
						if (custreps.contains(request.getParameter("delete"))) {
							String delete = "Delete from customer_rep WHERE account_num = " + request.getParameter("delete");
							System.out.println(delete);
							Statement deletestmt = con.createStatement();
							deletestmt.executeUpdate(delete);
							custreps.remove(request.getParameter("delete"));
							
						}
						else {
							String delete = "Delete from customer WHERE account_num = " + request.getParameter("delete");
							System.out.println(delete);
							Statement deletestmt = con.createStatement();
							deletestmt.executeUpdate(delete);
							custs.remove(request.getParameter("delete"));
							
						}
						
						result.deleteRow();		
						result.updateRow();
						break;
					}
				}
				
				out.print("Row deleted!");
			}
			if (request.getParameter("updateInfo") != null) {
				result.first();
				count = 1;
				while (result.next()) {
					if (!admins.contains(result.getString("account_num"))) { 
						for (String field : fields) {
							result.updateString(field, request.getParameter(field+count));
							
						}
						result.updateRow();
						count++;
					}
					
				}
				
				out.print("Table updated!");
				
			}	
			
			result.first();
		
		%>

		<!--  Make an HTML table to show the results in: -->
	<table>
		<form name="updateInfo" method="post">
		<tr>
			<% for (String field : fields) { %>
					<td><%= field %></td>
			<% } %>
			<td> Account Type </td> 
		</tr>
		<%
		count = 1;
		//parse out the results
		while (result.next()) { %>
		<% if (!admins.contains(result.getString("account_num"))) { %>
	    <tr> 
			<% for (String field : fields) { 
				if (!field.equals("account_num")) { %>
				<td> <input type="text" name=<%= field+count %> value=<%= result.getString(field)%>> </td>
				<% } 
				else { %>
			 	<td> <%= result.getString(field) %> </td>
			<% }
			  }
			String type = "None";
			if (custreps.contains(result.getString("account_num"))) {
				type = "Customer Rep";
			}
			else if (custs.contains(result.getString("account_num"))) {
				type = "Customer";
			}
			%>
			<td> <%= type %></td>
			<td> <button type="submit" name="delete" value=<%= result.getString("account_num") %>>Delete</button> </td> 
		</tr>
		<% 
			count++;
			}
			
		}  %>
		<% 
		
		%>
		<tr> 
			
				<td><input type="submit" name="updateInfo" value="Update Table"></td>
			
		</tr>
		<tr>
		
				<td><input type="submit" name="addCustRep" value="Add Customer Rep"><br>
				<input type="submit" name="addCust" value="Add Customer"></td>
			
			<% for (String field : fields) { %>
				
				<td> 
					<label><%= field %></label>
					<input type="text" name=<%= field %>>  
				</td>
			<% } %>
			
		</tr>
		</form>
	</table>
	<hr>
	<table>
		<tr>
			<td> Generate sales report for particular month</td>	
			<td> 
				<form id="reportMonth" method="post">
					
					<select id="months" name="months">
						    <option value="1">January</option>
						    <option value="2">February</option>
						    <option value="3">March</option>
						    <option value="4">April</option>
						    <option value="5">May</option>
						    <option value="6">June</option>
						    <option value="7">July</option>
						    <option value="8">August</option>
						    <option value="9">September</option>
						    <option value="10">October</option>
					  		<option value="11">November</option>
						    <option value="12">December</option>
					  </select>
					  <input type="submit"/>	
					
				</form>
					
			</td>
		</tr>
		<% if (request.getParameter("months") != null)  {%>
		<tr>
			<td>Total Tickets Bought</td>
			<td>Tickets in First Class</td>
			<td>Tickets in Business</td>
			<td>Tickets in Economy</td>
			<td>Total Fare</td>
			<td>Total Booking Fees</td>
			<td>Total Revenue</td>
		</tr>
		<%
		
			
			//Create a Prepared SQL statement allowing you to introduce the parameters of the query
			String statement = "Select count(*) as totalTickets, sum(total_fare) as totalFare, sum(booking_fee) as totalBooking, class  from reserve_ticket where Month(purchase_time) = ? group by class";
			PreparedStatement ps = con.prepareStatement(statement);
			ps.setString(1, request.getParameter("months"));
			ResultSet results = ps.executeQuery(); 
			int totalTickets = 0;
			int fcTickets = 0;
			int businessTickets = 0;
			int economyTickets = 0;
			float totalFare = 0;
			float totalBooking = 0;
			float totalRev;
			while (results.next()) {
				totalTickets += results.getInt("totalTickets");
				totalFare += results.getFloat("totalFare");
				totalBooking += results.getFloat("totalBooking");
				if (results.getString("class").equals("economy")) {
					economyTickets = results.getInt("totalTickets");
				}
				if (results.getString("class").equals("business")) {
					businessTickets = results.getInt("totalTickets");
				}
				if (results.getString("class").equals("first_class")) {
					fcTickets = results.getInt("totalTickets");
				
				}
			}
			totalRev = totalFare + totalBooking;
		%>
		<tr>	
			<td> <%= totalTickets %></td>
			<td> <%= fcTickets %></td>
			<td> <%= businessTickets %></td>
			<td> <%= economyTickets %></td>
			<td> <%= totalFare %></td>
			<td> <%= totalBooking %></td>
			<td> <%= totalRev %></td>
		</tr>
		<% } %>
	</table>
	<hr>
	<table>
		<tr>
			<td>Search reservations for a specific flight number or customer name</td>	
			
		</tr>
		<tr>
			<td>
				<form id="searchReservation" method="post">
					<label>Search by flight number or name</label>
					<select id="reservationsearchType" name="reservationsearchType">
						<option value="flightnum">Flight Number</option>
						<option value="name">Customer Name</option>
					</select> <br/>
					<label>Input first name or flight number</label>
					<input type="text" name="firstSearchBox"/> <br/>
					<label>Input last name if name is selected</label>
					<input type="text" name="secondSearchBox"/><br/>
					<input type="submit"/>	
				</form>	
			</td>
		</tr>
		<% if (request.getParameter("firstSearchBox") != null)  {%>
	 
		<%
			if (request.getParameter("reservationsearchType").equals("flightnum")) {
				String statement = "Select * from reserve_ticket join includes using (ticket_number) where flight_number = ?";
				PreparedStatement ps = con.prepareStatement(statement);
				ps.setString(1, request.getParameter("firstSearchBox"));
				ResultSet results = ps.executeQuery();	
				if (!results.isBeforeFirst()) {
		%>
				<tr><td>No results found</td></tr>
		<%
				}
				else {
		%>
					<tr>
						<td>Ticket Number</td>
						<td>Account Number</td>
						<td>Class</td>
						<td>Purchase Time</td>
						<td>Total Fare</td>
						<td>Booking Fee</td>
					</tr> 
		<% 
					while (results.next()) {
		%>
					<tr>
						<td> <%= results.getString("ticket_number") %></td>
						<td> <%= results.getString("account_num") %></td>
						<td> <%= results.getString("class") %></td>
						<td> <%= results.getString("purchase_time") %></td>
						<td> <%= results.getString("total_fare") %></td>
						<td> <%= results.getString("booking_fee") %></td>
					</tr>
		<% 
					}
				}
			}
		%>
		<%
			if (request.getParameter("reservationsearchType").equals("name")) {
				String statement = "Select * from reserve_ticket join portfolio using (account_num) join account using (account_num) where first_name LIKE ? and last_name LIKE ?";
				PreparedStatement ps = con.prepareStatement(statement);
				ps.setString(1, "%" + request.getParameter("firstSearchBox") + "%");
				ps.setString(2, "%" + request.getParameter("secondSearchBox") + "%");
				ResultSet results = ps.executeQuery();
				if (!results.isBeforeFirst()) {
					%>
					<tr><td>No results found</td></tr>
			<%
					}
					else {
			%>
								<tr>
									<td>Ticket Number</td>
									<td>Account Number</td>
									<td>Class</td>
									<td>Purchase Time</td>
									<td>Total Fare</td>
									<td>Booking Fee</td>
								</tr> 
					<% 
								while (results.next()) {
					%>
								<tr>
									<td> <%= results.getString("ticket_number") %></td>
									<td> <%= results.getString("account_num") %></td>
									<td> <%= results.getString("class") %></td>
									<td> <%= results.getString("purchase_time") %></td>
									<td> <%= results.getFloat("total_fare") %></td>
									<td> <%= results.getFloat("booking_fee") %></td>
								</tr>
					<% 
								}
							}
						}
					%>
		
		<% } %>
	</table>
	<hr>
	<table>
		<tr>
			<td>Get revenue from a particular flight, airline, or customer</td>	
			
		</tr>
		<tr>
			<td>
				<form id="createReservation" method="post">
					<label>Search by flight number, airline id, or customer name</label>
					<select id="revenueSearch" name="revenueSearch">
						<option value="flightnum">Flight Number</option>
						<option value="airlineid">Airline ID</option>
						<option value="name">Customer Name</option>
					</select> <br/>
					<label>Input first name, flight number, or airline id</label>
					<input type="text" name="firstSearchRevenue"/> <br/>
					<label>Input last name if name is selected</label>
					<input type="text" name="secondSearchRevenue"/><br/>
					<input type="submit"/>	
				</form>	
			</td>
		</tr>
		<% if (request.getParameter("firstSearchRevenue") != null)  {%>
		<%
			if (request.getParameter("revenueSearch").equals("flightnum") || request.getParameter("revenueSearch").equals("airlineid")) {
				String statement = request.getParameter("revenueSearch").equals("flightnum") ? "Select * from reserve_ticket join includes using (ticket_number) where flight_number = ?" : "Select * from reserve_ticket join includes using (ticket_number) where airline_id = ?";
				PreparedStatement ps = con.prepareStatement(statement);
				ps.setString(1, request.getParameter("firstSearchRevenue"));
				ResultSet results = ps.executeQuery();	
				if (!results.isBeforeFirst()) {
		%>
				<tr><td>No results found</td></tr>
		<%
				}
				else {
		%>
					<tr>
						<td>Total Booking Fee Revenue</td>
						<td>Total Fare Revenue</td>
						
					</tr> 
		<% 
					float totalFare = 0;
					float totalBooking = 0;
					while (results.next()) {
						totalFare += results.getFloat("total_fare");
						totalBooking += results.getFloat("booking_fee");	
					}
					%>
					<tr> 
						<td> <%= totalFare %></td>
						<td> <%= totalBooking %></td>
					</tr>
					<% 
				}
			}
		%>
		<%
			if (request.getParameter("revenueSearch").equals("name")) {
				String statement = "Select * from reserve_ticket join portfolio using (account_num) join account using (account_num) where first_name LIKE ? and last_name LIKE ?";
				PreparedStatement ps = con.prepareStatement(statement);
				ps.setString(1, "%" + request.getParameter("firstSearchRevenue") + "%");
				ps.setString(2, "%" + request.getParameter("secondSearchRevenue") + "%");
				ResultSet results = ps.executeQuery();
				if (!results.isBeforeFirst()) {
					%>
					<tr><td>No results found</td></tr>
			<%
					}
					else {
			%>
						<tr>
							<td>Total Booking Fee Revenue</td>
							<td>Total Fare Revenue</td>
							
						</tr> 
			<% 
						float totalFare = 0;
						float totalBooking = 0;
						while (results.next()) {
							totalFare += results.getFloat("total_fare");
							totalBooking += results.getFloat("booking_fee");	
						}
						%>
						<tr> 
							<td> <%= totalFare %></td>
							<td> <%= totalBooking %></td>
						</tr>
						<% 
					}
				}
		%>

		
		<% } %>
	</table>
	<hr>
	<table>
		<tr>
			<td>Get the customer who generated the most revenue</td>	
			
		</tr>
		<tr>
			<td>
				<form id="" method="post">
					
					<label>Get Customer</label>
					<input type="submit" name="getCustRev"/>	
				</form>	
			</td>
		</tr>
		<%		
			if (request.getParameter("getCustRev") != null) {
				String statementRev = "Select (SUM(total_fare)+SUM(booking_fee)) as totalRev, a.account_num, a.first_name, a.last_name from reserve_ticket join portfolio using (account_num) join account a using (account_num) group by account_num having totalRev >= all (Select (SUM(total_fare)+SUM(booking_fee)) as totalRev from reserve_ticket join portfolio using (account_num) join account a using (account_num) group by account_num) Order by totalRev desc";
				Statement ps = con.createStatement();
				ResultSet resultRev = ps.executeQuery(statementRev);
				if (!resultRev.first()) {
					%>
					<tr><td>No results found</td></tr>
			<%
					}
					else {
			%>
						<tr>
							<td>Total  Revenue</td>
							<td>Customer Account Number</td>
							<td>Customer Name</td>
							
						</tr> 
						<tr> 
							<td> <%= resultRev.getFloat("totalRev") %></td>
							<td> <%= resultRev.getString("account_num") %></td>
							<td> <%= resultRev.getString("first_name") + " " + resultRev.getString("last_name") %> </td>
						</tr>
						<% 
					}
			}
				
		%>
	</table>
	<hr>
	<table>
		<tr>
			<td>Get a list of the most active flights by most tickets sold</td>	
			
		</tr>
		<tr>
			<td>
				<form id="" method="post">
					
					<label>Get Customer</label>
					<input type="submit" name="activeFlights"/>	
				</form>	
			</td>
		</tr>
		<%		
			if (request.getParameter("activeFlights") != null) {
				String statementRev = "Select flight_number, count(*) as totalTickets from includes group by flight_number order by totalTickets desc";
				Statement ps = con.createStatement();
				ResultSet resultRev = ps.executeQuery(statementRev);
				if (!resultRev.first()) {
					%>
					<tr><td>No results found</td></tr>
			<%
					}
					else {
			%>
					<tr>
						<td>Flight Number</td>
						<td>Total Tickets Sold</td>
						
					</tr>
			<%
					do {
			%>
						 
						<tr> 
							<td> <%= resultRev.getString("flight_number") %></td>
							<td> <%= resultRev.getString("totalTickets") %></td>
						</tr>
						<% 
					} while (resultRev.next());
				}
			}
				
		%>
	</table>	
			
		<%
			db.closeConnection(con);
		} catch (Exception e) {
			out.print(e);
		}%>
	

	</body>
</html>