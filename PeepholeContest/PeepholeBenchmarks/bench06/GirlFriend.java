public class GirlFriend extends Woman {

	public GirlFriend(){
	  super();
	}

	public String react(String complement, String adj, String noun, String verb) {
		if(complementNumber==0){
		   if ((adj.equals("beautiful")|| adj.equals("sexy")) && (noun.equals("dream")||noun.equals("sunshine"))&& (!(verb.equals("puke"))))
			return "that's the best complement a man has ever gave me!";
		    else if(noun.equals("raccoon")|| verb.equals("puke"))
			return "that's the most disgusting thing I've ever heard.";
		    else return "You'll have to do better than that.";
		}

		else if(complementNumber==1){
		    if (noun.equals("skin") && (verb.equals("sleep") || verb.equals("eat-banana")))
			return "you touched the very botttom of my soul.";
		    else if (noun.equals("niece"))
			return "you sick bastard, stay away from my family.";
		    else return "that don't impresse me much.";
		}

		else if(complementNumber==2){
		      if(noun.equals("dream")&&(adj.equals("beautiful")|| adj.equals("sexy")))
			  return "My oh my, what a gentelmen..";
		      else if (noun.equals("raccoon")||adj.equals("enormous"))
			  return "Go to hell!!"; 
		      else return "Try again, mister..";
		}

		else if(complementNumber==3){
		    if((adj.equals("dead")||adj.equals("blind")||adj.equals("crappy"))&& (verb.equals("cry")||verb.equals("work")||verb.equals("sleep")))
			return "You are the man of my dreams (-: ";
		    else if (verb.equals("eat-bananas")||verb.equals("puke"))
			return "you are a freak. you know that, right?";
		    else return "nice try, but that won't cut it.";
		}

		else if(complementNumber==4){
		      if((noun.equals("niece")||noun.equals("dream")||noun.equals("skin"))&& (verb.equals("cry")|| verb.equals("be-pleased")))
			  return "take me, I'm yours!";
		      else if (noun.equals("fruit"))
			  return "you pervert, leave me alone!";
		      else return "I don't think so.";
		}

		else if(complementNumber==5){
		      if(noun.equals("tragedy")){
			  if(adj.equals("dead"))
			      return "that's the best complement a man has ever gave me!";
			  else return "that's a bit weird, but good enough..";
		      }
		      else if (noun.equals("fruit")||noun.equals("work-ethic"))
			      return "man, you are not making any sence..";
		      else return "move along, mister.";
		}

		else if(complementNumber==6){
		      if((adj.equals("beautifull")||adj.equals("lovely"))&&(verb.equals("flourish"))&&(noun.equals("dream")||noun.equals("summer's-day")))
			   return "damn, you are god. take me home with you.";
		      else if (verb.equals("rot")) 
			    return "'rot'? you stink at giving complements!";
		      else return "When hell frizes.";
		}

		else if(complementNumber==7){
		    if(adj.equals("better"))
			return "that's a bit wierd, but not to bad..";
		    else if (adj.equals("dead")||adj.equals("blind"))
			return "are you trying to insult me or to complement me?";
		    else return "na, I don't think so.";
		}

		else if(complementNumber==8){
		    if((adj.equals("enormous")||adj.equals("beautiful"))&& (noun.equals("skin")))
			return "you are amazing!";
		    else if(noun.equals("raccoon")||noun.equals("fruit"))
			return "Grose, dude.";
		     else return "no way, man.";
		}

		else if(complementNumber==9){
		      if (adj.equals("beautiful")|| adj.equals("sexy"))
			    return "A strange proposal, but whu not!";
		      else return "you are out of line here, mister.";
		}

		else if(complementNumber==10){
		      if(adj.equals("skin")||adj.equals("sunshine"))
			  return "you are a complement mechine!";
		      else if(noun.equals("raccoon")||noun.equals("fruit"))
			  return "I'm calling the cops.";
		      else return "ah, I don't think so.";
		}

		else{
		    if(noun.equals("sunshine")&& adj.equals("happy"))
			  return "You are good!";
		    else return "ahm, I think you should try again.";
		}
	}
}