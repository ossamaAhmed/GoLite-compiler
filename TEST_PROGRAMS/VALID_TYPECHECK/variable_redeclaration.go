package main;

//variable redecl allowed in different scopes
func main (){

    var x int = 5;
    {
        var x int = 4
        print(x)

    }
    print(x)
}
