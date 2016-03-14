/* "Distributive" var declarations. */

package main

var ()

var ( a rune
    b string = "String"
)

var (
    x int
    y float64 = x
    z1, z2 string
)

func main() {
	// Do nothing
}
