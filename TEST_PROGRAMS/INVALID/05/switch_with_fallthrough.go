/* Using fallthrough in switch statement. */

package main

func main() {
	var x int = 5

	switch x {
		default: println("Error: Single digit required")
		case 0, 2, 4, 6, 8: fallthrough // Error: falltrough is an invalid statement.
		case 1, 3, 5, 7, 9: println("Digit")
	}
}
