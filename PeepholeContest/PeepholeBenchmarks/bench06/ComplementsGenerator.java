import java.util.*;
import joos.lib.JoosRandom;

public class ComplementsGenerator {

	protected int complementNumber;
        protected JoosRandom r;

	public ComplementsGenerator(){
	    super();
            r = new JoosRandom(1);
	}



	public String generateComment(String adj, String verb, String noun){
               
                int random;
                int reducedNumber;
                random = r.nextInt();
               
		reducedNumber = random%12;
                if(reducedNumber<0)
                   complementNumber = reducedNumber + 12;
                else
                   complementNumber = reducedNumber;
                
		if(complementNumber==0) return "I love how your hair smells like  a " + adj + " " + noun + ". It makes me want to " + verb + ".";
		else if(complementNumber==1) return "I always admired you're " + noun + ". I can't wait to " + verb + " with you.";
		else if(complementNumber==2) return  "You remind me of my " + noun + ". your " + adj + " legs gives me the shivers.";	
		else if(complementNumber==3) return  "I was " + adj + " until I met you - and i can't " + verb + " ever since.";
		else if(complementNumber==4) return "I can't wait to show you my " + noun + ". I have a feeling you will " + verb + ".";
		else if(complementNumber==5) return "If you'll leave me it will be a " + noun + ". I would rather be " + adj + ".";
		else if(complementNumber==6) return "I hope our " + adj + " relationship will "  + verb + " like a " + noun + ".";
		else if(complementNumber==7) return  "You make me want to be a " + adj + " man. from now on I'll " + verb + " harder.";
		else if(complementNumber==8) return  "Show me that " + adj + " " + noun + " of yours! "; 
		else if(complementNumber==9) return  "Let's " + verb + " all night long, you " + adj + " lady, you...";
		else if(complementNumber==10) return  "Show me your " + noun + " and I'll show you mine.";
		else return  "you are my " + noun + " my only " + noun + " , you make me " + adj + " when skies are grey."; 
	}

	
	public int getComplementNumber() {
		return complementNumber;
	}


	public String generateAdjective() {
	      int random;
              int correctedRandom;
              random = r.nextInt()%10;
              if(random<0)
                 correctedRandom = random+10;
              else
                 correctedRandom = random;
	      if(correctedRandom==0) return "dead";
	       else if(correctedRandom==1) return "beautiful";
               else if(correctedRandom==2) return "single";
               else if(correctedRandom==3) return "blind";
               else if(correctedRandom==4) return "enormous";
               else if(correctedRandom==5) return "sexy";
               else if(correctedRandom==6) return "talented";
               else if(correctedRandom==7) return "better";
               else if(correctedRandom==8) return "happy";
               else return "crappy";
	}


	public String generateNoun(){ 
	      int random;
              int correctedRandom;
              random = r.nextInt()%9;
              if(random<0)
                 correctedRandom = random+9;
              else
                 correctedRandom = random;
	       if(random==0) return "fruit";
	       else if(correctedRandom==1) return "work-ethic";
               else if(correctedRandom==2) return "niece";
               else if(correctedRandom==3) return "problems";
               else if(correctedRandom==4) return "tragedy";
               else if(correctedRandom==5) return "dream";
               else if(correctedRandom==6) return "sunshine";
               else if(correctedRandom==7) return "raccoon";
               else return "skin";
	}


	public String generateVerb() {
	      int random;
              int correctedRandom;
              random = r.nextInt()%10;
              if(random<0)
                 correctedRandom = random+10;
              else
                 correctedRandom = random;
	       if (random==0) return "rot";
	       else if(correctedRandom==1) return "cry";
               else if(correctedRandom==2) return "puke";
               else if(correctedRandom==3) return "work";
               else if(correctedRandom==4) return "sleep";
               else if(correctedRandom==5) return "be-pleased";
               else if(correctedRandom==6) return "flourish";
               else if(correctedRandom==7) return "nibble";
               else if(correctedRandom==8) return "program";
               else return "eat-bananas";
	}
}