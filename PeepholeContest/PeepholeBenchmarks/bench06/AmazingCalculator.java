public class AmazingCalculator {

	public AmazingCalculator(){
	    super();
	 }
	

	public int factorial(int input){
		if(input==0)
			return 1;
		else
		   return input*this.factorial(input-1);
	}
	
	public void bla(){
        }
}