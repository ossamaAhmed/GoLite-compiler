package main

func main() {
    //Illegal struct type
    var x struct{ foo [-1]int; }
}
