package main;

//this example allows variable redecl in different scopes
func main (){

    var x int = 5;
    var y int;
    {
        y = x +1;
        var x int = y
        y = x+1
        print(y)

    }
    print(x)
}
