import java.util.*;
import java.math.*;
import joos.lib.*;
import joos.lib.JoosRandom;

public class Main {
 
     protected ComplementsGenerator generator;
     protected AmazingCalculator calc;
     protected JoosRandom r;

      public Main() {
		super();
      }

      public static void main(String[] argv){
		int NumberOfWoman;
		String who_am_i_complementing;
		Woman woman;
		String adjective;
		String noun;
		String verb;
		String complement;
		String response;
		int input;
                int random;
                JoosIO IO;
                String userInputs;
                StringTokenizer st;
		String choice;
                JoosRandom r;
                ComplementsGenerator generator;
                AmazingCalculator calc;
                String numberInput;

                r = new JoosRandom(1);
                generator = new ComplementsGenerator();
		calc = new AmazingCalculator();

		//reading user's inputs
                IO = new JoosIO();
                IO.println("Please enter your input.\n");
		userInputs = IO.readLine();

		st = new StringTokenizer(userInputs);
                choice = st.nextToken(",");
           

		if(!(choice.equals("random"))){
			adjective = choice;
			noun = st.nextToken(",");;
			verb = st.nextToken(",");;
			numberInput = st.nextToken(",");
		}
		
		else{
			adjective = generator.generateAdjective();
			noun = generator.generateNoun();
			verb= generator.generateVerb();
			numberInput = st.nextToken(",");
		}

		input = ((new Integer(numberInput)).intValue());
		complement = generator.generateComment(adjective, verb, noun);
	      
		NumberOfWoman = 2;
		random = r.nextInt()%NumberOfWoman;
		if(random==0){
			woman = new GirlFriend();
			who_am_i_complementing = "girl-friend";
		}
		else{
			woman = new FemaleBoss();
			who_am_i_complementing = "boss";
		}
		
		woman.setComplementNumber(generator.getComplementNumber());
		response = woman.react(complement,adjective,noun,verb);
		
		
		IO.println("You have just told your " + who_am_i_complementing + ":\n\n" + complement +
				  "\n\nher response is: " + response + "\n\n" + "(also, the factorial of " +
				  "the number you have entered is " + calc.factorial(input) + ")\n");
        
      
       
	}

}