/* Multiple array declaration on single line with separate sizes and types. */

package main

func main() {
	var a1[1] int, a2[2] float64 // Error: Can't declare multiple arrays inline, with separate sizes and types.
}
