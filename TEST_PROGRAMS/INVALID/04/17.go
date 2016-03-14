package main

func main() {
    //Illegal escape in interpreted string
    var x = "\'"
    x++ // "use" x
}
