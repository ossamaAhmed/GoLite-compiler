package main

type t int

func f(x t) {
}

func main() {
	var x t
	var y t
	var z int

	y = x - y
	// Argument is not an int
	f(x)
}
