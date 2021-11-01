<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Login Page</title>
	</head>
	
	<body>

		Hello World1 <!-- the usual HTML way -->
		<% out.println("Hello World2"); %> <!-- output the same thing, but using 
	                                      jsp programming -->
							  
		<br>
	
		 <!-- Show html form to i) display something, ii) choose an action via a 
		  | radio button -->
		<!-- forms are used to collect user input 
			The default method when submitting form data is GET.
			However, when GET is used, the submitted form data will be visible in the page address field-->
		<form method="post" action="show.jsp">
		    <!-- note the show.jsp will be invoked when the choice is made -->
			<!-- The next lines give HTML for radio buttons being displayed -->
		  <input type="radio" name="command" value="account"/>Displaying account table
		  <br>
		  <input type="radio" name="command" value="customer"/>Displaying customer table
		    
		  <br>
		  <input type="submit" value="submit" />
		</form>
		<br>
	
	Enter your username and password to login:
	<br>
		<form method="get" action="login.jsp">
			<table>
				<tr>    
					<td>Username</td><td><input type="text" name="username"></td>
				</tr>
				<tr>
					<td>Password</td><td><input type="text" name="password"></td>
				</tr>
				
			</table>
			<input type="submit" value="Attempt to login">
		</form>
	<br>
	<form action="createAccount.jsp">
		<input type="submit" value="Create Account">
	</form>
	

</body>
</html>