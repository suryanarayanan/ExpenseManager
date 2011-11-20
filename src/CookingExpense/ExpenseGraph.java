package CookingExpense;

import java.util.Date;
import java.util.ArrayList;
import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.IdentityType;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;
import javax.jdo.JDOHelper;
import com.google.appengine.api.users.User;
import java.io.Serializable;
import CookingExpense.ExpenseConstants;

	class onedarray implements Serializable{
	
	ArrayList <Double> current_month_graph;
	
	public onedarray()
	{
		current_month_graph = new ArrayList<Double>();
		for(int i=0;i<ExpenseConstants.gridCells;++i)current_month_graph.add(new Double(0));
	}
	
	public ArrayList<Double> getGraph()
	{
		return current_month_graph;
	}
	
	public void setGraph(ArrayList <Double> graph)
	{
		current_month_graph = graph;
	}
	
	public void update(double cost, int participants, int part)
	{
		if(part == -1)return;
		int last = ExpenseConstants.peopleCount-1;
		int total_participants = Integer.bitCount(participants);
		double individual = cost/total_participants;
		for(int i=0;i<ExpenseConstants.peopleCount;++i)
		{
			if((participants & (1<<i)) != 0  && part != last-i)
			{	
				double temp = current_month_graph.get((last-i)*ExpenseConstants.peopleCount + part);
				double part_to_participant = current_month_graph.get(part*ExpenseConstants.peopleCount+last-i);
				temp += individual;
				if(part_to_participant < temp)
				{
						temp -= part_to_participant;
						current_month_graph.set(part*ExpenseConstants.peopleCount+last-i,new Double(0));
				}
				else
				{
					current_month_graph.set(part*ExpenseConstants.peopleCount+(last-i),part_to_participant-temp);
					temp = 0.;
				}
				current_month_graph.set((last-i)*ExpenseConstants.peopleCount+part,temp);
			}
		}
	}
}

@PersistenceCapable(identityType = IdentityType.APPLICATION)
public class ExpenseGraph {
    @PrimaryKey
    @Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
    private Long id;
	
	@Persistent
	Date date;
	
	@Persistent(serialized = "true",defaultFetchGroup="true")
	onedarray current_month;
		
	@Persistent(serialized = "true",defaultFetchGroup="true")
	onedarray last_month;
	
	@Persistent(serialized = "true",defaultFetchGroup="true")
	onedarray lastmonth_clearance;
	
	public ExpenseGraph(Date dat)
	{
		date = dat;
		current_month = new onedarray();
		last_month = new onedarray();
		lastmonth_clearance = new onedarray();
	}

    public Long getId() {
        return id;
    }
	
	public Date getDate()
	{
		return date;
	}
	
	public onedarray getCurrentMonth()
	{
		return current_month;
	}
	public onedarray getLastMonth()
	{
		return last_month;
	}
	
	public onedarray getClearance()
	{
		return lastmonth_clearance;
	}
	
	public void setCurrentMonth(onedarray obj)
	{
		current_month = obj;
	}
	
	public void setLastMonth(onedarray obj)
	{
		last_month = obj;
	}
	public void setClearance(onedarray obj)
	{
		lastmonth_clearance = obj;
		JDOHelper.makeDirty(this,"lastmonth_clearance");
	}
	
	public void setDate(Date dat)
	{
		date = dat;
	}
	
	public ArrayList<Double> getCurrentMonthGraph()
	{	
		return current_month.getGraph();
	}
	
	public ArrayList<Double> getLastMonthGraph()
	{	
		return last_month.getGraph();
	}
	public ArrayList<Double> getLastMonthClearance()
	{
		if(lastmonth_clearance == null)
		{
			lastmonth_clearance = new onedarray();
			setClearance(lastmonth_clearance);
		}
		return lastmonth_clearance.getGraph();
	}
	
	public void setCurrentMonthGraph(ArrayList <Double> array)
	{
		current_month.setGraph(array);
	}
	
	public void setLastMonthGraph(ArrayList <Double> array)
	{
		last_month.setGraph(array);
		JDOHelper.makeDirty(this,"last_month");
	}
		
	public void setClearance(ArrayList <Double> array)
	{
		lastmonth_clearance.setGraph(array);
		JDOHelper.makeDirty(this,"lastmonth_clearance");
	}
	
	public void clearCurrentMonth()
	{
		ArrayList <Double> temp = new ArrayList<Double>();
		for(int i=0;i<ExpenseConstants.gridCells;++i)temp.add(new Double(0));
		setCurrentMonthGraph(temp);
		setClearance(temp);
	}
	
	public void update(double cost, int participants, String name, boolean current, Date date)
	{
			int part = -1;
			for(int i=0;i<ExpenseConstants.peopleCount;++i)
			{
				if(name.equalsIgnoreCase(ExpenseConstants.participantEmail[i])){
					part = i;
					break;
				}
			}
			if(current)
				current_month.update(cost,participants,part);
			else 
				last_month.update(cost,participants,part);
			setDate(date);
			JDOHelper.makeDirty(this,"current_month");
			JDOHelper.makeDirty(this,"last_month");
			JDOHelper.makeDirty(this,"lastmonth_clearance");
	}
	
	public void updateClearance(String name, int participants)
	{
		int part = -1;
		for(int i=0;i<ExpenseConstants.peopleCount;++i)
		{
			if(name.equalsIgnoreCase(ExpenseConstants.participantEmail[i])){
				part = i;
				break;
			}
		}
		ArrayList <Double> clearance = lastmonth_clearance.getGraph();
		int cnt = ExpenseConstants.peopleCount-1;
		while(participants > 0)
		{
			int bit = participants % 2;
			participants/=2;
			if(bit != 0)
			{
				clearance.set(part*ExpenseConstants.peopleCount + cnt,1.);
			}
			cnt--;
		}
		setClearance(clearance);
	}
}
