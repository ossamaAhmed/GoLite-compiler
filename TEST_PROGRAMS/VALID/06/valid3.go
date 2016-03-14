// fibo using memoization

package main

var n = 10
var fib [10]int
func main(){
	fib[0]=1
	fib[1]=1
	fibo(10)
}

func fibo(n int) int {
	if n<=0 {
		return 0
	} else{
		f:=fib[n-1]
		if f==0 {
			f = fibo(n-1) + fibo(n-2)
			fib[n-1] = f
			println(f)
		}
		return f
	}
}
