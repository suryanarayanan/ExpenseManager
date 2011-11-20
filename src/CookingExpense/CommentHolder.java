package CookingExpense;

import java.util.Date;
import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.IdentityType;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;
import com.google.appengine.api.users.User;

@PersistenceCapable(identityType = IdentityType.APPLICATION)
public class CommentHolder {
    @PrimaryKey
    @Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
    private Long id;

    @Persistent
    private User user;

	@Persistent
	private String comment;
	
    @Persistent
    private Date date;

    public CommentHolder(User user,String comment, Date date) {
        this.user = user;
		this.comment = comment;
        this.date = date;
    }

    public Long getId() {
        return id;
    }

    public User getUser() {
        return user;
    }
	
	public String getComment()
	{
		return comment;
	}

    public Date getDate() {
        return date;
    }

    public void setUser(User author) {
        this.user = author;
    }

	public void setComment(){
		this.comment = comment;
	}
    public void setDate(Date date) {
        this.date = date;
    }
}
