package main;

func main() {
    var x = 5;
    print(foo(x,x));
}

func foo (a int, b int) int{
    return a+b;
}
//can't overload foo in go lite
func foo (a int, b int,c int) int{
    return a+b+c;
}
