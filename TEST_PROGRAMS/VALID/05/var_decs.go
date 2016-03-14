/* Variable declarations. */

package main

var x int // Type only
var y = 42 // Expression only
var z int = 1 // Type and expression

var x1, x2 int 
var y1, y2 = 42, 43
var z1, z2, z3 int = 1, 2, 3

var ( // You can also declare a bunch all at once
	a1, a2 int
	b1, b2, b3 = 42, 43, 44
	c1, c2 int = 1, 2
)

func add(x, y int) int {
	return x + y
}

func main() {
	x := 10 // You can do short variable declarations
	z := add(5,4) // You can use functions to declare
	y = x + z
}
