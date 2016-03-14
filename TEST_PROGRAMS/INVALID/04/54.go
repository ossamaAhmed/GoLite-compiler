package main

func main() {
    var x = 2

    //Illegal short variable declarator in post-position
    for x := 2 ; x > 2 ; x := 2 {
        x++
    }
}
