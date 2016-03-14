/* Braceless blocks in cases. */

package main

func main() {
	var x int = 5

	switch x {
		default: println("Error: Single digit required")
		case 0, 2, 4, 6, 8: println("Even")
		case 1, 3, 5, 7, 9: println("Odd")
	}
}
