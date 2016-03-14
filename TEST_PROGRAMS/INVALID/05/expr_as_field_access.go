/* Expression as field access. */

package main

type T struct {
	x, y, z int
}

func main() {
	var t T

	t.("x")
}
