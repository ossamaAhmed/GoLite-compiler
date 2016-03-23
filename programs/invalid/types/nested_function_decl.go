package main;

func main() {
    //can't define nested functions
    func foo (a int, b int) int{
        return a+b;
    }
    var x = 5;
    print(foo(x));
}

