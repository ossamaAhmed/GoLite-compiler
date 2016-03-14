/* Function arguments in declaration ending in a comma. */

package main

func foo(a, b int, c float64,) {} // Error: Can't end argument list on a comma.

func main() {
	// Do nothing.
}
