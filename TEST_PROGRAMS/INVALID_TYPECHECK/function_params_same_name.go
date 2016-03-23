package main;

//formals can't have the same name
func foo (a int, a int) int{
    return a+a;
}
func main() {
    var x = 5;
    print(foo(x));
}

