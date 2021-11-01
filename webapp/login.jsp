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
	<%
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		//Get parameters from the HTML form (the inputs) at the HelloWorld.jsp
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		
		String res = "SELECT * FROM account WHERE username = ? and password = ?";
		
		//Create a Prepared SQL statement allowing you to introduce the parameters of the query
		PreparedStatement ps = con.prepareStatement(res);
		
		//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
		ps.setString(1, username);
		ps.setString(2, password);
				
			
		ResultSet result = ps.executeQuery();
		
		if (!result.isBeforeFirst() ) {   
			out.print("Incorrect credentials, try again!");
		}
		else {
			out.print("Did it!");				
		}
		
		
		//probably do queries,
		// Select * from account where username = 'inputted name' and password = 'input'
		// from resulting query, find where what table account_num is in (customer, admin, cr)
			// this assumes account_num can only be one role
			// SELECT EXISTS(SELECT * FROM yourTableName WHERE yourCondition)
			
			
		
		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		con.close();

		
	} catch (Exception ex) {
		out.print(ex);
		out.print("Insert failed :()");
	}
%>
</body>
</html>