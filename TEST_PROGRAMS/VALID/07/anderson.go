/* 
 * Compute n terms of fibonacci sequence.
 * Read the number of terms to be produced from standard input.
 * Create the sequence in the following format: t1, t2, t3, .., tn.
 */

package main

// printfib function
func printfib(n int) {
	var a1, a2 = 0, 1

	for n > 0 {
		if n - 1 > 0 {
			print(a1, ", ")
		} else {
			println(a1)
		}

		a2, a1 = a1, a1 + a2
		n--;
	}
}

// global variable
var N = 10

// main function
func main() {
	println("Fibonacci(", N, ") ->> ")
	printfib(N)
}
