/* 2D array with conflicting types in variable declaration.  */

package main

var array [88] int [79] float64 // Error: Can't have multiple types here.

func main() {
	// Do nothing.
}
