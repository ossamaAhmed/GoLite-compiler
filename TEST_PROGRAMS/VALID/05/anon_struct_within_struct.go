/* struct within a struct. */

package main

var t struct {
	a, b int
	u, v struct {
		x rune
		y string
	}
	c string
}

func main() {
	// Do nothing
}
