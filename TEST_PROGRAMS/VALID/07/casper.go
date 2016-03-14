package main

//testing switch statement

var result string
type token struct{
	name string
	
} 

func main(){
 	
	var t1 token
	t1.name="a"
	var t2 token
	t2.name="b"
	var t3 token
	t3.name="c"
	var t4 token
	t4.name="d"
	
	result=callSwitch(t1)
	print(result)
	
}
	
		
	


func callSwitch(t1 token) string{
	switch t1.name {	
	default : return "no token received"
	case "a" : return "append"
	case "b" : return "break"
	case "c" : return "continue"
	case "d" : return "d"
	}
	
}


