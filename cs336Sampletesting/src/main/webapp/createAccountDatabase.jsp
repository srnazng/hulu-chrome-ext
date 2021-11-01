<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

<%
try {
					
		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
	
		//Create a SQL statement
		Statement stmt = con.createStatement();
			
		//Create account Id
		ResultSet result = stmt.executeQuery("Select COUNT(*) AS numrows from account");
		result.next();
		int account_num = result.getInt("numrows") + 1;
		result.close();
		//Get parameters from the HTML form at the index.jsp
		
		String firstname = request.getParameter("Firstname");
		String lastname = request.getParameter("Lastname");
		String username = request.getParameter("Username");
		String password = request.getParameter("Password");
			
		//Find the new account number by finding the number of account
			
		//Make an insert statement for the Accounts table:
		String insert = "INSERT INTO account(account_num, first_name, last_name, username, password)"
					+ "VALUES (?, ?, ?, ?, ?)";
		//Create a Prepared SQL statement allowing you to introduce the parameters of the query
		PreparedStatement ps = con.prepareStatement(insert);
	
		//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
		ps.setInt(1, account_num);
		ps.setString(2, firstname);
		ps.setString(3, lastname);
		ps.setString(4, username);
		ps.setString(5, password);
		ps.executeUpdate();
			
		insert = "INSERT INTO customer(account_num)"
				+ "VALUES (?)";
		
		ps = con.prepareStatement(insert);
		ps.setInt(1, account_num);
		ps.executeUpdate();
		
		con.close();
		out.print("Account created!");
			
	} catch (Exception ex) {
			out.print(ex);
			out.print("insert failed");
	}
	%>

</body>
</html>