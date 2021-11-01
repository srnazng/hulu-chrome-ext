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
			Statement stmt = con.createStatement();
			//Get the selected radio button from the index.jsp
			String entity = request.getParameter("command");
			//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
			// String str = "SELECT * FROM " + entity;
			String str = "SELECT * FROM " + entity;
					
			
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);
			
			//put account fields so don't have to write them out
			String[] fields = new String[]{"username", "password", "account_num", "first_name", "last_name"};
				
		
		%>
			
		<!--  Make an HTML table to show the results in: -->
	<table>
		<tr>
			<% if (entity.equals("account")) { %>    
				<% for (String field : fields) { %>
						<td><%= field %></td>
				<% } 
				} else {%>
					<td> account_num </td>
				<% } %>
		</tr>
			<%
			//parse out the results
			while (result.next()) { %>
				    <tr>
				    <% if (entity.equals("account")) { %>    
						<% for (String field : fields) { %>
						<td><%= result.getString(field) %></td>
						<% } 
						} 
				    	else { %>
						<td><%= result.getString("account_num") %> </td>
						<% } %> 
					</tr>
				
				

			<% }
			//close the connection.
			db.closeConnection(con);
			%>
		</table>

			
		<%} catch (Exception e) {
			out.print(e);
		}%>
	

	</body>
</html>