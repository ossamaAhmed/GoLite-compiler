package main;

func main (){

    var x int = 5;
    var s [] int
    s= append(s,x)

    //accessing an out of range variable is a runtime error
    print(s[1])

}
