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

<script type = "text/javascript">
function checkit()
{
	if(document.getElementById('all').checked)
	{
			if(document.getElementById('arun'))
				document.getElementById('arun').disabled = 1;
			if(document.getElementById('santosh'))
				document.getElementById('santosh').disabled = 1;
			if(document.getElementById('surya'))
				document.getElementById('surya').disabled = 1;
			if(document.getElementById('vasanth'))
				document.getElementById('vasanth').disabled = 1;
			if(document.getElementById('yogesh'))
				document.getElementById('yogesh').disabled = 1;
	}
	else 
	{
			if(document.getElementById('arun'))
				document.getElementById('arun').disabled = 0;
			if(document.getElementById('santosh'))
				document.getElementById('santosh').disabled = 0;
			if(document.getElementById('surya'))
				document.getElementById('surya').disabled = 0;
			if(document.getElementById('vasanth'))
				document.getElementById('vasanth').disabled = 0;
			if(document.getElementById('yogesh'))
				document.getElementById('yogesh').disabled = 0;
	}
}
</script>

<html>
<head>
<title>Expense Manager</title>
<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
</head>
  <body>
  <h2><u>Expense Manager</u></h2>
<%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
	String arun = "arun.krishnan2014";
	String santosh = "santosh.epzpsg";
	String surya = "coolsury";
	String yogesh = "srsyogesh";
	String vasanth = "vasanth.t";
	String months[] = {"January","Febraury","March","April","May","June","July","August","September","October","November","December"};
	String guys[] = {"Arun","Santosh","Surya","Vasanth","Yogesh"};
	int total_guys = 5;
	boolean disable_all = false;
if(user == null) 
{
%>
	<p> <b> Hi dude/dudette ! </b></p>
	<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a> to add your cooking expense.</p>
<%
}
else 
{
%>
	<p>Welcome <b><%=user.getNickname()%></b></p>
<%
	if(user.getNickname().equals(arun) || user.getNickname().equals(santosh) || user.getNickname().equals(surya) || user.getNickname().equals(vasanth) || user.getNickname().equals(yogesh))
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
			Participants:
				<Input type="checkbox" name="all" value="all" id = "all" onclick = "checkit()">All</Input>
				<Input type="CHECKBOX" name="participants" value="arun" id = "arun">Arun</Input>
				<Input type="CHECKBOX" name="participants" value="santosh" id = "santosh">Santosh</Input>
				<Input type="CHECKBOX" name="participants" value="surya" id = "surya">Surya</Input>
				<Input type="CHECKBOX" name="participants" value="vasanth" id = "vasanth">Vasanth</Input>
				<Input type="CHECKBOX" name="participants" value="yogesh" id = "yogesh">Yogesh</Input>
		</div>
		<br>
		<div>
			<Input type="submit" value="submit"/></div>
		</form>
		<br>
		<form name="clearanceform" method=post action="/clearance">
			<div>
			<p><b>Last month Clearance:</b></p>
			<%
				if(!user.getNickname().equals(arun))
				{
			%><Input type="CHECKBOX" name="clearance" value="arun" id = "arun">Arun</Input><%
				}
			%>
			<%
				if(!user.getNickname().equals(santosh))
				{
			%><Input type="CHECKBOX" name="clearance" value="santosh" id = "santosh">Santosh</Input><%
				}
			%>
			<%
				if(!user.getNickname().equals(surya))
				{
			%><Input type="CHECKBOX" name="clearance" value="surya" id = "surya">Surya</Input><%
				}
			%>
			<%
				if(!user.getNickname().equals(vasanth))
				{
			%><Input type="CHECKBOX" name="clearance" value="vasanth" id = "vasanth">Vasanth</Input><%
				}
			%>
			<%
				if(!user.getNickname().equals(yogesh))
				{
			%><Input type="CHECKBOX" name="clearance" value="yogesh" id = "yogesh">Yogesh</Input><%
				}
			%>
			<br><br>
			<Input type= "submit" value="Tranferred"/>
			</div>
		</form>
<%
	}
	else
	{
%>
		<p>Sorry.. You are not allowed to post.</p> 
		Join the bad guyz cooking group @ PH410 to <br>eat the most delicious food of your life time !!
<%
	}
%>
	<p><a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">Sign out</a></p>
<%	
}
%>

