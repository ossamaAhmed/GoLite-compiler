package main;
func plus(a int, b int) int {
	return ( a + b ) /*  */
}
func plusPlus(a int, b int, c int) int {
	return ( a + ( b + c ) /*  */ ) /*  */
}
func sum(a [] int, count int) int {
	for i := 0 /* int */; ( i < count ) /* bool */; i++ {
		total++;
	}
	return total
}
func main() {
	res := ( plus(1 /* int */, 2 /* int */) ) /* int */;
	println("1+2 =" /* string */, res)
	res = ( plusPlus(1 /* int */, 2 /* int */, 3 /* int */) ) /* int */;
	println("1+2+3 =" /* string */, res)
	( plusPlus(1 /* int */, 5 /* int */, 6 /* int */) ) /* int */;
}
