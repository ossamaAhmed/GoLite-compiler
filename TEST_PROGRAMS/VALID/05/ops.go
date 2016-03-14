/* Ops from go spec */
package main

func f() int {
	return 4
}

func g() bool {
	return true
}

func h() bool {
	return false
}

func main() {
	var x [5] int
	y := 10
	i := 2
	a := 4
	x[i] = 3
	println(+y)
	println(23 + 3*x[i])
	println(y <= f())
	println(^a >> 1)
	println(h() || g())
}
