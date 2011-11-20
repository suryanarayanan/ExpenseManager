package CookingExpense;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.logging.Logger;
import javax.jdo.PersistenceManager;
import javax.servlet.http.*;
import javax.jdo.JDOHelper;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import CookingExpense.DataHolder;
import CookingExpense.ExpenseGraph;
import CookingExpense.PMF;
import CookingExpense.ExpenseConstants;

public class CookingExpenseServlet extends HttpServlet {
	private static final Logger log = Logger.getLogger(CookingExpenseServlet.class.getName());
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        double cost =0.;
		if(req.getParameter("cost") !=  "")
		try
		{
			cost = Double.parseDouble(req.getParameter("cost"));
		}catch(Exception e)
		{
			resp.sendRedirect("/add.jsp");
		}
		String reason = req.getParameter("reason");
		int participants = 0;
		String values_chk[]=req.getParameterValues("participants");
		if(values_chk == null)
		{
			values_chk = req.getParameterValues("all");
		}
		if(values_chk == null || cost == 0.)
		{
			resp.sendRedirect("/add.jsp");
		}
		for(int i= 0;i<values_chk.length;++i)
		{
			if(values_chk[i].equals("all"))
			{
				participants |= (1<<ExpenseConstants.peopleCount) - 1;
				break;
			}
			for(int j = 0 ;j< ExpenseConstants.participants.length; ++j)
			{
				if(values_chk[i].equalsIgnoreCase(ExpenseConstants.participants[j]))
				{
					participants |= 1<<(ExpenseConstants.peopleCount-j-1);
				}
			}
		}	
        Date date = new Date();
        DataHolder dataholder = new DataHolder(user, cost, reason, date, participants);
		PersistenceManager pm = PMF.get().getPersistenceManager();
		PersistenceManager pm1 = PMF.get().getPersistenceManager();
		String query = "select from " + ExpenseGraph.class.getName();
		List<ExpenseGraph> exp = (List<ExpenseGraph>) pm1.newQuery(query).execute();
		if(exp.isEmpty())
		{
			ExpenseGraph ex = new ExpenseGraph(date);
			ex.update(cost,participants,user.getNickname(),true,date);
			try
			{
				pm1.makePersistent(ex);
			}finally{
			pm1.close();
			}
		}
		else
		{
			if(exp.get(0).getDate().getMonth() == date.getMonth() - 1)
			{
				exp.get(0).setLastMonthGraph(exp.get(0).getCurrentMonthGraph());
				exp.get(0).clearCurrentMonth();
			}
			exp.get(0).update(cost,participants,user.getNickname(),true,date);
			pm1.close();
		}
		try {
			pm.makePersistent(dataholder);
		} finally {
				pm.close();
		}
        resp.sendRedirect("/add.jsp");
    }
}
