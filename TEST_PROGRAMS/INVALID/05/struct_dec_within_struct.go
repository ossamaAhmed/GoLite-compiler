/* struct declaration within a struct. */

package main

var t struct {
	a, b int
	type new_t struct {
		x rune
		y string
	}
	c, d new_t
}

func main() {
	// Do nothing
}
