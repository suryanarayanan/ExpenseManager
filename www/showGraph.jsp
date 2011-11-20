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

<html>
<head>
<link href="stylesheets/default.css" rel="stylesheet" type="text/css" />
</head>
<body class="plain">
<%
 PersistenceManager pm = PMF.get().getPersistenceManager();
    String query = "select from " + DataHolder.class.getName() + " order by date desc";
    List<DataHolder> data = (List<DataHolder>) pm.newQuery(query).execute();
	ArrayList<Double> currentmonth_amount_graph = new ArrayList<Double>();
	ArrayList<Double> lastmonth_amount_graph = new ArrayList<Double>();
	ArrayList<Double> lastmonth_clearance = new ArrayList<Double>();
	int total_guys = ExpenseConstants.peopleCount;
	boolean disable_all = false;
	String months[] = {"January","Febraury","March","April","May","June","July","August","September","October","November","December"};
	String guys[] = ExpenseConstants.participants;
	Date date = new Date();
	int curmonth = date.getMonth();
	for(int i=0;i<ExpenseConstants.gridCells;++i)
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
	<b>Last month(<%= months[(curmonth-1+12)%12] %>) Contributions:</b><br>
	<table class="graph">
		<tr>
			<th id="graph-th">---></th>
		<%
			for(int i =0;i<total_guys; ++i)
			{
		%>
				<th align="left" id="graph-th"> <%= guys[i] %> </th>				
		<%
			}
		%>
		</tr>
		<%
			for(int i=0;i< total_guys; ++i)
			{
		%>
			<tr>
				<th id="graph-th" align="left"><%= guys[i] %></th>
		<%
			for(int j=0;j< total_guys ; ++j)
			{
				if(lastmonth_clearance.get(i*total_guys+j) == 1. || i == j || lastmonth_amount_graph.get(i*total_guys+j) == 0.)
				{
					%><td style="background: #e8edff; background-image: url('./stylesheets/images/img07.jpg'); background-repeat: no-repeat; background-position: center; border-bottom: 1px solid #fff; border-top: 1px solid;"> <%= Math.round(lastmonth_amount_graph.get(i*total_guys+j)) %></td><%
				}
				else
				{
				%>
					<td><%= Math.round(lastmonth_amount_graph.get(i*total_guys+j)) %></td>
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

	<p><b>This month(<%= months[curmonth] %>) Contributions: </b></p>
	<table class="graph">
		<tr>
			<th id="graph-th">---></th>
		<%
			for(int i =0;i<total_guys; ++i)
			{
		%>
				<th align="left" id="graph-th"> <%= guys[i] %> </th>				
		<%
			}
		%>
		</tr>
		<%
			for(int i=0;i< total_guys; ++i)
			{
		%>
			<tr>
				<th align="left" id="graph-th"><%= guys[i] %></th>
		<%
			for(int j=0;j< total_guys ; ++j)
			{
		%>
				<td id="graph-td"><%= Math.round(currentmonth_amount_graph.get(i*total_guys+j)) %></td>
		<%
			}
		%>
			</tr>
		<%
			}
		%>
	</table>
	<br>
</body>
</html>
