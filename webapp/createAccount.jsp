<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<!-- Alternatively, create a new (customer) account -->
		Create a New Account
		<br>
			<form method="post" action="createAccount.jsp", onsubmit=<%=createAccount() %>>
			<table>
			<tr>    
			<td>First Name</td><td><input type="text" name="Firstname"></td>
			</tr>
			<tr>
			<td>Last Name</td><td><input type="text" name="Lastname"></td>
			</tr>
			<tr>    
			<td>Username</td><td><input type="text" name="Username"></td>
			</tr>
			<tr>
			<td>Password</td><td><input type="text" name="Password"></td>
			</tr>
			</table>
			<input type="submit" value="Create New Account!">
			</form>
		<br>
	<%
	
	void createAccount(Form input){
		try {
					
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
	
			//Create a SQL statement
			Statement stmt = con.createStatement();
	
			//Get parameters from the HTML form at the index.jsp
			
			String firstname = input.Firstname.value;
			String lastname = input.Lastname.value;
			String username = input.Username.value;
			String password = input.Password.value;
	
			
			//Find the new account number by finding the number of account
			
			//Make an insert statement for the Accounts table:
			String insert = "INSERT INTO accounts(name)"
					+ "VALUES (?)";
			//Create a Prepared SQL statement allowing you to introduce the parameters of the query
			PreparedStatement ps = con.prepareStatement(insert);
	
			//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
			ps.setString(1, newBar);
			ps.executeUpdate();
	
			
			//Make an insert statement for the Sells table:
			insert = "INSERT INTO beers(name)"
					+ "VALUES (?)";
			//Create a Prepared SQL statement allowing you to introduce the parameters of the query
			ps = con.prepareStatement(insert);
			//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself		
			ps.setString(1, newBeer);
			ps.executeUpdate();
	
			
			//Make an insert statement for the Sells table:
			insert = "INSERT INTO sells(bar, beer, price)"
					+ "VALUES (?, ?, ?)";
			//Create a Prepared SQL statement allowing you to introduce the parameters of the query
			ps = con.prepareStatement(insert);
	
			//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
			ps.setString(1, newBar);
			ps.setString(2, newBeer);
			ps.setFloat(3, price);
			//Run the query against the DB
			ps.executeUpdate();
			//Run the query against the DB
			
			//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
			con.close();
			out.print("insert succeeded");
			
		} catch (Exception ex) {
			out.print(ex);
			out.print("insert failed");
		}
	}
%>
</body>
</html>