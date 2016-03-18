package main;

func main() {
    var x = 5;
    print(foo(x,x));
}

//this is allowed
func foo (a int, b int) int{
    return a+b;
}