<%
    PersistenceManager pm = PMF.get().getPersistenceManager();
    String query = "select from " + DataHolder.class.getName() + " order by date desc";
    List<DataHolder> data = (List<DataHolder>) pm.newQuery(query).execute();
	ArrayList<Double> currentmonth_amount_graph = new ArrayList<Double>();
	ArrayList<Double> lastmonth_amount_graph = new ArrayList<Double>();
	ArrayList<Double> lastmonth_clearance = new ArrayList<Double>();
	Date date = new Date();
	int curmonth = date.getMonth();
	for(int i=0;i<25;++i)
	{
		currentmonth_amount_graph.add(new Double(0));
		lastmonth_amount_graph.add(new Double(0));
		lastmonth_clearance.add(new Double(0));
	}
	query = "select from " + ExpenseGraph.class.getName();
    List<ExpenseGraph> expense = (List<ExpenseGraph>) pm.newQuery(query).execute();
	if(!expense.isEmpty())
	{
		if(expense.get(0).getDate().getMonth() == (curmonth -1 +12)%12)
		{
			Collections.copy(lastmonth_amount_graph,expense.get(0).getCurrentMonthGraph());
			expense.get(0).clearCurrentMonth();
		}
		else
		{
			Collections.copy(lastmonth_amount_graph,expense.get(0).getLastMonthGraph());
			Collections.copy(currentmonth_amount_graph,expense.get(0).getCurrentMonthGraph());
		}
		Collections.copy(lastmonth_clearance,expense.get(0).getLastMonthClearance());
	}

%>
	<p>Last month(<%= months[(curmonth-1+12)%12] %>) Contributions:</p>
	<table border="1">
		<tr>
			<th>---></th>
		<%
			for(int i =0;i<total_guys; ++i)
			{
		%>
				<th> <%= guys[i] %> </th>				
		<%
			}
		%>
		</tr>
		<%
			for(int i=0;i< total_guys; ++i)
			{
		%>
			<tr>
				<th><%= guys[i] %></th>
		<%
			for(int j=0;j< total_guys ; ++j)
			{
				if(lastmonth_clearance.get(i*5+j) == 1. || i == j || lastmonth_amount_graph.get(i*5+j) == 0.)
				{
					%><th bgcolor = "GREEN"><%= lastmonth_amount_graph.get(i*5+j) %></th><%
				}
				else
				{
				%>
					<th bgcolor = "RED"><%= lastmonth_amount_graph.get(i*5+j) %></th>
				<%
				}
				%>
		<%
			}
		%>
			</tr>
		<%
			}
		%>
	</table>
	<br>

	<p>This month(<%= months[curmonth] %>) Contributions:</p>
	<table border="1">
		<tr>
			<th>---></th>
		<%
			for(int i =0;i<total_guys; ++i)
			{
		%>
				<th> <%= guys[i] %> </th>				
		<%
			}
		%>
		</tr>
		<%
			for(int i=0;i< total_guys; ++i)
			{
		%>
			<tr>
				<th><%= guys[i] %></th>
		<%
			for(int j=0;j< total_guys ; ++j)
			{
		%>
				<th><%= currentmonth_amount_graph.get(i*5+j) %></th>
		<%
			}
		%>
			</tr>
		<%
			}
		%>
	</table>
	<br>
<%
    if (data.isEmpty()) {
%>
<p>The Cooking expenses database is empty.</p>
<%
    } 
	else {
		int cnt = 0;
        for (DataHolder d : data) 
		{
			if(cnt++ == 20)break;
			Date dat = d.getDate();
			int whichdate = dat.getDate();
			int whichmonth = dat.getMonth();
			int whichyear = dat.getYear();
			int whichhour = dat.getHours();
			int whichminute = dat.getMinutes();
			int whichsecond = dat.getSeconds();
			String participants = d.getParticipantsName();
%>
		<p><b><%= d.getUser().getNickname() %></b> added <%= d.getCost() %> for <%= d.getReason() %> on <%= whichdate %> <%= months[whichmonth] %> <%= whichyear+1900 %> at <%= whichhour %>:<%= whichminute %>:<%= whichsecond %>.Group : <%= d.getParticipantsName() %></p>
<%
        }
    }
%>
<br>
  <h4>Say something to Surya ? </h4>
  <form action="/say" method="post">
      <div><textarea name="comments" rows="3" cols="40"></textarea></div>
      <div><input type="submit" value="Say" /></div>
    </form>
	
<%
	query = "select from " + CommentHolder.class.getName() + " order by date desc range 0,10";
    List<CommentHolder> comms = (List<CommentHolder>) pm.newQuery(query).execute();
	for(CommentHolder ch : comms)
	{
%>
		<form action= "/DeleteComment" method="post">
<%
		if (ch.getUser() == null)
		{
%>
			<p>Anonymous says:</p>
<%
        }
		else
		{
%>
			<p><b><%= ch.getUser().getNickname() %></b> says:</p>
<%
        }
		String com = ch.getComment();
		com = com.replaceAll("<","&lt;");
		com = com.replaceAll(">","&gt;");
%>
		<blockquote><%= com %></blockquote>
		
		
		<Input type = "hidden" name = "commentBlock" value = "<%= ch.getComment() %>" />
<%		
		if(user != null && user.getNickname().equals(surya))
		{
%>
		<input type = "submit" value="Delete" />
<%		}
%>
		</form>
<%
	}
	pm.close();
%>
  </body>
</html>