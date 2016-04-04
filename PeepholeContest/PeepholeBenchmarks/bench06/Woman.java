public abstract class Woman {

	protected int complementNumber;
	
	public Woman(){
	   super();
	}

	public final void setComplementNumber(int number) {
		complementNumber = number;
	}

	public abstract String react(String complement, String adjective, String noun, String verb);
	
	
}