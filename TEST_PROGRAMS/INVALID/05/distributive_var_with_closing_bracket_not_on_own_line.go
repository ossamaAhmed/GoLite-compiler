/* "Distributive" var declaration with closing bracket not on its own line. */

package main

var (
        a rune = 'a'
        b1, b2 string ) // Error: Closing bracket must be on its own line.


func main() {
	// Do nothing
}
