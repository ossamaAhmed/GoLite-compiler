// functions parameters
/* ------------------ */
// Long form, one id with one type
package main

func f(a int, b int, c string, d int) {
	return
}

func f() {}

func f(a int, b int, c string, d int) string {
	return c
}

// Short form, many ids with one type
func f(a, b int, c string, d int) string {
	return c
}
