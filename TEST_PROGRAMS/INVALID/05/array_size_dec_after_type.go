/* Array size declaration is after the type (should be just before). */

package main

func main() {
	var s string[10] // Error: wrong side of the array
	s[0] = "Hello"
	s[1] = "World"
}
