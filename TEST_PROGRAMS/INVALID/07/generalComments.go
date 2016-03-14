// go lecture (6), slide 8

/* we are testing general comments as well
 */
//
qq//

package main

func fib(n int) int {
	a , b := 0 , 1
	for i := 0; i < n ; i ++ {
		a, b = b, a+b
	}
	return a
}

func main () {
	var f int = fib (42)
	println(f)
}
