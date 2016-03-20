package main;

func main() {
    var x = 5;
    print(foo(x));
}

//formals can't have the same name
func foo (a int, a int) int{
    return a+a;
}
