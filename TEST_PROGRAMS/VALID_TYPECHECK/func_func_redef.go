package main;

//this is allowed
func foo (a int, b int) int{
    var foo = 6;
    return a+b;
}

func main() {
    var x = 5;
    print(foo(x,x));
}

