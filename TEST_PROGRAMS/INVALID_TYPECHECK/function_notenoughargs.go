package main;

func main() {
    var x = 5;
    //foo requires two arguments
    print(foo(x));
}

func foo (a int, b int) int{
    return a+b;
}
