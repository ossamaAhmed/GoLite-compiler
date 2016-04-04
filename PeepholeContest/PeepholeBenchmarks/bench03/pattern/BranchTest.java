import joos.lib.*;

public class BranchTest {

    public BranchTest() { super(); }


    public void equal(){
	int a,b;
	a = 1;
	b = 2;
	if(a == b){
	    a = 0;
	}
	if(a != b){
	    b = 0;
	}
    }

    public void lt(){
	int a,b;
	a = 1;
	b = 2;
	if(a < b){
	    a = 0;
	}
	if(a >= b){
	    b = 0;
	}
    }
    public void le(){
	int a,b;
	a = 1;
	b = 2;
	if(a <= b){
	    a = 0;
	}
	if(a > b){
	    b = 0;
	}
    }

    public void gt(){
	int a,b;
	a = 1;
	b = 2;
	if(a > b){
	    a = 0;
	}
	if(a <= b){
	    b = 0;
	}
    }
    
    public void ge(){
	int a,b;
	a = 1;
	b = 2;
	if(a >= b){
	    a = 0;
	}
	if(a < b){
	    b = 0;
	}
    }


    public void notBool(){
	boolean t;
	int a,b;
	t = true;
	a = 1;
	b = 2;

	if(!(a > b)){
	    a = 0;
	}
	if(!(t || t)){
	    b = 0;
	}
    }



} 
