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

<%
String months[] = {"January","Febraury","March","April","May","June","July","August","September","October","November","December"};
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>Expense Manager</title>
<meta name="keywords" content="" />
<meta name="description" content="expense manager" />
<link href="stylesheets/default.css" rel="stylesheet" type="text/css" />
</head>

<body>

<table width="100%" border="0" cellpadding="0" cellspacing="0" class="container" id="header">
	<tr>
		<td id="logo"><h1>Expense Manager</h1>
			<p>beta</p></td>
		<td><table width="100%" border="0" cellpadding="0" cellspacing="0" id="menu">
				<tr>
					<td><a href="welcome.jsp" target="showFrame">Home</a></td>
					<td><a href="add.jsp" target="showFrame">Add</a></td>
					<td><a href="pay.jsp" target="showFrame">Pay</a></td>
					<td><a href="showGraph.jsp" target="showFrame">Expenses</a></td>
					<td><a href="contact.jsp" target="showFrame">Contact</a></td>
				</tr>
			</table></td>
	</tr>
</table>

<table width="100%" border="0" cellpadding="0" cellspacing="0" class="container">
	<tr>
		<td id="page"><table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr valign="top">
					<td id="sidebar"><table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td><h2>Recent Activities </h2></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
							</tr>
							<%
							String query = "select from " + DataHolder.class.getName() + " order by date desc";
							PersistenceManager pm = PMF.get().getPersistenceManager();
							List<DataHolder> data = (List<DataHolder>) pm.newQuery(query).execute();
							if (data.isEmpty()) {
							%>
								<tr><td><p>No Recent Activities</p></td></tr>
								<%
							} %><%
							else
							{
								int cnt = 0;
								for (DataHolder d : data) 
								{
									if(cnt++ == 10)break;
									Date dat = d.getDate();
									int whichdate = dat.getDate();
									int whichmonth = dat.getMonth();
									int whichyear = dat.getYear();
									int whichhour = dat.getHours();
									int whichminute = dat.getMinutes();
									int whichsecond = dat.getSeconds();
									String participants = d.getParticipantsName();
								%>
							<tr>
								<td><p><strong><%= months[whichmonth] %> <%= whichdate %>,  <%= whichyear+1900 %></strong>
								<%= d.getUser().getNickname() %> added <%= d.getCost() %> for <%= d.getReason() %>, <%= participants %></p></td>
								
							</tr>
							<%
								}
							}
							%>
						</table>
						</td>
					<td>&nbsp;</td>
					<td id="content">
							<iframe name="showFrame" src="welcome.jsp" id='showFrame' scrolling=yes frameborder=0></iframe>
						<iframe src="http://www.facebook.com/plugins/like.php?href=cookingexpense.appspot.com&amp;layout=standard&amp;show_faces=true&amp;width=450&amp;action=like&amp;font=arial&amp;colorscheme=light&amp;height=80" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:450px; height:80px;" allowTransparency="true"></iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="container" id="footer">
	<tr>
		<td><p>Copyleft &copy; 2011 cookingexpense.appspot.com.</p></td>
	</tr>
</table>
</body>
</html>
