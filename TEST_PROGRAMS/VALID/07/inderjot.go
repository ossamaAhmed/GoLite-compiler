package main

//testing if else and structs

var i, j=10,21
type student struct{
	name string
	score int
	
} 

func main(){
 	
	var s1 student
	s1.name="stu1"
	s1.score=20
	
	var s2 student
	s2.name="stu2"
	s2.score=40
	
	if s2.score%2==0 {
		print("score is even")
	} else {
		print("score is odd")
	}
	if x:=maxValue(s1,s2); x.score>0 {
		println(x.name+"got the higher score")
	}
	
		
	


}

func maxValue(s1,s2 student) student {
	if s1.score>s2.score {
	return s1
	} else {
	return s2
	}
}
