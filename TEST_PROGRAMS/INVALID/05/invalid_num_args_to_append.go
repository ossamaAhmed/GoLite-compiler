/* Invalid # of arguments to append. */

package main

var slice []int

func main() {
	append(slice, 0, 1) // Error: append only accepts two arguments.
}
