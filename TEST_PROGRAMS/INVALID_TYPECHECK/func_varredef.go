package main;

//this is not allowed
func foo (foo int, b int) int{
    var foo int = 10;
    return foo+b;
}
func main() {
    var x = 5;
    print(foo(x,x));
}

