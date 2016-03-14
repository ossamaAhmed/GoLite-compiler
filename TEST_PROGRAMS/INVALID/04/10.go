package main

func main() {
    //Illegal line-feed in rune
    var x = '
'
    x++ // "use" x
}
