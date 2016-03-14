/* Non-integer in array variable declaration. */

package main

var array [1.0] string // Error: Size value must be of type int.

func main() {
	// Do nothing.
}
