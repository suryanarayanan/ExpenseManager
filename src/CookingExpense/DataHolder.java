package CookingExpense;

import java.util.Date;
import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.IdentityType;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;
import com.google.appengine.api.users.User;
import CookingExpense.ExpenseConstants;
@PersistenceCapable(identityType = IdentityType.APPLICATION)
public class DataHolder {
    @PrimaryKey
    @Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
    private Long id;

    @Persistent
    private User user;

    @Persistent
    private double cost;

	@Persistent
	private String reason;
	
    @Persistent
    private Date date;
	
	@Persistent
	private int participants;

    public DataHolder(User user, double cost,String reason, Date date, int participants) {
        this.user = user;
        this.cost = cost;
		this.reason = reason;
        this.date = date;
		this.participants = participants;
    }

    public Long getId() {
        return id;
    }

    public User getUser() {
        return user;
    }

    public double getCost() {
        return cost;
    }
	
	public String getReason()
	{
		return reason;
	}

    public Date getDate() {
        return date;
    }

	public int getParticipants(){
		return participants;
	}
	
	public String getParticipantsName(){
		String group="";
		for(int i = ExpenseConstants.peopleCount-1 ; i>=0; --i){
			if((participants & (1<<i)) != 0){
				group+=ExpenseConstants.participants[ExpenseConstants.peopleCount - i -1];
				group+="|";
			}
		}
		return group;
	}
	
    public void setUser(User author) {
        this.user = author;
    }

    public void setCost(double cost) {
        this.cost = cost;
    }

	public void setReason(){
		this.reason = reason;
	}
    public void setDate(Date date) {
        this.date = date;
    }
	public void setParticipants(int participants) {
		this.participants = participants;
	}
}
