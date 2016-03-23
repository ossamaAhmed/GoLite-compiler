package main;

//this is not allowed
func foo (a int, b int) int{
    var a = 6;
    return a+b;
}
func main() {
    var x = 5;
    print(foo(x,x));
}

