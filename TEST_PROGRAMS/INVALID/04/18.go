package main

func main() {
    //Illegal linefeed in interpreted string
    var x = "aa
bb"
    x++ // "use" x
}
