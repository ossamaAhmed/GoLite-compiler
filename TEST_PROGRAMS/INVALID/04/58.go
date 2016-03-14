package main

func main() {
    var x = 2

    //Illegal for
    for x := 2; x > 2 {
        x++
    }
}
