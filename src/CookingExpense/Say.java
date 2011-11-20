package CookingExpense;

import java.io.IOException;
import java.util.Date;
import java.util.logging.Logger;
import javax.jdo.PersistenceManager;
import javax.servlet.http.*;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import CookingExpense.DataHolder;
import CookingExpense.PMF;

public class Say extends HttpServlet {
	private static final Logger log = Logger.getLogger(Say.class.getName());
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
		String username;
		if(user == null)username = "Anonymous";
        else username = user.getNickname();
		String comment = req.getParameter("comments");
		comment = comment.replaceAll(">","&gt;");
		comment = comment.replaceAll("<","&lt;");
        Date date = new Date();
        CommentHolder commentholder = new CommentHolder(user,comment, date);
        PersistenceManager pm = PMF.get().getPersistenceManager();
        try {
            pm.makePersistent(commentholder);
        } finally {
            pm.close();
        }
        resp.sendRedirect("/CookingExpense.jsp");
    }
}