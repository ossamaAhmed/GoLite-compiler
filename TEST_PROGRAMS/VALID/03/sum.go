/*** Xoey's sum of all numbers **/
package main

func sum(arr []int) int {
	var x int = 0xaa
	n := len(arr)
	var sum int
	for ; n > 0; n-- {
		sum += arr[n-1]
	}
	return sum
}
