package main;

func main() {
    var x = 5;
    print(foo(x,x));
}

func foo (foo int, b int) int{
    return foo(b);
}
