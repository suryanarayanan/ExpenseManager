package CookingExpense;
import CookingExpense.ExpenseGraph;
import CookingExpense.PMF;
import CookingExpense.ExpenseConstants;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.logging.Logger;
import javax.jdo.PersistenceManager;
import javax.servlet.http.*;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class Clearance extends HttpServlet {
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {
		try{
		int participants = 0;
		String values_chk[]=req.getParameterValues("clearance");
		if(values_chk == null)
		{
			resp.sendRedirect("/welcome.jsp");
		}
		for(int i= 0;i<values_chk.length;++i)
		{
			for(int j = 0 ;j < ExpenseConstants.peopleCount; ++j)
			{
				if(values_chk[i].equalsIgnoreCase(ExpenseConstants.participants[j]))
				{
					participants |= 1<<(ExpenseConstants.peopleCount-j-1);
					break;
				}
			}
		}
        PersistenceManager pm = PMF.get().getPersistenceManager();
		UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        String query = "select from " + ExpenseGraph.class.getName() + " order by date desc";
		List<ExpenseGraph> graphs = (List<ExpenseGraph>) pm.newQuery(query).execute();
		if(!graphs.isEmpty())
		{
			graphs.get(0).updateClearance(user.getNickname(),participants);
		}
		pm.close();
		resp.sendRedirect("/welcome.jsp");
		}catch(Exception e)
		{
			System.out.println("Error");
		}
    }
}
