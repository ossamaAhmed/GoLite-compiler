/* Type declarations. */

package main

/* You can define new types! Look! */

type num int // Simple type alias

type point struct {
	x int
	y float64
}

type (
	num2 int
	point2 struct {
		x, y float64
	}
)

func main() {
	// Do nothing
}
