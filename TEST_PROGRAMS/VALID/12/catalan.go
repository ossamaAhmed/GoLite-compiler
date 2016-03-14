package main;

func catalan(n int) int {
	if n == 0 {
		return 1
	}
	
	return ((2*(2*n + 1))/(n + 2))*catalan(n - 1)
}

func main() {
	println(catalan(5))
}
