package main
type t int
var x t

// x is not a type
var y x

func f() {
}

func main() {
	a := f()
	var y int
}
