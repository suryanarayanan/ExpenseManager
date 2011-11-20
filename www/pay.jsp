<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Date" %>
<%@ page import="javax.jdo.PersistenceManager" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="CookingExpense.DataHolder" %>
<%@ page import="CookingExpense.ExpenseGraph" %>
<%@ page import="CookingExpense.CommentHolder" %>
<%@ page import="CookingExpense.PMF" %>
<%@ page import="CookingExpense.ExpenseConstants" %>

<%
UserService userService = UserServiceFactory.getUserService();
User user = userService.getCurrentUser();
%>

<html>
<head>
<link href="stylesheets/default.css" rel="stylesheet" type="text/css" />
</head>
<body class="plain">
<%
if(user == null) 
{
	%>
	<p> <b> Hi dude/dudette ! </b></p>
	<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a> for a settlement ;)</p>
	<%
}
else
{
		boolean okay = false;
		for(int i=0;i< ExpenseConstants.peopleCount; ++i)
		{
			if(user.getNickname().equalsIgnoreCase(ExpenseConstants.participantEmail[i])){
				okay = true;
				break;
			}
		}
		if(okay)
		{
%>
<form name="clearanceform" method=post action="/clearance">
			<div>
			<p><b>Last month Clearance:</b></p>
			<%
				for(int i =0 ;i< ExpenseConstants.peopleCount; ++i)
				{
					if(user.getNickname().equalsIgnoreCase(ExpenseConstants.participantEmail[i]))
						continue;
					else{
						%><Input type="CHECKBOX" name="clearance" value=<%= ExpenseConstants.participants[i]%> id=<%= ExpenseConstants.participants[i]%> ><%= ExpenseConstants.participants[i]%></Input><%
					}
				}
			%>
			<br><br>
			<Input type= "submit" value="Tranferred"/>
			</div>
		</form>
	<%
		}
		else {
			%><p>Sorry.. You are not allowed to post.</p> 
			Join the bad guyz cooking group @ PH410 to <br>eat the most delicious food of your life time :D :D!!<%
		}
}
	%>
		</body>
		</html>