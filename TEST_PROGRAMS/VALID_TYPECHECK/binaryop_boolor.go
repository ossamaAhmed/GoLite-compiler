package main;

func main() {
    var x bool = true;

    //the rhs should evaluate to bool
    var c bool = x || x;
    print(c);
}
