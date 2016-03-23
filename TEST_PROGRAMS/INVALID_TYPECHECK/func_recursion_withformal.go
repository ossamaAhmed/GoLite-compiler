package main;

func foo (foo int, b int) int{
    return foo(b);
}

func main() {
    var x = 5;
    print(foo(x,x));
}

