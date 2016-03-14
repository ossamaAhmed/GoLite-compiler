package main

func main() {
    //Illegal backtick in raw string
    var x = `ab`ab`
    x++ // "use" x
}
