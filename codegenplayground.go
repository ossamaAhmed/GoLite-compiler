// Try to access fields of a variable when:
// - it is declared as a struct (s)
// - it is declared as an alias to a struct (p)
// - it is declared as an alias to an alias to a struct (q)
//
// Also try to put aliased fields inside a struct

package main

type point struct {
	x, y, z float64;
}

func main() {

}
