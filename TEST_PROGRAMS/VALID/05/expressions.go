/* Structs. */

package main

var x, y, i = 0, 0, 1

var a [10] int

func f() {
	return 100
}

var b, c = 3, 4

func g() {
	return true
}

func h() {
	return false
}

func main() {
	a[i] = x

	+x
	23 + 3 * a[i]
	x <= f()
	^b >> c
	g() || h()
	x == y+1 && c > 0
}
