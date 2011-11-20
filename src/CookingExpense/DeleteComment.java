package CookingExpense;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.logging.Logger;
import javax.jdo.PersistenceManager;
import javax.servlet.http.*;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import CookingExpense.CommentHolder;
import CookingExpense.PMF;

public class DeleteComment extends HttpServlet {
	private static final Logger log = Logger.getLogger(Say.class.getName());
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {
		String commentBlock = req.getParameter("commentBlock");
		commentBlock = commentBlock.trim();
        PersistenceManager pm = PMF.get().getPersistenceManager();
		UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        String query = "select from " + CommentHolder.class.getName() + " order by date desc";
		List<CommentHolder> comments = (List<CommentHolder>) pm.newQuery(query).execute();
		for(CommentHolder ch : comments)
		{
			String to_delete = ch.getComment().trim();
			if(user != null && user.getNickname().equals("coolsury") && to_delete.equals(commentBlock))
				pm.deletePersistent(ch);
		}
		resp.sendRedirect("/CookingExpense.jsp");
    }
}