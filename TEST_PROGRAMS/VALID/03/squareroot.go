// Lucille's sqrt func //
/* ------------------- */
package main

func sqrt(x int) float {
	var quot float
	guess := 1.0

	for iter := 10; iter > 0; iter-- {
		quot = x / guess
		guess = 0.5 * (guess + quot)
	}
	return guess
}
