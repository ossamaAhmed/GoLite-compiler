/* Multiple types (the same) declared for a variable. */

package main

var m bool bool // Error: Can't have multiple types for a variable.

func main() {
	// Do nothing.
}
