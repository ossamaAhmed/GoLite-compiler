
public class FemaleBoss extends Woman {


	public FemaleBoss(){
	    super();
	}

	public String react(String complement, String adj, String noun, String verb) {

		if(complementNumber==0) return "This is highly inappropriate.";

		else if(complementNumber==1){
		      if((noun.equals("work-ethic")||noun.equals("dream"))&&(verb.equals("work")||verb.equals("program")))
			  return "I feel a promotion coming your way!!";
		      else return "get out of my office.";
		}

		else if(complementNumber==2) return "are you familiar with the term sexual harassment?";
			 
		else if(complementNumber==3) return "I am your boss, you know.";

		else if(complementNumber==4){
		    if(noun.equals("work-ethic")&& !(adj.equals("sexy")))
			return "I'm impressed, you are hired.";
		    else return "get out of my office, you sick sick man.";
		}

		else if(complementNumber==5) return "If I was your girlfriend, that might have been funny. you are fired.";

		else if(complementNumber==6) return "who the hell do you think you are talking to??";

		else if(complementNumber==7){
		    if ((adj.equals("better")||adj.equals("happy")||adj.equals("talented"))&&(verb.equals("work")||verb.equals("program")))
			return "you have a slippery tongue..well done";
		    else return "get out of my office.";
		}

		else if(complementNumber==8){
		    if (noun.equals("work-ethic"))
		      return "that's a strange proposal, but Ive heard worse..";
		    else return "you are going to have hard time keeping your job like that.";
		}

		else if(complementNumber==9){
		    if((verb.equals("work")||verb.equals("program"))&& (adj.equals("happy")||adj.equals("talented")))
			return "let's indeed! you are a very talented young man..";
		    else return "are you familiar with the term sexual harassment?";
		}

		else if(complementNumber==10){
		      if (noun.equals("work-ethic")||noun.equals("problems")||noun.equals("dream"))
			  return "I don't understand exactly what you want, but whatever.";
		      else return "get out of my office, you pervert.";
		}
		 
		else return "WTF??";
	}
}