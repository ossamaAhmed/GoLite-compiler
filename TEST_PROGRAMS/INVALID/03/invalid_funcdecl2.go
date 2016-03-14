package main
func f(a int, b int, c string, d int) {
	return
}
func f() {}

func f(a int, b int, c string, d int) string {
	return c
}
func f(a, b int, c [3:4]int, d int) string {
	return c
}
