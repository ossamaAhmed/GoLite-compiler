/* Multiple array declaration on single line with separate sizes. */

package main

func main() {
	var a1[1], a2[2] int // Error: Can't declare multiple arrays inline with separate sizes.
}
