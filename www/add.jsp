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
<%@ page import="CookingExpense.ExpenseConstants" %>
<%@ page import="CookingExpense.PMF" %>

<%
String participantss[] = ExpenseConstants.participants;
int peopleCount = ExpenseConstants.peopleCount;
%>

<script type = "text/javascript">

function checkit()
{
	var peopleCount = <%=peopleCount%>;
	var participants = new Array(peopleCount);
	for( i =0 ;i< peopleCount; ++i)
	{
		pariticipants[i] = participantss[i];
	}
	if(document.getElementById('all').checked)
	{
		for(i = 0 ; i < peopleCount; ++i)
		{
			document.getElementById(participants[i]).disabled = 1;
		}
	}
	else 
	{
		for(i = 0 ; i< peopleCount; ++i)
		{
			document.getElementById(participants[i]).disabled = 0;
		}
	}
}
</script>

<html>
<head>
<link href="stylesheets/default.css" rel="stylesheet" type="text/css" />
</head>
<body class="plain">
<%
UserService userService = UserServiceFactory.getUserService();
User user = userService.getCurrentUser();
String guys[] = ExpenseConstants.participantEmail;
int total_guys = ExpenseConstants.peopleCount;
boolean okay = false;
if(user == null) 
{
	%>
	<p> <b> Hi dude/dudette ! </b></p>
	<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a> to add your expense.</p>
	<%
}
else 
{
%>
	<p>Welcome <b><%=user.getNickname()%></b></p>
<%
	for(int i=0;i< ExpenseConstants.peopleCount; ++i)
	{
		if(user.getNickname().equalsIgnoreCase(guys[i]))
		{
			okay = true;
			break;
		}
	}
	if(okay)
	{
		%>
			<form name = "thisform" action="/expense" method="post">
			<div>
				Amount Spent:
				<Input type="text" name="cost"/>
			</div>
			<br>
			<div>
				Reason: 
				<Input type="text" name="reason" cols="100">
			</div>
			<br>
			<div>
				Participants:<br>
				<Input type="checkbox" name="all" value="all" id = "all" onclick = "checkit()">All</Input><br>
			<%
				for(int i=0; i< ExpenseConstants.peopleCount; ++i)
				{
			%>
					<Input type="CHECKBOX" name="participants" value= <%= participantss[i] %> id= <%= participantss[i] %> /><%= participantss[i] %><br>
			<%
				}
			%>
			</div>
			<br>
			<div>
				<Input type="submit" value="submit"/></div>
			</form>
			<br>
			<%
	}
	else
	{
%>
		<p>Sorry.. You are not allowed to post.</p> 
		Join the bad guyz cooking group @ PH410 to <br>eat the most delicious food of your life time :D :D!!
<%
	}
%>
	<p><a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">Sign out</a></p>
<%	
}
%>
</body>
</html>