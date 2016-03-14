/* Solution to problem #1 of Project Euler */

package main

func sum_div_by(n, target int) int {
	sum := 0
	for i := 1; i < target; i++ {
		if (i%n==0) {
			sum += i
		}
	}
	return sum
}


func main() {
	print(sum_div_by(3,1000)+sum_div_by(5,1000)-sum_div_by(15,1000))
	print("\n")
}
